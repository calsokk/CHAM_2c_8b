#include "gtest/gtest.h"
#include "mvp_public/api_def.h"
#include "seal/seal.h"

using namespace gemini::mvp;

class MVPErrorTestUnit
    : public testing::Test,
      public testing::WithParamInterface<std::tuple<size_t, size_t>> {
 public:
  void SetUp() {
    mvp_context_ = MVPContext::Create(/*thread_pool*/ 2);
    EXPECT_TRUE(api::GenerateKey(mvp_context_, secret_key_).ok());
    EXPECT_TRUE(
        api::DeriveEvalKey(mvp_context_, secret_key_, seralized_eval_key_)
            .ok());
  }

  api::MVPContextPtr mvp_context_;
  seal::SecretKey secret_key_;
  std::vector<std::string> seralized_eval_key_;
};

TEST_F(MVPErrorTestUnit, MVPContextCreate) {
  seal::SecretKey sk;

  // non-activated context
  api::MVPContextPtr null;
  EXPECT_FALSE(api::GenerateKey(null, sk).ok());
}

TEST_F(MVPErrorTestUnit, Encrypt) {
  auto mvp_context = MVPContext::Create();

  MVPMetaInfo meta;
  meta.nrows = 1;
  meta.ncols = 3;
  std::vector<uint64_t> vec(meta.ncols);
  VecView vec_view(vec.data(), vec.size());
  std::vector<std::string> out;

  EXPECT_EQ(api::Encrypt(mvp_context, vec_view, meta, out).ToString(),
            "UNAVAILABLE: public key is absent");

  seal::SecretKey invalid_secret_key;
  EXPECT_EQ(api::Encrypt(mvp_context, vec_view, meta, invalid_secret_key, out)
                .ToString(),
            "INVALID_ARGUMENT: invalid key");

  EXPECT_TRUE(api::SetupEvalKey(mvp_context, seralized_eval_key_).ok());
  VecView invalid_vec(vec.data(), 2);
  EXPECT_EQ(api::Encrypt(mvp_context, invalid_vec, meta, out).ToString(),
            "INVALID_ARGUMENT: vector length mismatches the meta info");
}

TEST_P(MVPErrorTestUnit, InvalidMatShape) {
  auto mvp_context = MVPContext::Create();
  EXPECT_TRUE(api::SetupEvalKey(mvp_context, seralized_eval_key_).ok());

  MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.base_mod_nbits = global::kSecretShareBitLen;

  auto matshape = GetParam();
  meta.nrows = std::get<0>(matshape);
  meta.ncols = std::get<1>(matshape);


  std::vector<uint64_t> dummy(1); // dummy
  VecView vec_view(dummy.data(), 1);

  std::vector<std::string> encrypted_ct(4);
  if (meta.nrows != 1) {
    EXPECT_THROW(api::Encrypt(mvp_context, vec_view, meta, encrypted_ct),
                 std::invalid_argument);
  }

  MatView mat_view(dummy.data(), 1, 1); // dummy
  std::vector<std::string> out_vec;
  EXPECT_THROW(api::MatVec(mvp_context, mat_view, encrypted_ct, meta, out_vec),
               std::invalid_argument);

}

INSTANTIATE_TEST_CASE_P(
    MatVecErrorTestInstance, MVPErrorTestUnit,
    ::testing::Values(std::make_tuple(0UL, 2UL),
                      std::make_tuple(2UL, 0UL),
                      std::make_tuple(1UL, 2UL),
                      std::make_tuple(global::kMaxNumRows + 1, 2UL),
                      std::make_tuple(2UL, global::kMaxNumCols + 1),
                      std::make_tuple(global::kMaxNumRows + 1, global::kMaxNumCols + 1)));