#include "gtest/gtest.h"
#include "mvp_public/api_def.h"
#include "seal/seal.h"

using namespace gemini::mvp;

class MatVecTest : public testing::Test,
                   public testing::WithParamInterface<
                       std::tuple<int, std::tuple<size_t, size_t>>> {
 public:
  void SetUp() {
    mvp_context_ = MVPContext::Create(/*thread_pool*/ 2);
    EXPECT_TRUE(api::GenerateKey(mvp_context_, secret_key_).ok());
    EXPECT_TRUE(
        api::DeriveEvalKey(mvp_context_, secret_key_, seralized_eval_key_)
            .ok());
  }

 protected:
  inline uint64_t RealTo2k(double r, int precision) const {
    return static_cast<int64_t>(std::roundf(r * (1ULL << precision)));
  }

  inline double U2kToReal(uint64_t r, int precision) const {
    return static_cast<int64_t>(r) / std::pow(2., precision);
  }

  std::vector<uint64_t> RealToFixedPoint(const double* dst, size_t n,
                                         const int fxp) const {
    std::vector<uint64_t> ret(n);
    std::transform(dst, dst + n, ret.data(),
                   [&](double r) { return RealTo2k(r, fxp); });
    return ret;
  }

  void ShareIt(const std::vector<double>& reals, const int precision,
               std::vector<uint64_t>& share0,
               std::vector<uint64_t>& share1) const {
    size_t n = reals.size();
    if (n == 0) return;
    share0.resize(n);
    share1.resize(n);

    std::mt19937_64 rdv;
    rdv.seed(std::time(0));

    // sample from [0, 2^64)
    std::uniform_int_distribution<uint64_t> uniform(0,
                                                    static_cast<uint64_t>(-1));
    std::generate_n(share1.begin(), n, [&]() { return uniform(rdv); });

    for (size_t i = 0; i < n; ++i) {
      uint64_t x = RealTo2k(reals[i], precision);
      share0[i] = x - share1[i];
    }
  }

  std::vector<double> FixedPointToReal(const uint64_t* dst, size_t n,
                                       const int fxp) const {
    std::vector<double> ret(n);
    double scale = 1LL << fxp;
    std::transform(dst, dst + n, ret.data(),
                   [&](uint64_t r) { return static_cast<int64_t>(r) / scale; });
    return ret;
  }

  void RandomReal(double* dst, size_t n, double range) const {
    std::mt19937_64 rdv;
    rdv.seed(std::time(0));
    range = std::max(1., std::abs(range));
    std::uniform_real_distribution<double> uniform(-range, range);
    std::generate_n(dst, n, [&]() { return uniform(rdv); });
  }

  std::vector<uint64_t> MatVec(const std::vector<uint64_t>& mat,
                               const std::vector<uint64_t>& vec,
                               const MVPMetaInfo& meta) const {
    size_t nrows = meta.nrows;
    size_t ncols = meta.ncols;
    EXPECT_FALSE(meta.is_transposed);
    EXPECT_EQ(mat.size(), nrows * ncols);
    EXPECT_EQ(vec.size(), ncols);

    std::vector<uint64_t> ret(nrows);
    for (size_t r = 0; r < nrows; ++r) {
      ret[r] = 0;
      for (size_t c = 0; c < ncols; ++c) {
        ret[r] += mat[r * ncols + c] * vec[c];
      }
    }
    return ret;
  }

  api::MVPContextPtr mvp_context_;
  seal::SecretKey secret_key_;
  std::vector<std::string> seralized_eval_key_;
};

// out = mat*vec
TEST_P(MatVecTest, MatVec) {
  auto other_context = MVPContext::Create(4);
  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());
  EXPECT_TRUE(other_context->IsFPGAEnabled());
  auto parms = GetParam();

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  int fxp_prec = std::get<0>(parms);
  meta.nrows = std::get<0>(std::get<1>(parms));
  meta.ncols = std::get<1>(std::get<1>(parms));

  std::vector<double> mat(meta.nrows * meta.ncols);
  std::vector<double> vec(meta.ncols);

  RandomReal(mat.data(), mat.size(), 1.);
  RandomReal(vec.data(), vec.size(), 1.);

  auto mat_fxp = RealToFixedPoint(mat.data(), mat.size(), fxp_prec);
  auto vec_fxp = RealToFixedPoint(vec.data(), vec.size(), fxp_prec);
  auto matvec_ground = MatVec(mat_fxp, vec_fxp, meta);

  std::vector<std::string> encrypted_vec;
  VecView vec_view(vec_fxp.data(), meta.ncols);
  EXPECT_TRUE(
      api::Encrypt(mvp_context_, vec_view, meta, secret_key_, encrypted_vec)
          .ok());

  std::vector<std::string> encrypted_matvec(1);
  MatView mat_view(mat_fxp.data(), meta.nrows, meta.ncols);

  EXPECT_EQ(api::MatVec(other_context, mat_view, encrypted_vec, meta,
                        encrypted_matvec)
                .ToString(),
            "OK");

  VecBuffer matvec_fxp(meta.nrows);
  EXPECT_TRUE(api::DecryptMatVec(mvp_context_, encrypted_matvec, meta,
                                 secret_key_, matvec_fxp)
                  .ok());

  int64_t max_err{0};
  for (size_t i = 0; i < matvec_ground.size(); ++i) {
    int64_t err =
        std::abs(static_cast<int64_t>(matvec_ground[i] - matvec_fxp.data()[i]));
    max_err = std::max(max_err, err);
  }

  int nbits = (int)std::log2(1e-30 + max_err);
  EXPECT_LE(nbits, fxp_prec + 3)
      << "nrows = " << meta.nrows << " ncols=" << meta.ncols;
}

// out = mat*(vec0 + vec1)
TEST_P(MatVecTest, MatVecSecretSharedInput) {
  auto other_context = MVPContext::Create(4);

  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());
  EXPECT_TRUE(other_context->IsFPGAEnabled());

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  auto parms = GetParam();
  int fxp_prec = std::get<0>(parms);
  meta.nrows = std::get<0>(std::get<1>(parms));
  meta.ncols = std::get<1>(std::get<1>(parms));

  std::vector<double> mat(meta.nrows * meta.ncols);
  std::vector<double> vec0(meta.ncols);
  std::vector<double> vec1(meta.ncols);

  RandomReal(mat.data(), mat.size(), 1.);
  RandomReal(vec0.data(), vec0.size(), 1.);
  RandomReal(vec1.data(), vec1.size(), 1.);

  auto mat_fxp = RealToFixedPoint(mat.data(), mat.size(), fxp_prec);
  auto vec0_fxp = RealToFixedPoint(vec0.data(), vec0.size(), fxp_prec);
  auto vec1_fxp = RealToFixedPoint(vec1.data(), vec1.size(), fxp_prec);

  // symmetric encryption
  std::vector<std::string> encrypted_vec0;
  VecView vec0_view(vec0_fxp.data(), meta.ncols);
  EXPECT_TRUE(
      api::Encrypt(mvp_context_, vec0_view, meta, secret_key_, encrypted_vec0)
          .ok());

  std::vector<std::string> encrypted_matvec(1);
  MatView mat_view(mat_fxp.data(), meta.nrows, meta.ncols);
  VecView vec1_view(vec1_fxp.data(), meta.ncols);
  EXPECT_TRUE(api::MatVec(other_context, mat_view, vec1_view, encrypted_vec0,
                          meta, encrypted_matvec)
                  .ok());

  VecBuffer matvec_fxp(meta.nrows);
  EXPECT_TRUE(api::DecryptMatVec(mvp_context_, encrypted_matvec, meta,
                                 secret_key_, matvec_fxp)
                  .ok());

  for (size_t i = 0; i < vec0.size(); ++i) {
    vec0[i] += vec1[i];
    vec0_fxp[i] += vec1_fxp[i];
  }

  auto matvec_ground = MatVec(mat_fxp, vec0_fxp, meta);

  int64_t max_err{0};
  for (size_t i = 0; i < matvec_ground.size(); ++i) {
    int64_t err =
        std::abs(static_cast<int64_t>(matvec_ground[i] - matvec_fxp.data()[i]));
    max_err = std::max(max_err, err);
  }

  int nbits = (int)std::log2(1e-30 + max_err);

  EXPECT_LE(nbits, fxp_prec + 3)
      << "nrows = " << meta.nrows << " ncols=" << meta.ncols;
}

// out0 + out1 = mat*(vec0 + vec1)
TEST_P(MatVecTest, MatVecSecretSharedInputOutput) {
  auto other_context = MVPContext::Create(4);

  EXPECT_TRUE(api::SetupEvalKey(mvp_context_, seralized_eval_key_).ok());
  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());
  EXPECT_TRUE(other_context->IsFPGAEnabled());

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  auto parms = GetParam();
  int fxp_prec = std::get<0>(parms);
  meta.nrows = std::get<0>(std::get<1>(parms));
  meta.ncols = std::get<1>(std::get<1>(parms));

  std::vector<double> mat(meta.nrows * meta.ncols);
  std::vector<double> vec(meta.ncols);
  RandomReal(mat.data(), mat.size(), 1.);
  RandomReal(vec.data(), vec.size(), 1.);

  auto mat_fxp = RealToFixedPoint(mat.data(), mat.size(), fxp_prec);
  std::vector<uint64_t> vec_shr0, vec_shr1;
  ShareIt(vec, fxp_prec, vec_shr0, vec_shr1);

  // asymmetric encryption
  std::vector<std::string> encrypted_vec0;
  VecView vec0_view(vec_shr0.data(), vec_shr0.size());
  EXPECT_TRUE(api::Encrypt(mvp_context_, vec0_view, meta, encrypted_vec0).ok());

  std::vector<std::string> encrypted_matvec;
  VecBuffer matvec_shr1(meta.nrows);
  MatView mat_view(mat_fxp.data(), meta.nrows, meta.ncols);
  VecView vec1_view(vec_shr1.data(), vec_shr1.size());
  EXPECT_TRUE(api::MatVec(other_context, mat_view, vec1_view, encrypted_vec0,
                          meta, matvec_shr1, encrypted_matvec)
                  .ok());

  VecBuffer matvec_shr0(meta.nrows);
  EXPECT_TRUE(api::DecryptMatVec(mvp_context_, encrypted_matvec, meta,
                                 secret_key_, matvec_shr0)
                  .ok());

  for (size_t i = 0; i < matvec_shr0.size(); ++i) {
    matvec_shr0.data()[i] += matvec_shr1.data()[i];  // mod 2^64 implicitly
  }

  for (size_t i = 0; i < vec_shr0.size(); ++i) {
    vec_shr0[i] += vec_shr1[i];
  }
  auto matvec_ground = MatVec(mat_fxp, vec_shr0, meta);

  int64_t max_err{0};
  for (size_t i = 0; i < matvec_ground.size(); ++i) {
    int64_t err = std::abs(
        static_cast<int64_t>(matvec_ground[i] - matvec_shr0.data()[i]));
    max_err = std::max(err, max_err);
  }

  int nbits = (int)std::log2(1e-30 + max_err);
  EXPECT_LE(nbits, fxp_prec + 3)
      << "nrows = " << meta.nrows << " ncols=" << meta.ncols;
}

// mat*vec0 + vec1
TEST_P(MatVecTest, MatVecMulThenAdd) {
  auto other_context = MVPContext::Create(4);

  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());
  EXPECT_TRUE(other_context->IsFPGAEnabled());

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  auto parms = GetParam();
  int fxp_prec = std::get<0>(parms);
  meta.nrows = std::get<0>(std::get<1>(parms));
  meta.ncols = std::get<1>(std::get<1>(parms));

  std::vector<double> mat(meta.nrows * meta.ncols);
  std::vector<double> vec0(meta.ncols);
  std::vector<double> vec1(meta.ncols);
  std::vector<double> vec2(meta.nrows);

  RandomReal(mat.data(), mat.size(), 1.);
  RandomReal(vec0.data(), vec0.size(), 1.);
  RandomReal(vec1.data(), vec1.size(), 1.);
  RandomReal(vec2.data(), vec2.size(), 1.);

  auto mat_fxp = RealToFixedPoint(mat.data(), mat.size(), fxp_prec);
  auto vec0_fxp = RealToFixedPoint(vec0.data(), vec0.size(), fxp_prec);
  auto vec1_fxp = RealToFixedPoint(vec1.data(), vec1.size(), fxp_prec);
  auto vec2_fxp =
      RealToFixedPoint(vec2.data(), vec2.size(), fxp_prec + fxp_prec);

  std::vector<std::string> encrypted_vec;
  VecView vec_view(vec0_fxp.data(), meta.ncols);
  EXPECT_TRUE(
      api::Encrypt(mvp_context_, vec_view, meta, secret_key_, encrypted_vec)
          .ok());

  std::vector<std::string> encrypted_added_vec;
  vec_view = VecView(vec1_fxp.data(), meta.ncols);

  EXPECT_TRUE(api::AddVector(other_context, vec_view, encrypted_vec, meta,
                             encrypted_added_vec)
                  .ok());
  std::vector<std::string> encrypted_matvec;
  MatView mat_view(mat_fxp.data(), meta.nrows, meta.ncols);
  EXPECT_EQ(api::MatVec(other_context, mat_view, encrypted_added_vec, meta,
                        encrypted_matvec)
                .ToString(),
            "OK");

  vec_view = VecView(vec2_fxp.data(), meta.nrows);
  std::vector<std::string> encrypted_updated_matvec;
  {
    auto meta_ = meta;
    meta_.nrows = vec_view.num_elements();
    meta_.ncols = 1;
    meta_.is_transposed = false;
    EXPECT_EQ(api::UpdateMatVec(other_context, vec_view, encrypted_matvec,
                                meta_, encrypted_updated_matvec)
                  .ToString(),
              "OK");
  }

  VecBuffer matvec_fxp(meta.nrows);
  EXPECT_TRUE(api::DecryptMatVec(mvp_context_, encrypted_updated_matvec, meta,
                                 secret_key_, matvec_fxp)
                  .ok());

  for (size_t i = 0; i < vec0.size(); ++i) {
    vec0_fxp[i] += vec1_fxp[i];
  }

  auto matvec_ground = MatVec(mat_fxp, vec0_fxp, meta);
  for (size_t i = 0; i < vec2.size(); ++i) {
    matvec_ground[i] += vec2_fxp[i];
  }

  int64_t max_err{0};
  for (size_t i = 0; i < matvec_ground.size(); ++i) {
    int64_t err =
        std::abs(static_cast<int64_t>(matvec_ground[i] - matvec_fxp.data()[i]));
    max_err = std::max(max_err, err);
  }

  int nbits = std::log2(1e-30 + max_err);
  EXPECT_LE(nbits, fxp_prec + 3)
      << "nrows = " << meta.nrows << " ncols=" << meta.ncols;
}

INSTANTIATE_TEST_CASE_P(
    MatVecTestInstance, MatVecTest,
    testing::Combine(
        // combine-1: fixed-point precision
        ::testing::Values(12, 15, 20),
        // combine-2: mat-shape
        ::testing::Values(
                          /// 1) some margin cases on shape
                          // minimum rows
                          std::make_tuple(2UL, 8UL),
                          // minimum columns
                          std::make_tuple(8UL, 1UL),
                          // maximum rows
                          std::make_tuple(global::kMaxNumRows, 128UL),
                          // maximum columns
                          std::make_tuple(4UL, global::kMaxNumCols),
                          /// 2) non-2 power cases
                          // non-2 power rows
                          std::make_tuple(3UL, 128UL),
                          std::make_tuple(7UL, 128UL),
                          std::make_tuple(9UL, 128UL),
                          std::make_tuple(1025UL, 128UL),
                          std::make_tuple(global::kMaxNumRows - 1, 8UL),
                          // non-2 power columns
                          std::make_tuple(8UL, 5UL),
                          std::make_tuple(8UL, 9UL),
                          std::make_tuple(8UL, 17UL),
                          std::make_tuple(8UL, 4099UL),
                          std::make_tuple(8UL, global::kMaxNumCols - 1),
                          /// 3) 2-power cases
                          std::make_tuple(128UL, 1024UL),
                          std::make_tuple(1024UL, 128UL),
                          std::make_tuple(256L, 512UL),
                          std::make_tuple(8UL, 4096UL),
                          std::make_tuple(2048UL, 12288UL)
                          )));