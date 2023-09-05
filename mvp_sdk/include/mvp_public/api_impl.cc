#include <seal/keygenerator.h>
#include <seal/util/ntt.h>
#include <mvp_public/util/timer.h>

#include "mvp_public/api_def.h"
#include "mvp_public/errors.h"
#include "mvp_public/util/istringviewstream.h"
#include "mvp_public/util/math.h"
#include "mvp_public/util/common.h"

namespace gemini {
namespace mvp {

static bool IsCompatiableVer(const MVPVersion &ver) {
  MVPVersion cur;
  return ver.major == cur.major && ver.minor == cur.minor;
}

static Status EncodeEvalKey(const seal::Serializable<seal::GaloisKeys> &gk,
                            const seal::Serializable<seal::PublicKey> &pk,
                            std::vector<std::string> &out) {
  std::ostringstream os;
  MVPVersion ver;
  os.write(reinterpret_cast<const char *>(&ver), sizeof(MVPVersion));

  GM_CATCH_SEAL_ERROR(gk.save(os));
  GM_CATCH_SEAL_ERROR(pk.save(os));
  std::vector<std::string>{1, os.str()}.swap(out);
  return Status::OK();
}

static Status DecodeEvalKey(const seal::SEALContext &context,
                            StrBufView str_data, seal::GaloisKeys &gk,
                            seal::PublicKey &pk) {
  GM_REQUIRES(context.parameters_set(),
              FailedPreconditionError("invalid seal context"));
  GM_REQUIRES(str_data.size() == 1, InvalidArgumentError("str_data.size()"));
  istringviewstream ins(str_data[0]);

  MVPVersion ver;
  ins.read(reinterpret_cast<char *>(&ver), sizeof(MVPVersion));
  GM_REQUIRES(IsCompatiableVer(ver),
              InvalidArgumentError("evk version mismatch"));
  GM_CATCH_SEAL_ERROR(gk.load(context, ins));
  GM_CATCH_SEAL_ERROR(pk.load(context, ins));
  return Status::OK();
}

namespace api {

/// Basically a wrapper over SEAL's key-generation api.
Status GenerateKey(MVPContextPtr rt, seal::SecretKey &sk) {
  GM_TRACE("GenerateKey");
  GM_REQUIRES(rt, FailedPreconditionError("MVPContext"));
  seal::KeyGenerator keygen(rt->seal_context());
  GM_CATCH_SEAL_ERROR(sk = keygen.secret_key());
  return Status::OK();
}

Status ConvertUserKey(MVPContextPtr rt, const seal::SecretKey &user_key,
                      const seal::SEALContext &user_context,
                      seal::SecretKey &mvp_key) {
  using namespace seal::util;
  GM_REQUIRES(rt, FailedPreconditionError("MVPContext"));
  GM_REQUIRES(user_context.parameters_set(),
              FailedPreconditionError("invalid user context"));
  GM_REQUIRES(seal::is_valid_for(user_key, user_context),
              FailedPreconditionError(
                  "invalid user key for the specified seal context"));

  const seal::SEALContext &mvp_context = rt->seal_context();
  if (user_context.key_parms_id() == mvp_context.key_parms_id()) {
    // user's seal context is identical to MVP's seal context
    mvp_key = user_key;
    return Status::OK();
  }

  auto user_cntxt_dat = user_context.key_context_data();
  if (user_cntxt_dat->parms().poly_modulus_degree() != global::kPolyDegree) {
    return InvalidArgumentError(
        "user's seal context is incompatible with MVP context");
  }
  auto user_ntt_tables = user_cntxt_dat->small_ntt_tables();

  auto mvp_cntxt_dat = mvp_context.key_context_data();
  size_t N = mvp_cntxt_dat->parms().poly_modulus_degree();
  size_t L = mvp_cntxt_dat->parms().coeff_modulus().size();

  mvp_key.parms_id() = seal::parms_id_zero;
  mvp_key.data().resize(mul_safe(N, L));

  // only copy the 1-st RNS and convert to position form
  std::copy_n(user_key.data().data(), N, mvp_key.data().data());
  inverse_ntt_negacyclic_harvey(mvp_key.data().data(), user_ntt_tables[0]);

  auto mvp_ntt_tables = mvp_cntxt_dat->small_ntt_tables();
  for (long l = L - 1; l >= 0; --l) {
    uint64_t neg_one = mvp_ntt_tables[l].modulus().value() - 1;
    auto src_sk = mvp_key.data().data();
    auto dst_sk = mvp_key.data().data() + l * N;
    std::transform(src_sk, src_sk + N, dst_sk, [&](uint64_t s) {
      // s <= 1 -> s
      // s > 1  -> prime[l] - 1
      return SEAL_COND_SELECT(s > 1, neg_one, s);
    });
    ntt_negacyclic_harvey(dst_sk, mvp_ntt_tables[l]);
  }
  mvp_key.parms_id() = mvp_context.key_parms_id();
  return Status::OK();
}

Status DeriveEvalKey(MVPContextPtr rt, const seal::SecretKey &sk,
                     std::vector<std::string> &eval_key) {
  GM_TRACE("DeriveEvalKey <{} keys>", eval_key.size());
  GM_REQUIRES(rt, FailedPreconditionError("MVPContext"));

  const seal::SEALContext &context = rt->seal_context();
  GM_REQUIRES(
      seal::is_valid_for(sk, context),
      InvalidArgumentError("invalid secret key for the specified SEALContext"));

  std::vector<uint32_t> galois_elt;
  for (uint32_t i = 1; i <= global::kLogPolyDegree; i++) {
    galois_elt.push_back((1u << i) + 1);
  }

  double time = 0;
  MSecTimer timer(&time);
  seal::KeyGenerator keygen(context, sk);
  auto public_key = keygen.create_public_key();
  auto galois_key = keygen.create_galois_keys(galois_elt);
  GM_RETURN_IF_ERROR(EncodeEvalKey(galois_key, public_key, eval_key));
  timer.stop();

  size_t nbytes = 0;
  for (auto& key : eval_key) nbytes += key.length();
  GM_LOG_INFO("DeriveEvalKey {} bytes, took {} ms", nbytes, time);

  return Status::OK();
}

Status SetupEvalKey(MVPContextPtr rt, StrBufView eval_key) {
  GM_TRACE("SetupEval eval_key<{} strings>", eval_key.size());

  GM_REQUIRES(rt, FailedPreconditionError("MVPContext"));

  const seal::SEALContext &seal_context = rt->seal_context();
  seal::GaloisKeys galois_keys;
  seal::PublicKey public_key;
  GM_RETURN_IF_ERROR(DecodeEvalKey(seal_context, eval_key, galois_keys, public_key));
  GM_RETURN_IF_ERROR(rt->SetupPublicKey(public_key));
  GM_RETURN_IF_ERROR(rt->fpga_handler().InitFPGAKernel(galois_keys));
  GM_LOG_INFO("Setup EvalKey to FPGA");
  return Status::OK();
}

Status ReleaseFPGA(MVPContextPtr rt) {
  GM_REQUIRES(rt, FailedPreconditionError("MVPContext"));
  return rt->fpga_handler().Release();
}

}  // namespace api
}  // namespace mvp
}  // namespace gemini
