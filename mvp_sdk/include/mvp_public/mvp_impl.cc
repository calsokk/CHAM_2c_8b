#include <seal/galoiskeys.h>
#include <seal/seal.h>
#include <seal/util/polyarithsmallmod.h>
#include <seal/util/rlwe.h>  // seal::util::encrypt_zero_symmetric

#include <future>
#include <set>

#include "mvp_public/api_def.h"
#include "mvp_public/errors.h"
#include "mvp_public/types.h"
#include "mvp_public/util/ThreadPool.h"
#include "mvp_public/util/common.h"
#include "mvp_public/util/math.h"
#include "mvp_public/util/mem_guard.h"
#include "mvp_public/util/timer.h"

namespace gemini {
namespace mvp {

namespace internal {

bool transfom_from_ntt_inplace(RLWEPt& pt, const seal::SEALContext& context);

bool transform_to_ntt_inplace(RLWECt& ct, const seal::SEALContext& context);

bool add_inplace(RLWECt& ct0, const RLWECt& ct1,
                 const seal::SEALContext& context);

bool ckks_decrypt(const RLWECt& ct, const seal::SecretKey& sk,
                  const seal::SEALContext& context, RLWEPt& out);

bool add_plain_inplace(RLWECt& ct, const RLWEPt& pt,
                       const seal::SEALContext& context);

}  // namespace internal

class MVPPublicImpl {
 public:
  MVPPublicImpl(const MVPMetaInfo& config, const ModulusSwitchHelper& ms_helper,
                const seal::SEALContext& context)
      : config_(config), ms_helper_(ms_helper), seal_rt_(context) {
    check_config();
  }

  ~MVPPublicImpl() {}

  constexpr bool IsUseExtraPrime() const { return true; }

  void check_config() {
    is_proper_config_ = true;
    if (!seal_rt_.parameters_set()) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPublicImpl: invalid seal context");
    }

    if (scheme() != seal::scheme_type::ckks) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPublicImpl: scheme_type");
    }

    if (config_.nrows == 0 || config_.ncols == 0) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPublicImpl: 0 shape");
    }

    if (config_.nrows > global::kMaxNumRows) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPublicImpl: nrows out-of-bound");
    }

    if (config_.ncols > global::kMaxNumCols) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPublicImpl: ncols out-of-bound");
    }

    if (config_.ncols * config_.nrows >= 50331648UL) {
      is_proper_config_ = false;
      throw std::invalid_argument("MVPPrivImpl: not supported yet");
    }
  }

  bool config_ok() const { return is_proper_config_; }

  inline size_t poly_degree() const {
    return seal_rt_.key_context_data()->parms().poly_modulus_degree();
  }

  inline size_t num_ct_moduli() const {
    return seal_rt_.first_context_data()->chain_index() + 1;
  }

  inline uint64_t base_mask() const {
    return config_.base_mod_nbits < 64 ? (1ULL << config_.base_mod_nbits) - 1
                                       : static_cast<uint64_t>(-1);
  }

  inline seal::scheme_type scheme() const {
    return seal_rt_.key_context_data()->parms().scheme();
  }

  Status InitPtx(RLWEPt& pt, seal::parms_id_type pid) const {
    if (pid == seal::parms_id_zero) {
      pid = seal_rt_.first_parms_id();
    }
    auto cntxt_data = seal_rt_.get_context_data(pid);
    GM_REQUIRES(cntxt_data != nullptr, InvalidArgumentError("InitPtx"));
    const size_t num_moduli = cntxt_data->parms().coeff_modulus().size();
    const size_t num_elt = seal::util::mul_safe(num_moduli, poly_degree());
    pt.parms_id() = seal::parms_id_zero;  // SEAL requires id_zero for resize
    pt.resize(num_elt);
    pt.parms_id() = pid;
    GM_REQUIRES(pt.data() != nullptr, UnavailableError("SEAL malloc failed"));
    return Status::OK();
  }

  Status Vec2Poly(VecView vec, RLWEPt& pt, bool is_ntt_form,
                  bool is_use_extra_prime) const {
    using namespace seal::util;
    GM_REQUIRES(vec.size() > 0 && vec.size() <= poly_degree(),
                InvalidArgumentError("Vec2Poly: vec.size()"));
    GM_RETURN_IF_ERROR(InitPtx(pt, is_use_extra_prime
                                       ? seal_rt_.key_parms_id()
                                       : seal_rt_.first_parms_id()));

    auto cntxt_data = seal_rt_.get_context_data(pt.parms_id());
    auto ntt_tables = cntxt_data->small_ntt_tables();
    auto& modulus = cntxt_data->parms().coeff_modulus();
    size_t N = poly_degree();
    size_t n = vec.size();
    size_t num_moduli = modulus.size();
    // pt = qk*v mod q0, q1, ..., qk
    auto pt_ptr = pt.data();
    for (size_t j = 0; j < num_moduli; ++j, pt_ptr += N) {
      if (is_use_extra_prime && (j + 1) == num_moduli) {
        // qk*v mod qk = 0
        std::fill_n(pt_ptr, N, 0);
      } else {
        gsl::span<uint64_t> wrap_pt(pt_ptr, n);
        ms_helper_.ModulusUpAt(vec, j, wrap_pt);

        if (is_use_extra_prime) {
          uint64_t qk = modulus.back().value();
          multiply_poly_scalar_coeffmod(pt_ptr, n, qk, modulus[j], pt_ptr);
        }

        // zero the rest
        std::fill_n(pt_ptr + n, N - n, 0);
        if (is_ntt_form) ntt_negacyclic_harvey(pt_ptr, ntt_tables[j]);
      }
    }

    return Status::OK();
  }

  Status EncryptPoly(const RLWEPt& pt, const seal::PublicKey& pk,
                     bool is_ntt_form, std::string& out) const {
    // enc(pt) := enc(0) + (pt, 0)
    RLWECt ct;
    GM_CATCH_SEAL_ERROR(seal::util::encrypt_zero_asymmetric(
        pk, seal_rt_, pt.parms_id(), is_ntt_form, ct));
    // Add pt to ct[0]
    GM_REQUIRES(internal::add_plain_inplace(ct, pt, seal_rt_),
                InternalError("add_plain_inplace"));
    GM_REQUIRES_OK(EncodeSEALObject(ct, out),
                   InternalError("EncodeSEALObject failed"));
    return Status::OK();
  }

  Status EncryptPoly(const RLWEPt& pt, const seal::SecretKey& sk,
                     bool is_ntt_form, std::string& out) const {
    // enc(pt) := enc(0) + (pt, 0)
    RLWECt ct;
    GM_CATCH_SEAL_ERROR(seal::util::encrypt_zero_symmetric(
        sk, seal_rt_, pt.parms_id(), is_ntt_form, /*save_seed*/ true, ct));
    // Add pt to ct[0]
    GM_REQUIRES(internal::add_plain_inplace(ct, pt, seal_rt_),
                InternalError("add_plain_inplace"));
    GM_REQUIRES_OK(EncodeSEALObject(ct, out),
                   InternalError("EncodeSEALObject failed"));
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

  Status EncodeVector(const VecView input, std::vector<RLWEPt>& out,
                      bool is_ntt_form, bool is_use_extra_prime) const {
    GM_REQUIRES(config_ok(), UnavailableError("config "));
    GM_REQUIRES(input.num_elements() == ExpectMatVecInputLen(config_),
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
      VecView subvec(input_ptr + bgn, end - bgn);
      GM_RETURN_IF_ERROR(
          Vec2Poly(subvec, out[sv], is_ntt_form, is_use_extra_prime));
    }
    return Status::OK();
  }

  template <class KeyType>
  Status EncryptVector(VecView vec_share, const KeyType& key,
                       std::vector<std::string>& out) const {
    GM_REQUIRES(config_ok(), UnavailableError("config is not done properly"));
    GM_REQUIRES(vec_share.data() != nullptr,
                InvalidArgumentError("vector nullptr"));
    GM_REQUIRES(vec_share.size() == ExpectMatVecInputLen(config_),
                InvalidArgumentError("vector length mismatches the meta info"));
    GM_REQUIRES(seal::is_metadata_valid_for(key, seal_rt_),
                InvalidArgumentError("invalid key"));

    uint64_t base_mask = this->base_mask();
    GM_REQUIRES(
        std::all_of(vec_share.data(), vec_share.data() + vec_share.size(),
                    [&base_mask](uint64_t v) { return v <= base_mask; }),
        OutOfRangeError("vec_share out-of-range [0, 2^k)"));

    bool is_ntt_form = std::strcmp(MVP_VERSION, "1.2.0") != 0;
    std::vector<RLWEPt> plain_polys;
    GM_RETURN_IF_ERROR(
        EncodeVector(vec_share, plain_polys, is_ntt_form, IsUseExtraPrime()));

    out.resize(plain_polys.size());
    for (size_t idx = 0; idx < plain_polys.size(); ++idx) {
      MemGuard auto_clean(plain_polys[idx]);
      GM_RETURN_IF_ERROR(
          EncryptPoly(plain_polys[idx], key, is_ntt_form, out[idx]));
    }
    return Status::OK();
  }

  Status UpdateMatVec(VecView plain_vec, StrBufView cipher_vec,
                      std::vector<std::string>& out_cipher) {
    using namespace gemini;
    const size_t N = poly_degree();
    // clang-format off
    GM_REQUIRES(config_ok(), UnavailableError("configuartion is not done properly"));
    GM_REQUIRES(plain_vec.num_elements() == config_.ncols, InvalidArgumentError("plain_vec length"));
    GM_REQUIRES(plain_vec.num_elements() <= N, InvalidArgumentError("plain_vec length"));
    // clang-format on

    GM_REQUIRES(cipher_vec.size() == 1,
                InvalidArgumentError("UpdateVector: cipher_vec.size()"));

    std::vector<RLWECt> ct_vec;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(cipher_vec, ct_vec));

    std::vector<RLWEPt> ecd_vec;
    bool is_ntt_form = ct_vec[0].is_ntt_form();
    bool is_use_extra_prime =
        ct_vec[0].coeff_modulus_size() == global::kNumModulus;
    if (plain_vec.num_elements() == N) {
      GM_RETURN_IF_ERROR(
          EncodeVector(plain_vec, ecd_vec, is_ntt_form, is_use_extra_prime));
    } else {
      std::vector<uint64_t> aligned_plain_vec(N, 0);
      size_t aligned_sze = NextPow2(plain_vec.num_elements());
      size_t gap = N / aligned_sze;
      for (size_t i = 0, j = 0; i < plain_vec.num_elements(); i++, j += gap) {
        aligned_plain_vec[j] = plain_vec.data()[i];
      }
      auto saved_config = config_;
      config_.ncols = N;
      GM_RETURN_IF_ERROR(EncodeVector(aligned_plain_vec, ecd_vec, is_ntt_form,
                                      is_use_extra_prime));
      config_ = saved_config;
    }
    GM_REQUIRES(ecd_vec.size() == 1,
                InternalError("UpdateVector: ecd_vec.size()"));

    out_cipher.resize(1);
    GM_REQUIRES(internal::add_plain_inplace(ct_vec[0], ecd_vec[0], seal_rt_),
                InvalidArgumentError("add_plain_inplace"));
    GM_RETURN_IF_ERROR(EncodeSEALObject(ct_vec[0], out_cipher[0]));
    return Status::OK();
  }




    Status AddMatVec(StrBufView cipher_vec_1, StrBufView cipher_vec_2,
                      std::vector<std::string>& out_cipher) {
    using namespace gemini;
    const size_t N = poly_degree();
    // clang-format off
    GM_REQUIRES(config_ok(), UnavailableError("configuartion is not done properly"));
    //GM_REQUIRES(plain_vec.num_elements() == config_.ncols, InvalidArgumentError("plain_vec length"));
    //GM_REQUIRES(plain_vec.num_elements() <= N, InvalidArgumentError("plain_vec length"));
    // clang-format on

    GM_REQUIRES(cipher_vec_1.size() == 1,
                InvalidArgumentError("UpdateVector: cipher_vec.size()"));

    std::vector<RLWECt> ct_vec_1;
    std::vector<RLWECt> ct_vec_2;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(cipher_vec_1, ct_vec_1));
    GM_RETURN_IF_ERROR(DecodeSEALObjects(cipher_vec_2, ct_vec_2));

   /*
    std::vector<RLWEPt> ecd_vec;
    bool is_ntt_form = ct_vec[0].is_ntt_form();
    bool is_use_extra_prime =
        ct_vec[0].coeff_modulus_size() == global::kNumModulus;
    if (plain_vec.num_elements() == N) {
      GM_RETURN_IF_ERROR(
          EncodeVector(plain_vec, ecd_vec, is_ntt_form, is_use_extra_prime));
    } else {
      std::vector<uint64_t> aligned_plain_vec(N, 0);
      size_t aligned_sze = NextPow2(plain_vec.num_elements());
      size_t gap = N / aligned_sze;
      for (size_t i = 0, j = 0; i < plain_vec.num_elements(); i++, j += gap) {
        aligned_plain_vec[j] = plain_vec.data()[i];
      }
      auto saved_config = config_;
      config_.ncols = N;
      GM_RETURN_IF_ERROR(EncodeVector(aligned_plain_vec, ecd_vec, is_ntt_form,
                                      is_use_extra_prime));
      config_ = saved_config;
    }
    GM_REQUIRES(ecd_vec.size() == 1,
                InternalError("UpdateVector: ecd_vec.size()"));
    */

    out_cipher.resize(1);
    GM_REQUIRES(internal::add_inplace(ct_vec_1[0], ct_vec_2[0], seal_rt_),
                InvalidArgumentError("add_cypher_inplace"));
    GM_RETURN_IF_ERROR(EncodeSEALObject(ct_vec_1[0], out_cipher[0]));
    return Status::OK();
  }

  Status AddVector(VecView plain_vec, StrBufView cipher_vec,
                   const seal::PublicKey& pk,
                   std::vector<std::string>& out_cipher) const {
    using namespace gemini;
    // clang-format off
    GM_REQUIRES(config_ok(), UnavailableError("configuartion is not done properly"));
    GM_REQUIRES(plain_vec.num_elements() == config_.ncols, InvalidArgumentError("vec_to_add length"));
    // clang-format on

    const size_t N = poly_degree();
    auto submat_shape = GetSubmatrixShape(config_, N);
    GM_REQUIRES(cipher_vec.size() == CeilDiv(config_.ncols, submat_shape[1]),
                InvalidArgumentError("AddVector: cipher_vec.size()"));

    bool santi_check = !IsUseExtraPrime();
    std::vector<RLWECt> ct_vec;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(cipher_vec, ct_vec, santi_check));
    if (!santi_check) {
      for (auto& ct : ct_vec) {
        GM_REQUIRES(seal::is_metadata_valid_for(ct, seal_rt_, true),
                    InvalidArgumentError("invalid cipher"));
      }
    }

    std::vector<RLWEPt> ecd_vec;
    bool is_ntt_form = ct_vec[0].is_ntt_form();
    bool is_use_extra_prime =
        ct_vec[0].coeff_modulus_size() == global::kNumModulus;
    GM_RETURN_IF_ERROR(
        EncodeVector(plain_vec, ecd_vec, is_ntt_form, is_use_extra_prime));
    GM_REQUIRES(ecd_vec.size() == ct_vec.size(),
                InvalidArgumentError("Execute: vec_to_add.size()"));

    out_cipher.resize(ecd_vec.size());
    for (size_t i = 0; i < ecd_vec.size(); ++i) {
      GM_REQUIRES(internal::add_plain_inplace(ct_vec[i], ecd_vec[i], seal_rt_),
                  InvalidArgumentError("add_plain_inplace"));
      RLWECt zero;
      GM_CATCH_SEAL_ERROR(seal::util::encrypt_zero_asymmetric(
          pk, seal_rt_, ct_vec[i].parms_id(), ct_vec[i].is_ntt_form(), zero));
      GM_CATCH_SEAL_ERROR(internal::add_inplace(ct_vec[i], zero, seal_rt_));
      GM_RETURN_IF_ERROR(EncodeSEALObject(ct_vec[i], out_cipher[i]));
    }
    return Status::OK();
  }

  Status Decrypt(StrBufView in, const seal::SecretKey& sk, VecBuffer& out) {
    using namespace seal::util;
    GM_REQUIRES(config_ok(), UnavailableError("config is not done properly"));
    GM_REQUIRES(out.size() == config_.nrows,
                InvalidArgumentError("output buffer length mismatch"));

    size_t expected_size = CeilDiv<size_t>(config_.nrows, poly_degree());
    GM_REQUIRES(in.size() == expected_size,
                InvalidArgumentError("Decrypt in.size()"));

    std::vector<seal::Ciphertext> ct_array;
    GM_RETURN_IF_ERROR(DecodeSEALObjects(in, ct_array));

    if (ct_array.size() != 1) {
      return UnimplementedError("multiple outputs is not supported yet");
    }

    auto& ct = ct_array[0];
    auto cntxt_data = seal_rt_.get_context_data(ct.parms_id());

    GM_REQUIRES(internal::transform_to_ntt_inplace(ct, seal_rt_),
                InternalError("transform_to_ntt_inplace"));
    RLWEPt pt;
    GM_REQUIRES(internal::ckks_decrypt(ct, sk, seal_rt_, pt),
                InternalError("ckks_decrypt"));
    // CKKS decryption is given in ntt form, conver to positional form first
    GM_REQUIRES(internal::transfom_from_ntt_inplace(pt, seal_rt_),
                InternalError("transfom_from_ntt_inplace"));

    size_t num_moduli = cntxt_data->parms().coeff_modulus().size();
    size_t N = poly_degree();

    // For a n-rows matrix, the (N/NextPow2(n))*i-th coefficient of the
    // decryption contains the mat-vec result, for i in 0, 1, ..., n-1.
    if (config_.nrows < N) {
      size_t coeff_stride = N / NextPow2(config_.nrows);
      std::vector<uint64_t> coeffcients(config_.nrows * num_moduli, 0);
      for (size_t l = 0; l < num_moduli; ++l) {
        auto src_ptr = pt.data() + l * N;
        auto dst_ptr = coeffcients.data() + l * config_.nrows;
        for (size_t i = 0; i < config_.nrows; ++i) {
          // only take care the multiples of N/NextPow2(n)
          dst_ptr[i] = src_ptr[i * coeff_stride];
        }
      }

      MemGuard guard(coeffcients);
      VecView wrap(coeffcients.data(), coeffcients.size());
      GM_RETURN_IF_ERROR(ms_helper_.ModulusDownRNS(wrap, out));
    } else {
      // all coefficients are needed
      MemGuard guard(gsl::span<uint64_t>(pt.data(), pt.coeff_count()));
      VecView wrap(pt.data(), pt.coeff_count());
      GM_RETURN_IF_ERROR(ms_helper_.ModulusDownRNS(wrap, out));
    }

    return Status::OK();
  }

 private:
  bool is_proper_config_{true};
  MVPMetaInfo config_;
  const ModulusSwitchHelper& ms_helper_;
  const seal::SEALContext& seal_rt_;
};

namespace api {

Status Encrypt(MVPContextPtr rt, VecView in, const MVPMetaInfo& meta,
               const seal::SecretKey& sk, std::vector<std::string>& out) {
  GM_TRACE("Encrypt vector<{}> with secret key", in.num_elements());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));
  MVPPublicImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.EncryptVector(in, sk, out);
}

Status Encrypt(MVPContextPtr rt, VecView in, const MVPMetaInfo& meta,
               std::vector<std::string>& out) {
  GM_TRACE("Encrypt vector<{}> with public key", in.num_elements());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));
  MVPPublicImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  try {
    (void)rt->public_key();
  } catch (const std::runtime_error& e) {
    GM_LOG_ERROR("public key is absent");
    return UnavailableError("public key is absent");
  }
  return impl.EncryptVector(in, rt->public_key(), out);
}

Status AddVector(MVPContextPtr rt, VecView plain_vec, StrBufView cipher_vec,
                 const MVPMetaInfo& meta,
                 std::vector<std::string>& out_share_ct) {
  GM_TRACE("AddVector plain_vector<{}>, cipher_vectr<{}>",
           plain_vec.num_elements(), cipher_vec.size());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));
  MVPPublicImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  try {
    (void)rt->public_key();
  } catch (const std::runtime_error& e) {
    return UnavailableError("public key is absent");
  }
  return impl.AddVector(plain_vec, cipher_vec, rt->public_key(), out_share_ct);
}

Status UpdateMatVec(MVPContextPtr rt, VecView plain_vec, StrBufView cipher_vec,
                    const MVPMetaInfo& meta,
                    std::vector<std::string>& out_share_ct) {
  GM_TRACE("UpdateMatVec plain_vector<{}>, cipher_vectr<{}>",
           plain_vec.num_elements(), cipher_vec.size());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));

  MVPMetaInfo _meta = meta;
  _meta.is_transposed = false;
  _meta.nrows = 1;
  _meta.ncols = ExpectMatVecOutputLen(meta);
  MVPPublicImpl impl(_meta, rt->modsw_helper(), rt->seal_context());
  return impl.UpdateMatVec(plain_vec, cipher_vec, out_share_ct);
}

Status AddMatVec(MVPContextPtr rt, StrBufView cipher_vec_1, StrBufView cipher_vec_2,
                    const MVPMetaInfo& meta,
                    std::vector<std::string>& out_share_ct) {
  GM_TRACE("AddMatVec cipher_vector_1<{}>, cipher_vectr_2<{}>",
           cipher_vec_1.size(), cipher_vec_2.size());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));

  MVPMetaInfo _meta = meta;
  _meta.is_transposed = false;
  _meta.nrows = 1;
  _meta.ncols = ExpectMatVecOutputLen(meta);
  MVPPublicImpl impl(_meta, rt->modsw_helper(), rt->seal_context());
  return impl.AddMatVec(cipher_vec_1, cipher_vec_2, out_share_ct);
}

Status DecryptMatVec(MVPContextPtr rt, StrBufView in, const MVPMetaInfo& meta,
                     const seal::SecretKey& sk, VecBuffer& out) {
  GM_TRACE("DecryptMatVec out<{}>", out.size());
  GM_REQUIRES(rt, InvalidArgumentError("MVPContext null"));
  MVPPublicImpl impl(meta, rt->modsw_helper(), rt->seal_context());
  return impl.Decrypt(in, sk, out);
}

}  // namespace api
}  // namespace mvp
}  // namespace gemini
