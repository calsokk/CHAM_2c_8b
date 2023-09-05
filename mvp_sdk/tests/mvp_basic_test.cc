#include "gtest/gtest.h"
#include "mvp_public/api_def.h"
#include "seal/seal.h"

using namespace gemini::mvp;

class MVPTest : public testing::Test,
                public testing::WithParamInterface<std::tuple<size_t, size_t>> {
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

TEST_F(MVPTest, MVPContextCreate) {
  EXPECT_TRUE(mvp_context_ != nullptr);
  EXPECT_TRUE(mvp_context_->ms_helper_ != nullptr);
  EXPECT_TRUE(mvp_context_->seal_context().parameters_set());
  EXPECT_EQ(mvp_context_->thread_pool_size(), 2);

  MVPVersion ver = mvp_context_->version();
  EXPECT_EQ(ver.major, MVP_VERSION_MAJOR);
  EXPECT_EQ(ver.minor, MVP_VERSION_MINOR);
  EXPECT_EQ(ver.patch, MVP_VERSION_PATCH);

  EXPECT_FALSE(mvp_context_->IsFPGAEnabled());
  EXPECT_TRUE(api::SetupEvalKey(mvp_context_, seralized_eval_key_).ok());
  EXPECT_TRUE(mvp_context_->IsFPGAEnabled());
}

TEST_F(MVPTest, GenerateKey) {
  EXPECT_EQ(secret_key_.data().coeff_count(),
            global::kNumModulus * global::kPolyDegree);

  EXPECT_TRUE(
      seal::is_data_valid_for(secret_key_, mvp_context_->seal_context()));
}

TEST_F(MVPTest, DeriveEvalKey) { EXPECT_EQ(seralized_eval_key_.size(), 1); }

TEST_F(MVPTest, ConvertUserKey) {
  seal::SecretKey mvp_key;
  EXPECT_TRUE(api::ConvertUserKey(mvp_context_, secret_key_,
                                  mvp_context_->seal_context(), mvp_key)
                  .ok());
  EXPECT_TRUE(seal::is_data_valid_for(mvp_key, mvp_context_->seal_context()));
}

TEST_F(MVPTest, SetupEvalKeyAndRelease) {
  auto other_context = MVPContext::Create(4);
  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());
  EXPECT_TRUE(other_context->IsFPGAEnabled());
  EXPECT_TRUE(api::ReleaseFPGA(other_context).ok());
}

TEST_P(MVPTest, SymmetricEncrypt) {
  auto matshape = GetParam();
  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  meta.nrows = 1;
  meta.ncols = std::get<1>(matshape);
  std::vector<uint64_t> vector(global::kPolyDegree, 1);
  VecView vec_view(vector.data(), meta.ncols);

  std::vector<std::string> encrypted_vec;
  EXPECT_TRUE(
      api::Encrypt(mvp_context_, vec_view, meta, secret_key_, encrypted_vec)
          .ok());
  size_t expected_len =
      (meta.ncols + global::kPolyDegree - 1) / global::kPolyDegree;
  EXPECT_EQ(encrypted_vec.size(), expected_len);
}

TEST_P(MVPTest, AsymmetricEncrypt) {
  auto other_context = MVPContext::Create(4);
  EXPECT_TRUE(api::SetupEvalKey(other_context, seralized_eval_key_).ok());

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;
  auto matshape = GetParam();
  std::vector<uint64_t> vector(global::kPolyDegree, 1);
  meta.nrows = 1;
  meta.ncols = std::get<1>(matshape);
  VecView vec_view(vector.data(), meta.ncols);

  std::vector<std::string> encrypted_vec;
  EXPECT_TRUE(api::Encrypt(other_context, vec_view, meta, encrypted_vec).ok());
  size_t expected_len =
      (meta.ncols + global::kPolyDegree - 1) / global::kPolyDegree;
  EXPECT_EQ(encrypted_vec.size(), expected_len);
}

INSTANTIATE_TEST_CASE_P(
    EncryptionTestInstance, MVPTest,
    ::testing::Values(std::make_tuple(1UL, 1UL),
                      std::make_tuple(1UL, 8UL),
                      std::make_tuple(1UL, 127UL),
                      std::make_tuple(1UL, global::kPolyDegree - 1),
                      std::make_tuple(1UL, global::kPolyDegree),
                      std::make_tuple(1UL, global::kPolyDegree * 2),
                      std::make_tuple(1UL, global::kMaxNumCols - 1),
                      std::make_tuple(1UL, global::kMaxNumCols)));



