#include <seal/seal.h>

#include "mvp_public/api_def.h"

seal::SEALContext UserSEALContext() {
  seal::EncryptionParameters parms(seal::scheme_type::bfv);
  size_t N = gemini::mvp::global::kPolyDegree;
  parms.set_poly_modulus_degree(N);
  std::vector<int> coeff_moduli_bits(4, 50);
  parms.set_coeff_modulus(seal::CoeffModulus::Create(N, coeff_moduli_bits));
  parms.set_plain_modulus(1024);
  return seal::SEALContext(parms, true, seal::sec_level_type::none);
}

void UserKeyGen(const seal::SEALContext &context, seal::SecretKey& sk) {
  seal::KeyGenerator keygen(context);
  sk = keygen.secret_key();
}

// This demo shows the user of MVP can even choose their secret key (e.g,. from other SEAL's application)
int main() {
  using namespace gemini::mvp;
  // The following lines mimic the user has already held a secret key.
  seal::SecretKey user_key;
  seal::SEALContext user_seal_context = UserSEALContext();
  UserKeyGen(user_seal_context, user_key);

  // User can use `api::ConvertUserKey` to convert his key to the proper form for MVP.
  // As long as the polynomial degree of the user' key is identical to
  seal::SecretKey mvp_key;
  auto mvp_context = MVPContext::Create();
  auto status = api::ConvertUserKey(mvp_context, user_key, user_seal_context, mvp_key);
  if (!status.ok()) {
    std::cerr << "ConvertUserKey " << status << std::endl;
    return -1;
  }

  std::vector<std::string> mvp_evk;
  status = api::DeriveEvalKey(mvp_context, mvp_key, mvp_evk);
  if (!status.ok()) {
    std::cerr << "ConvertUserKey " << status << std::endl;
    return -1;
  }

  MVPMetaInfo meta;
  meta.nrows = 200;
  meta.ncols = 100;
  meta.is_transposed = false; // M*v
  meta.base_mod_nbits = 64;  // mod 2^64

  std::vector<uint64_t> v0(meta.ncols, 1);
  std::vector<std::string> query;
  status = api::Encrypt(mvp_context, v0, meta, mvp_key, query);
  if (!status.ok()) {
    std::cerr << "Encrypt" << status << std::endl;
    return -1;
  }

  return 0;
}
