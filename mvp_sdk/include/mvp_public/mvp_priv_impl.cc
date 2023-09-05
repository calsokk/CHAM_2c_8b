#include <seal/galoiskeys.h>
#include <seal/seal.h>
#include <seal/util/polyarithsmallmod.h>
#include <seal/util/rlwe.h>

#include <future>
#include <set>

#include "mvp_public/api_def.h"
#include "mvp_public/errors.h"
#include "mvp_public/mvp_context.h"
#include "mvp_public/types.h"
#include "mvp_public/util/ThreadPool.h"
#include "mvp_public/util/common.h"
#include "mvp_public/util/defines.h"
#include "mvp_public/util/math.h"
#include "mvp_public/util/mem_guard.h"
#include "mvp_public/util/slotful_ntt.h"
#include "mvp_public/util/timer.h"

// (NOTE) defined in mvp_public/F3/mvp_fpga_lib.h
extern int KernelRun(unsigned int n, unsigned int m,
                     unsigned long* h_vec_data[], int vec_length,
                     int vec_chuck_size, unsigned long* h_mat_data[],
                     int mat_length, int mat_chuck_size,
                     long unsigned int* h_result);

// NOTE(juhou): transpose a 2D matrix inplace
// https://www.geeksforgeeks.org/inplace-m-x-n-size-matrix-transpose/
template <typename T>
void TransposeInplace(T* flatten, size_t nrows, size_t ncols) {
  size_t size = nrows * ncols - 1;
  size_t next;
  size_t cycleBegin;
  size_t i;
  std::set<size_t> b;

  b.insert(0);
  b.insert(size);
  i = 1;  // Note that A[0] and A[size-1] won't move
  while (i < size) {
    cycleBegin = i;
    auto t = flatten[i];
    do {
      next = (i * nrows) % size;
      std::swap(flatten[next], t);
      b.insert(i);
      i = next;
    } while (i != cycleBegin);
    // Get Next Move (what about querying random location?)
    for (i = 1; i < size && b.count(i) > 0; i++)
      ;
  }
}

namespace gemini::mvp {

enum class Role {
  encrypt_input,
  encode_inut,
  encode_weight,
};

namespace internal {

bool add_plain_inplace(RLWECt& ct, const RLWEPt& pt,
                       const seal::SEALContext& context);

}  // namespace internal

class MVPPrivImpl {
 public:
  static constexpr int SHARE_BITS = 64;

  MVPPrivImpl(const MVPMetaInfo& config, const ModulusSwitchHelper& ms_helper,
              const seal::SEALContext& context)
      : config_(config), ms_helper_(ms_helper), seal_rt_(context) {
    check_config();
  }

  ~MVPPrivImpl() {}

  constexpr bool IsUseExtraPrime() const { return true; }

  void check_config() {
    is_proper_config_ = true;

    if (!seal_rt_.parameters_set()) {
      is_proper_config_ = false;
      GM_LOG_FATAL("invalid SEALContext");
      throw std::invalid_argument("invalid seal context");
    }

    if (!config_.nrows || !config_.ncols) {
      is_proper_config_ = false;
      GM_LOG_FATAL("0 shape: nrows {} or ncols {}", config_.nrows,
                   config_.ncols);
      throw std::invalid_argument("MVPPrivImpl: 0 shape");
    }

    if (config_.nrows < 2 || config_.nrows > global::kMaxNumRows) {
      is_proper_config_ = false;
      GM_LOG_FATAL("nrows {} out-of-bound", config_.nrows);
      throw std::invalid_argument("MVPPrivImpl: nrows out-of-bound");
    }

    if (config_.ncols > global::kMaxNumCols) {
      is_proper_config_ = false;
      GM_LOG_FATAL("ncols {} out-of-bound", config_.ncols);
      throw std::invalid_argument("MVPPrivImpl: ncols out-of-bound");
    }

    if (config_.ncols * config_.nrows >= 50331648UL) {
      is_proper_config_ = false;
      GM_LOG_FATAL("shape {}x{} is not supported yet", config_.nrows,
                   config_.ncols);
      throw std::invalid_argument("MVPPrivImpl: not supported yet");
    }
  }

  uint32_t CPRNG(size_t nbytes, uint8_t* dst) {
    static std::mutex prng_lock;
    static uint64_t bytes_gen = 0;
    constexpr uint64_t kMaxBytes = 1ULL << 40;
    if (nbytes >= kMaxBytes) {
      GM_LOG_ERROR("CPRNG nbyte {} out-of-bound", nbytes);
      throw std::invalid_argument("CPRNG: nbytes");
      return -1;
    }
    if (nbytes > 0 && dst) {
      // lazy init the prng
      std::lock_guard prng_guard(prng_lock);
      if (prng_ == nullptr || bytes_gen >= kMaxBytes) {
        prng_ =
            seal_rt_.key_context_data()->parms().random_generator()->create();
        bytes_gen = 0;
      }
      prng_->generate(nbytes, reinterpret_cast<seal::seal_byte*>(dst));
      bytes_gen += nbytes;
      return 0;
    }
    return -1;
  }

  bool config_ok() const { return is_proper_config_; }

  inline size_t poly_degree() const {
    return seal_rt_.key_context_data()->parms().poly_modulus_degree();
  }

  inline size_t num_moduli() const {
    return seal_rt_.key_context_data()->chain_index();
  }

  inline int logq() const {
    return seal_rt_.first_context_data()->total_coeff_modulus_bit_count();
  }

  inline seal::scheme_type scheme() const {
    return seal_rt_.key_context_data()->parms().scheme();
  }

  Status InitPtx(RLWEPt& pt,
                 seal::parms_id_type pid = seal::parms_id_zero) const {
    if (pid == seal::parms_id_zero) {
      pid = seal_rt_.first_parms_id();
    }
    auto cntxt_data = seal_rt_.get_context_data(pid);
    GM_REQUIRES(cntxt_data != nullptr, InvalidArgumentError("InitPtx"));
    const size_t num_moduli = cntxt_data->parms().coeff_modulus().size();
    const size_t num_elt = seal::util::mul_safe(num_moduli, poly_degree());
    pt.parms_id() = seal::parms_id_zero;  // foo SEAL when using BFV
    pt.resize(num_elt);
    pt.parms_id() = pid;
    GM_REQUIRES(pt.data() != nullptr, UnavailableError("SEAL malloc failed"));
    return Status::OK();
  }

  Status CenteralizeAt(VecView src, size_t mod_idx,
                       gsl::span<uint64_t> out) const {
    using namespace seal::util;
    const auto& modulus = seal_rt_.key_context_data()->parms().coeff_modulus();
    GM_REQUIRES(mod_idx >= 0 && mod_idx < modulus.size(),
                InvalidArgumentError("Centeralize: invalid mod_idx"));
    GM_REQUIRES(src.size() == out.size(),
                InvalidArgumentError("Centeralize: size mismatch"));
    GM_REQUIRES(config_.base_mod_nbits <= 64,
                FailedPreconditionError("support at most 64bit"));
    const auto& mod_qj = modulus[mod_idx];

    uint64_t half = 1ULL << (config_.base_mod_nbits - 1);
    uint64_t base_mod_mask =
        config_.base_mod_nbits == 64 ? -1 : (1ULL << config_.base_mod_nbits);

    std::transform(src.data(), src.data() + src.size(), out.data(),
                   [&](uint64_t x) {
                     if (half <= x) {
                       return negate_uint_mod((-x) & base_mod_mask, mod_qj);
                     } else {
                       return barrett_reduce_64(x, mod_qj);
                     }
                   });

    return Status::OK();
  }

  Status Vec2Poly(const uint64_t* vec, size_t len, RLWEPt& pt, const Role role,
                  bool is_ntt_form = true) const {
    using namespace seal::util;
    bool use_extra_prime = IsUseExtraPrime();
    bool need_scale_up = role != Role::encode_weight;
    GM_RETURN_IF_ERROR(InitPtx(pt, use_extra_prime
                                       ? seal_rt_.key_parms_id()
                                       : seal_rt_.first_parms_id()));

    auto cntxt_data = seal_rt_.get_context_data(pt.parms_id());
    const auto& ntt_tables = cntxt_data->small_ntt_tables();
    const size_t N = poly_degree();
    const auto& modulus = cntxt_data->parms().coeff_modulus();
    const size_t num_moduli = modulus.size();
    uint64_t* pt_ptr = pt.data();
    VecView vec_view(vec, len);
    for (size_t j = 0; j < num_moduli; ++j, pt_ptr += N) {
      if ((j + 1) == num_moduli && use_extra_prime && need_scale_up) {
        std::fill_n(pt_ptr, N, 0);
        continue;
      }

      gsl::span<uint64_t> pt_wrap(pt_ptr, len);
      if (role == Role::encrypt_input) {
        GM_RETURN_IF_ERROR(ms_helper_.ModulusUpAt(vec_view, j, pt_wrap));
      } else if (role == Role::encode_inut) {
        GM_RETURN_IF_ERROR(ms_helper_.ModulusUpAt(vec_view, j, pt_wrap));
      } else if (role == Role::encode_weight) {
        GM_RETURN_IF_ERROR(CenteralizeAt(vec_view, j, pt_wrap));
      } else {
        return InternalError("impossible hit");
      }

      const auto& mod_qj = modulus[j];
      if (use_extra_prime && need_scale_up) {
        uint64_t qk = modulus.back().value();
        multiply_poly_scalar_coeffmod(pt_ptr, len, qk, mod_qj, pt_ptr);
      }

      std::fill_n(pt_ptr + len, N - len, 0);
      if (is_ntt_form) {
        ntt_forward({pt_ptr, N}, ntt_tables[j]);
      }
    }

    return Status::OK();
  }

  Status EncodeVector(const VecView input, std::vector<RLWEPt>& out,
                      bool is_ntt_form = true) const {
    GM_REQUIRES(config_ok(), UnavailableError("config "));
    GM_REQUIRES(input.num_elements() == config_.is_transposed ? config_.ncols
                                                              : config_.nrows,
                InvalidArgumentError("input.num_elements()"));

    auto submat_shape = GetSubmatrixShape(config_, poly_degree());
    size_t vector_len = input.num_elements();
    size_t subvec_len = submat_shape[1];
    size_t num_subvec = CeilDiv(vector_len, subvec_len);
    auto input_ptr = input.data();

    out.resize(num_subvec);
    for (size_t sv = 0; sv < num_subvec; ++sv) {
      size_t bgn = sv * subvec_len;
      size_t end = std::min(bgn + subvec_len, vector_len);
      GM_RETURN_IF_ERROR(Vec2Poly(input_ptr + bgn, end - bgn, out[sv],
                                  Role::encode_inut, is_ntt_form));
    }
    return Status::OK();
  }

  Status RandomVector(RLWEPt& mask, VecBuffer& out) {
    using namespace seal::util;
    auto cntxt_data = seal_rt_.first_context_data();
    GM_REQUIRES(cntxt_data != nullptr,
                InvalidArgumentError("invalid first_context_data"));
    GM_REQUIRES(out.data() != nullptr, InvalidArgumentError("out nullptr"));
    GM_REQUIRES(out.size() > 0 && (poly_degree() % out.size() == 0),
                InvalidArgumentError("out.num_elements()"));

    auto& coeff_modulus = cntxt_data->parms().coeff_modulus();
    const size_t num_moduli = coeff_modulus.size();
    const size_t N = poly_degree();
    const size_t n = out.size();

    // Uniform in r \in [0, Q) in the RNS form
    std::vector<uint64_t> _random(n * num_moduli);
    for (size_t limb = 0; limb < num_moduli; ++limb) {
      constexpr uint64_t max_random = static_cast<uint64_t>(-1);
      uint64_t max_multiple =
          max_random - barrett_reduce_64(max_random, coeff_modulus[limb]) - 1;
      uint64_t* dst = _random.data() + n * limb;
      CPRNG(n * sizeof(uint64_t), reinterpret_cast<uint8_t*>(dst));
      std::transform(dst, dst + n, dst, [&](uint64_t rand) {
        // This ensures uniform distribution
        while (rand >= max_multiple) {
          CPRNG(sizeof(uint64_t), reinterpret_cast<uint8_t*>(&rand));
        }
        return barrett_reduce_64(rand, coeff_modulus[limb]);
      });
    }

    // Put the sampled values to coefficients of polynomial
    mask.parms_id() = seal::parms_id_zero;
    mask.resize(mul_safe(num_moduli, N));
    mask.parms_id() = cntxt_data->parms_id();
    const size_t gap = N / n;
    for (size_t j = 0; j < num_moduli; ++j) {
      uint64_t* dst_ptr = mask.data() + j * N;
      const uint64_t* src_ptr = _random.data() + j * n;
      if (N == n) {
        std::copy_n(src_ptr, N, dst_ptr);
      } else {
        std::fill_n(dst_ptr, N, 0);
        for (size_t i = 0, j = 0; i < n; ++i, j += gap) {
          dst_ptr[j] = src_ptr[i];
        }
      }
    }

    // ModulusDown from [0, Q) to [0, 2^k) by divide-then-round
    GM_RETURN_IF_ERROR(ms_helper_.ModulusDownRNS(_random, out));

    // flip the sign
    uint64_t base_mod_mask = config_.base_mod_nbits >= 64
                                 ? -1
                                 : (1ULL << config_.base_mod_nbits) - 1;
    std::transform(out.data(), out.data() + out.size(), out.data(),
                   [&](uint64_t u) { return (-u) & base_mod_mask; });
    return Status::OK();
  }

  template <class Obj>
  Status EncodeSEALObject(const Obj& obj, std::string& out) const {
    std::ostringstream os;
    GM_CATCH_SEAL_ERROR(obj.save(os));
    out = os.str();
    return Status::OK();
  }

  template <class Obj>
  Status DecodeSEALObjects(StrBufView in, std::vector<Obj>& out,
                           bool santi_check = true) const {
    if (in.size() == 0) return Status::OK();
    out.resize(in.size());
    for (size_t i = 0; i < in.size(); ++i) {
      if (santi_check) {
        GM_CATCH_SEAL_ERROR(out[i].load(
            seal_rt_, reinterpret_cast<const seal::seal_byte*>(in[i].c_str()),
            in[i].length()));
      } else {
        GM_CATCH_SEAL_ERROR(out[i].unsafe_load(
            seal_rt_, reinterpret_cast<const seal::seal_byte*>(in[i].c_str()),
            in[i].length()));
      }
    }
    return Status::OK();
  }

  Status DropUnusedCoeffs(RLWECt& ct) const {
    GM_REQUIRES(ct.size() == 2 && !ct.is_ntt_form(),
                InvalidArgumentError("DropUnusedCoeffs"));
    size_t degree = ct.poly_modulus_degree();
    size_t gap = (degree / NextPow2(config_.nrows)) - 1;  // 2^k - 1
    for (size_t l = 0; l < ct.coeff_modulus_size(); ++l) {
      uint64_t* ct0 = ct.data(0) + l * degree;
      for (size_t pos = 0; pos < degree; ++pos) {
        if ((pos & gap) == 0) continue;
        ct0[pos] = 0;
      }

      ct0 += degree;
    }
    return Status::OK();
  }

  Status MatVecCore(std::shared_ptr<MVPContext> rt,
                    const std::vector<RLWECt>& ct_vec,
                    const std::vector<RLWEPt>& pt_mat, RLWECt* out) {
    GM_REQUIRES(out != nullptr, InvalidArgumentError("FPGAv12: nullptr out"));
    const size_t N = poly_degree();
    auto submat_shape = GetSubmatrixShape(config_, N);
    size_t num_row_blks = CeilDiv(NextPow2(config_.nrows), submat_shape[0]);
    size_t num_col_blks = CeilDiv(config_.ncols, submat_shape[1]);

    GM_REQUIRES(ct_vec.size() == num_col_blks,
                InvalidArgumentError("FPGAv12: ct_vec.size()"));

    GM_REQUIRES(pt_mat.size() > 1, InternalError("mat_len should > 1"));
    GM_REQUIRES(pt_mat.size() == num_row_blks * num_col_blks,
                InvalidArgumentError("FPGAv12: pt_mat.size()"));

    bool is_input_ntt = std::strcmp(MVP_VERSION, "1.2.0") != 0;
    // FPGAv12 requires non-ntt RLWECt
    for (auto& ct : ct_vec) {
      GM_REQUIRES(ct.is_ntt_form() == is_input_ntt,
                  InvalidArgumentError("ct.is_ntt_form() mismatch"));
      GM_REQUIRES(ct.coeff_modulus_size() == global::kNumModulus,
                  InvalidArgumentError("ct.coeff_modulus_size() mismatch"));
    }

    // Pointers to each RLWE cipher in bit-reversed order
    int mat_len = static_cast<int>(pt_mat.size());
    int vec_len = static_cast<int>(num_col_blks);
    int log2_nrows = gemini::Log2(num_row_blks);

    int mat_chuck_size = 0;
    std::vector<unsigned long*> h_mat(mat_len);
    // The pointer arrangement follows some tricky spec here.
    for (size_t rblk = 0; rblk < num_row_blks; ++rblk) {
      size_t offset = rblk * num_col_blks;
      size_t rev_rblk = seal::util::reverse_bits(rblk, log2_nrows);
      size_t rev_offset = rev_rblk * num_col_blks;

      for (size_t cblk = 0; cblk < num_col_blks; ++cblk) {
        h_mat[offset + cblk] =
            const_cast<unsigned long*>(pt_mat.at(rev_offset + cblk).data());
        mat_chuck_size = std::max<int>(
            pt_mat[rev_offset + cblk].coeff_count() * sizeof(uint64_t),
            mat_chuck_size);
      }

      // NOTE(juhou) we transpose submatrix 2*num_col_blks for each two
      // row-blocks.
      if (rblk & 1) {
        TransposeInplace(h_mat.data() + (rblk - 1) * num_col_blks, 2,
                         num_col_blks);
      }
    }

    int vec_chuck_size = 0;
    std::vector<unsigned long*> h_vec(vec_len);
    for (int i = 0; i < vec_len; ++i) {
      h_vec[i] = const_cast<unsigned long*>(ct_vec.at(i).data());
      vec_chuck_size = ct_vec[i].size() * ct_vec[i].poly_modulus_degree() *
                       ct_vec[i].coeff_modulus_size() * sizeof(uint64_t);
    }

    out->resize(seal_rt_, seal_rt_.first_parms_id(), 2);

    unsigned int nrows = NextPow2(
        static_cast<unsigned int>(std::max(config_.nrows, submat_shape[0])));
    unsigned int ncols =
        static_cast<unsigned int>(std::max(config_.ncols, submat_shape[1]));

    // Some check for the v1.2 spec
    GM_REQUIRES(vec_len >= 1 && vec_len <= 4,
                InvalidArgumentError("num_col_blks out-of-bound"));
    GM_REQUIRES(IsTwoPower(nrows),
                InvalidArgumentError("nrows should be two-exponent"));
    GM_REQUIRES(ncols >= 1 && ncols <= 16384,
                InvalidArgumentError("ncols out-of-bound"));

    double kernel_time = 0.;
    MSecTimer _timer(&kernel_time);
    if (0 != KernelRun(nrows, ncols, h_vec.data(), vec_len, vec_chuck_size,
                       h_mat.data(), mat_len, mat_chuck_size,
                       const_cast<unsigned long*>(out->data()))) {
      return InternalError("KernelRun failed");
    }
    _timer.stop();

    out->is_ntt_form() = false;
    if (!seal::is_data_valid_for(*out, seal_rt_)) {
      GM_LOG_WARN("FPGA return invalid ct, please checkt out fpga card");
      return InternalError("FPGA return invalid ct");
    }
    GM_LOG_INFO("KernelRun {}x{} took {} ms", config_.nrows, config_.ncols, kernel_time);
    GM_TRACE("KernelRun done");
    return Status::OK();
  }

  Status MatVec(std::shared_ptr<MVPContext> rt, MatView mat,
                std::optional<VecView> vec_share0, StrBufView vec_share1,
                VecBuffer* out_mask, std::vector<std::string>& out) {
    using namespace gemini;
    GM_TRACE(
        "MatVec: mat<{}x{}>, vec_share<{}>, vec_share_ct<{}>, out_maskt<{}>",
        mat.nrows(), mat.ncols(), vec_share0 ? vec_share0->num_elements() : 0,
        vec_share1.size(), out_mask ? out_mask->num_elements() : 0);

    // clang-format off
    GM_REQUIRES(config_ok(), UnavailableError("configuartion is not done properly"));
    GM_REQUIRES(mat.ncols() == config_.ncols, InvalidArgumentError("mat.ncols()"));
    GM_REQUIRES(mat.nrows() == config_.nrows, InvalidArgumentError("mat.nrows()"));
    if (vec_share0) {
      GM_REQUIRES(vec_share0->num_elements() == config_.ncols, InvalidArgumentError("vec_share0 length"));
    }
    if (out_mask) {
      GM_REQUIRES(mat.nrows() == out_mask->num_elements(), InvalidArgumentError("out_mask length"));
      GM_REQUIRES(out_mask->data() != nullptr, InvalidArgumentError("out_mask is empty"));
    }
    // clang-format on

    const size_t N = poly_degree();
    auto submat_shape = GetSubmatrixShape(config_, N);
    GM_REQUIRES(vec_share1.size() == CeilDiv(config_.ncols, submat_shape[1]),
                InvalidArgumentError("Execute: vec_share1.size()"));

    // Async launch the sample random program first
    // mask_poly is in the non-ntt form
    RLWEPt mask_poly;
    auto sample_mask_program = [&]() {
      //printf("sample_mask_program is runing \n");
      if (!out_mask) {//printf("out mask do not nedd \n"); 
         return Status::OK();}
      if (N % out_mask->num_elements() == 0) {
        GM_RETURN_IF_ERROR(RandomVector(mask_poly, *out_mask));
      } else {
        VecBuffer tmp_buf(NextPow2(out_mask->num_elements()));
        gsl::span<uint64_t> _wrap(tmp_buf.data(), tmp_buf.num_elements());
        MemGuard guard(_wrap);
        GM_RETURN_IF_ERROR(RandomVector(mask_poly, tmp_buf));
        std::copy_n(tmp_buf.data(), out_mask->num_elements(), out_mask->data());
      }
      return Status::OK();
    };
    
    sample_mask_program();
    //auto sample_random_mask_task = rt->LaunchSubTask(sample_mask_program);

    // Step 1: Add two shares of vector
    bool santi_check = !IsUseExtraPrime();
    std::vector<RLWECt> ct_vec;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(vec_share1, ct_vec, santi_check));
    if (!santi_check) {
      // NOTE(juhou): We already skip the check in DecodeSEALObjects. We perform
      // some meta-check here.
      for (auto& ct : ct_vec) {
        GM_REQUIRES(seal::is_metadata_valid_for(ct, seal_rt_, true),
                    InvalidArgumentError("invalid cipher"));
      }
    }

    if (vec_share0) {
      std::vector<RLWEPt> share0;
      GM_RETURN_IF_ERROR(
          EncodeVector(*vec_share0, share0, ct_vec[0].is_ntt_form()));
      GM_REQUIRES(share0.size() == ct_vec.size(),
                  InvalidArgumentError("Execute: vec_share0.size()"));
      for (size_t i = 0; i < share0.size(); ++i) {
        GM_REQUIRES(internal::add_plain_inplace(ct_vec[i], share0[i], seal_rt_),
                    InvalidArgumentError("add_plain_inplace"));
      }
    }

    // Step 2: Encode matrix then multiply
    size_t row_blk_sze = submat_shape[0];
    size_t col_blk_sze = submat_shape[1];
    size_t nrows = NextPow2(mat.nrows());

    size_t num_row_blks = CeilDiv(nrows, row_blk_sze);
    size_t num_col_blks = CeilDiv(mat.ncols(), col_blk_sze);
    int log2_nrows = Log2(nrows - 1);  // floor(log2(rows))

    std::vector<RLWEPt> pt_mat(num_row_blks * num_col_blks);
    auto ecd_program = [&, this](size_t rblk_bgn, size_t rblk_end) {
      RLWEPt poly;
      std::vector<uint64_t> coeffs(N, 0);
      // NOTE(juhou):
      //   submatrix mat[row_bgn:row_end, col_bgn:col_end]
      //   zero_pad to submat_shape[0] rows and submat_shape[1] columns
      //   concate the zero-padded rows in the reversed ordering.

      // v1.2 export plain poly to non-ntt form
      bool is_ntt_form = std::strcmp("1.2.0", MVP_VERSION);
      for (size_t rblk = rblk_bgn; rblk < rblk_end; ++rblk) {
        // NOTE(juhou): FPGA needs the rows be arranged in bit-reversed order.
        size_t row_bgn = rblk * row_blk_sze;
        size_t row_end = row_bgn + row_blk_sze;
        size_t row_base = (rblk < num_row_blks / 2)
                              ? rblk
                              : nrows / 2 + rblk - num_row_blks / 2;
        std::vector<size_t> bit_reversed_rows(row_blk_sze);
        for (size_t i = 0; i < row_blk_sze; ++i) {
          bit_reversed_rows[i] =
              row_base + seal::util::reverse_bits(i, log2_nrows);
        }

        for (size_t cblk = 0; cblk < num_col_blks; ++cblk) {
          size_t col_bgn = cblk * col_blk_sze;
          size_t col_end = std::min(col_bgn + col_blk_sze, mat.ncols());
          size_t num_cols = col_end - col_bgn;
          uint64_t* dst = coeffs.data();

          for (size_t r = row_bgn; r < row_end; ++r) {
            size_t row_idx = bit_reversed_rows.at(r - row_bgn);
            // zero-padding on the right then revser ordering
            std::fill_n(dst, submat_shape[1] - num_cols, 0);
            dst += submat_shape[1];
            if (row_idx >= mat.nrows()) continue;
            const uint64_t* src = mat.row_at(row_idx) + col_bgn;
            std::copy_n(src, num_cols, std::reverse_iterator<uint64_t*>(dst));
          }

          // zero-pad the rest coefficients
          std::fill(dst, coeffs.data() + coeffs.size(), 0);

          GM_RETURN_IF_ERROR(Vec2Poly(coeffs.data(), coeffs.size(),
                                      pt_mat.at(rblk * num_col_blks + cblk),
                                      Role::encode_weight, is_ntt_form));
        }
      }
      return Status::OK();
    };

    size_t tpool_sze = rt->thread_pool_size();
    //std::vector<std::future<Status>> ecd_tasks;
    size_t ecd_work_load = CeilDiv(num_row_blks, tpool_sze);

    //double ecd_time{0};
    //MSecTimer timer(&ecd_time);
    for (size_t j = 0; j < tpool_sze; ++j) {
      size_t rblk_bgn = j * ecd_work_load;
      size_t rblk_end = std::min(rblk_bgn + ecd_work_load, num_row_blks);
      //if (j + 1 == tpool_sze) {
        //printf("error when ecd \n");
        // We need to wait the random mask task finish.
        //GM_RETURN_IF_ERROR(sample_random_mask_task.get());
      //}
      //ecd_tasks.emplace_back(
          //rt->LaunchSubTask(ecd_program, rblk_bgn, rblk_end));
      ecd_program(rblk_bgn, rblk_end);
    }

    //for (auto&& t : ecd_tasks) {
    //  GM_RETURN_IF_ERROR(t.get());
    //}
    //timer.stop();

    // Step 3 & Step 4 calling FPGA
    //   - [in] ct_vec.is_ntt_form() = false
    //   - [in] pt_mat.is_ntt_form() = false
    //   - [out] matvec.is_ntt_form() = false
    RLWECt matvec;
    GM_RETURN_IF_ERROR(MatVecCore(rt, ct_vec, pt_mat, &matvec));
    GM_REQUIRES(!matvec.is_ntt_form(),
                InternalError("matvec RLWE should in non-ntt form"));

    // Step 5. Masking (Optional)
    if (out_mask) {
      mask_poly.scale() = matvec.scale();
      internal::add_plain_inplace(matvec, mask_poly, seal_rt_);
      gsl::span<uint64_t> _wrap(mask_poly.data(), mask_poly.coeff_count());
      MemGuard guard(_wrap);
    }

    // Step 6. serialize the final result
    GM_RETURN_IF_ERROR(DropUnusedCoeffs(matvec));
    out.resize(1);
    return EncodeSEALObject(matvec, out[0]);
  }




  Status MatVec(std::shared_ptr<MVPContext> rt, MatView mat,
                std::optional<VecView> vec_share0, StrBufView vec_share1,
                VecBuffer* out_mask, std::vector<std::string>& out, bool MT_in_subblock) {
    using namespace gemini;
    GM_TRACE(
        "MatVec: mat<{}x{}>, vec_share<{}>, vec_share_ct<{}>, out_maskt<{}>",
        mat.nrows(), mat.ncols(), vec_share0 ? vec_share0->num_elements() : 0,
        vec_share1.size(), out_mask ? out_mask->num_elements() : 0);

    // clang-format off
    GM_REQUIRES(config_ok(), UnavailableError("configuartion is not done properly"));
    GM_REQUIRES(mat.ncols() == config_.ncols, InvalidArgumentError("mat.ncols()"));
    GM_REQUIRES(mat.nrows() == config_.nrows, InvalidArgumentError("mat.nrows()"));
    if (vec_share0) {
      GM_REQUIRES(vec_share0->num_elements() == config_.ncols, InvalidArgumentError("vec_share0 length"));
    }
    if (out_mask) {
      GM_REQUIRES(mat.nrows() == out_mask->num_elements(), InvalidArgumentError("out_mask length"));
      GM_REQUIRES(out_mask->data() != nullptr, InvalidArgumentError("out_mask is empty"));
    }
    // clang-format on

    const size_t N = poly_degree();
    auto submat_shape = GetSubmatrixShape(config_, N);
    GM_REQUIRES(vec_share1.size() == CeilDiv(config_.ncols, submat_shape[1]),
                InvalidArgumentError("Execute: vec_share1.size()"));

    // Async launch the sample random program first
    // mask_poly is in the non-ntt form
    RLWEPt mask_poly;
    auto sample_mask_program = [&]() {
      //printf("sample_mask_program is runing \n");
      if (!out_mask) {//printf("out mask do not nedd \n"); 
         return Status::OK();}
      if (N % out_mask->num_elements() == 0) {
        GM_RETURN_IF_ERROR(RandomVector(mask_poly, *out_mask));
      } else {
        VecBuffer tmp_buf(NextPow2(out_mask->num_elements()));
        gsl::span<uint64_t> _wrap(tmp_buf.data(), tmp_buf.num_elements());
        MemGuard guard(_wrap);
        GM_RETURN_IF_ERROR(RandomVector(mask_poly, tmp_buf));
        std::copy_n(tmp_buf.data(), out_mask->num_elements(), out_mask->data());
      }
      return Status::OK();
    };
    
    sample_mask_program();
    //auto sample_random_mask_task = rt->LaunchSubTask(sample_mask_program);

    // Step 1: Add two shares of vector
    bool santi_check = !IsUseExtraPrime();
    std::vector<RLWECt> ct_vec;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(vec_share1, ct_vec, santi_check));
    if (!santi_check) {
      // NOTE(juhou): We already skip the check in DecodeSEALObjects. We perform
      // some meta-check here.
      for (auto& ct : ct_vec) {
        GM_REQUIRES(seal::is_metadata_valid_for(ct, seal_rt_, true),
                    InvalidArgumentError("invalid cipher"));
      }
    }

    if (vec_share0) {
      std::vector<RLWEPt> share0;
      GM_RETURN_IF_ERROR(
          EncodeVector(*vec_share0, share0, ct_vec[0].is_ntt_form()));
      GM_REQUIRES(share0.size() == ct_vec.size(),
                  InvalidArgumentError("Execute: vec_share0.size()"));
      for (size_t i = 0; i < share0.size(); ++i) {
        GM_REQUIRES(internal::add_plain_inplace(ct_vec[i], share0[i], seal_rt_),
                    InvalidArgumentError("add_plain_inplace"));
      }
    }

    // Step 2: Encode matrix then multiply
    size_t row_blk_sze = submat_shape[0];
    size_t col_blk_sze = submat_shape[1];
    size_t nrows = NextPow2(mat.nrows());

    size_t num_row_blks = CeilDiv(nrows, row_blk_sze);
    size_t num_col_blks = CeilDiv(mat.ncols(), col_blk_sze);
    int log2_nrows = Log2(nrows - 1);  // floor(log2(rows))

    std::vector<RLWEPt> pt_mat(num_row_blks * num_col_blks);
    auto ecd_program = [&, this](size_t rblk_bgn, size_t rblk_end) {
      RLWEPt poly;
      std::vector<uint64_t> coeffs(N, 0);
      // NOTE(juhou):
      //   submatrix mat[row_bgn:row_end, col_bgn:col_end]
      //   zero_pad to submat_shape[0] rows and submat_shape[1] columns
      //   concate the zero-padded rows in the reversed ordering.

      // v1.2 export plain poly to non-ntt form
      bool is_ntt_form = std::strcmp("1.2.0", MVP_VERSION);
      for (size_t rblk = rblk_bgn; rblk < rblk_end; ++rblk) {
        // NOTE(juhou): FPGA needs the rows be arranged in bit-reversed order.
        size_t row_bgn = rblk * row_blk_sze;
        size_t row_end = row_bgn + row_blk_sze;
        size_t row_base = (rblk < num_row_blks / 2)
                              ? rblk
                              : nrows / 2 + rblk - num_row_blks / 2;
        std::vector<size_t> bit_reversed_rows(row_blk_sze);
        for (size_t i = 0; i < row_blk_sze; ++i) {
          bit_reversed_rows[i] =
              row_base + seal::util::reverse_bits(i, log2_nrows);
        }

        for (size_t cblk = 0; cblk < num_col_blks; ++cblk) {
          size_t col_bgn = cblk * col_blk_sze;
          size_t col_end = std::min(col_bgn + col_blk_sze, mat.ncols());
          size_t num_cols = col_end - col_bgn;
          uint64_t* dst = coeffs.data();

          for (size_t r = row_bgn; r < row_end; ++r) {
            size_t row_idx = bit_reversed_rows.at(r - row_bgn);
            // zero-padding on the right then revser ordering
            std::fill_n(dst, submat_shape[1] - num_cols, 0);
            dst += submat_shape[1];
            if (row_idx >= mat.nrows()) continue;
            const uint64_t* src = mat.row_at(row_idx) + col_bgn;
            std::copy_n(src, num_cols, std::reverse_iterator<uint64_t*>(dst));
          }

          // zero-pad the rest coefficients
          std::fill(dst, coeffs.data() + coeffs.size(), 0);

          GM_RETURN_IF_ERROR(Vec2Poly(coeffs.data(), coeffs.size(),
                                      pt_mat.at(rblk * num_col_blks + cblk),
                                      Role::encode_weight, is_ntt_form));
        }
      }
      return Status::OK();
    };

    size_t tpool_sze = rt->thread_pool_size();
    std::vector<std::future<Status>> ecd_tasks;
    size_t ecd_work_load = CeilDiv(num_row_blks, tpool_sze);

    //double ecd_time{0};
    //MSecTimer timer(&ecd_time);
    for (size_t j = 0; j < tpool_sze; ++j) {
      size_t rblk_bgn = j * ecd_work_load;
      size_t rblk_end = std::min(rblk_bgn + ecd_work_load, num_row_blks);
      //if (j + 1 == tpool_sze) {
        //printf("error when ecd \n");
        // We need to wait the random mask task finish.
        //GM_RETURN_IF_ERROR(sample_random_mask_task.get());
      //}
      if (MT_in_subblock) 
        ecd_tasks.emplace_back(rt->LaunchSubTask(ecd_program, rblk_bgn, rblk_end));
      else
        ecd_program(rblk_bgn, rblk_end);
    }

    if (MT_in_subblock) {
      for (auto&& t : ecd_tasks) {
        GM_RETURN_IF_ERROR(t.get());
      }
   }
    //timer.stop();


    // Step 3 & Step 4 calling FPGA
    //   - [in] ct_vec.is_ntt_form() = false
    //   - [in] pt_mat.is_ntt_form() = false
    //   - [out] matvec.is_ntt_form() = false
    RLWECt matvec;
    GM_RETURN_IF_ERROR(MatVecCore(rt, ct_vec, pt_mat, &matvec));
    GM_REQUIRES(!matvec.is_ntt_form(),
                InternalError("matvec RLWE should in non-ntt form"));

    // Step 5. Masking (Optional)
    if (out_mask) {
      mask_poly.scale() = matvec.scale();
      internal::add_plain_inplace(matvec, mask_poly, seal_rt_);
      gsl::span<uint64_t> _wrap(mask_poly.data(), mask_poly.coeff_count());
      MemGuard guard(_wrap);
    }

    // Step 6. serialize the final result
    GM_RETURN_IF_ERROR(DropUnusedCoeffs(matvec));
    out.resize(1);
    return EncodeSEALObject(matvec, out[0]);
  }




 private:
  MVPMetaInfo config_;
  bool is_proper_config_{true};
  bool disable_extra_prime_{false};
  const ModulusSwitchHelper& ms_helper_;
  const seal::SEALContext& seal_rt_;  // SEAL runtime

  std::shared_ptr<seal::UniformRandomGenerator> prng_{nullptr};
};

namespace api {

Status MatVec(MVPContextPtr rt, MatView mat, VecView vec_share,
              StrBufView vec_share_ct, const MVPMetaInfo& meta,
              VecBuffer& out_share, std::vector<std::string>& out_share_ct) {
  GM_REQUIRES(rt && rt->IsFPGAEnabled(),
              InvalidArgumentError("FPGA is not enabled yet"));
  MVPPrivImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.MatVec(rt, mat, vec_share, vec_share_ct, &out_share,
                     out_share_ct);
}

Status MatVec(MVPContextPtr rt, MatView mat, StrBufView vec_share_ct,
              const MVPMetaInfo& meta, std::vector<std::string>& out_share_ct) {
  GM_REQUIRES(rt && rt->IsFPGAEnabled(),
              InvalidArgumentError("FPGA is not enabled yet"));
  MVPPrivImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.MatVec(rt, mat, std::nullopt, vec_share_ct, nullptr,
                     out_share_ct);
}


Status MatVec(MVPContextPtr rt, MatView mat, StrBufView vec_share_ct,
              const MVPMetaInfo& meta, std::vector<std::string>& out_share_ct, bool MT_in_subblock) {
  GM_REQUIRES(rt && rt->IsFPGAEnabled(),
              InvalidArgumentError("FPGA is not enabled yet"));
  MVPPrivImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.MatVec(rt, mat, std::nullopt, vec_share_ct, nullptr,
                     out_share_ct, MT_in_subblock);
}


Status MatVec(MVPContextPtr rt, MatView mat, VecView vec_share,
              StrBufView vec_share_ct, const MVPMetaInfo& meta,
              std::vector<std::string>& out_share_ct) {
  GM_REQUIRES(rt && rt->IsFPGAEnabled(),
              InvalidArgumentError("FPGA is not enabled yet"));
  MVPPrivImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.MatVec(rt, mat, vec_share, vec_share_ct, nullptr, out_share_ct);
}

}  // namespace api
}  // namespace gemini::mvp
