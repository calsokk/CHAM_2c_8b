#ifndef MVP_PUBLIC_API_DEF_H
#define MVP_PUBLIC_API_DEF_H

#include "mvp_public/mvp_context.h"
#include "mvp_public/status.h"
#include "mvp_public/types.h"

namespace seal {
class SecretKey;
class GaloisKeys;
}  // namespace seal

namespace gemini {
namespace mvp {
namespace api {

using MVPContextPtr = std::shared_ptr<MVPContext>;

// Generate a SEAL secret key object that used in MVP.
Status GenerateKey(MVPContextPtr rt, seal::SecretKey &sk);

// Given a secret key, to derive the evaluation key (i.e. seal::GaloisKeys)
// that used in MVP. The evaluation key will be serialized to `eval_key` which
// can be safely passed via network.
Status DeriveEvalKey(MVPContextPtr rt, const seal::SecretKey &sk,
                     std::vector<std::string> &eval_key);

// Covnert user's seal key to a proper form that can be used in MVP.
// Requires the polynomoial degree of user_key equals to
// gemini::mvp::global::kPolyDegree (see mvp_public/util/defines.h).
Status ConvertUserKey(MVPContextPtr rt, const seal::SecretKey &user_key,
                      const seal::SEALContext &user_context,
                      seal::SecretKey &mvp_key);

// Initialize the FPGA board e.g., transfer the evaluation key to FPGA's RAM.
Status SetupEvalKey(MVPContextPtr rt, StrBufView eval_key);

// Release the FPGA board.
Status ReleaseFPGA(MVPContextPtr rt);

Status Encrypt(MVPContextPtr rt, VecView in, const MVPMetaInfo &meta,
               std::vector<std::string> &out);

Status Encrypt(MVPContextPtr rt, VecView in, const MVPMetaInfo &meta,
               const seal::SecretKey &sk, std::vector<std::string> &out);

// vec0 + vec1
Status AddVector(MVPContextPtr rt, VecView vec0, StrBufView vec1,
                 const MVPMetaInfo &meta, std::vector<std::string> &vec2);

// mat * vec
Status MatVec(MVPContextPtr rt, MatView mat, StrBufView vec,
              const MVPMetaInfo &meta, std::vector<std::string> &out_vec);

Status MatVec(MVPContextPtr rt, MatView mat, StrBufView vec,
              const MVPMetaInfo &meta, std::vector<std::string> &out_vec, bool MT_in_subblock);

// mat*(vec0 + vec1) i.e., AddVector then MatVec
Status MatVec(MVPContextPtr rt, MatView mat, VecView vec0, StrBufView vec1,
              const MVPMetaInfo &meta, std::vector<std::string> &out_vec);

// compute vec2 = vec0 + vec1 where vec1 is computed via MatVec
Status UpdateMatVec(MVPContextPtr rt, VecView vec0, StrBufView vec1,
                    const MVPMetaInfo &meta, std::vector<std::string> &vec2);

// compute vec2 = vec0 + vec1 where vec0 vec1 is computed via MatVec
Status AddMatVec(MVPContextPtr rt, StrBufView vec0, StrBufView vec1,
                    const MVPMetaInfo &meta, std::vector<std::string> &vec2);

// compute vec2, vec3 such that vec2 + vec3 = mat * (vec0 + vec1)
Status MatVec(MVPContextPtr rt, MatView mat, VecView vec0, StrBufView vec1,
              const MVPMetaInfo &meta, VecBuffer &vec2,
              std::vector<std::string> &vec3);

Status DecryptMatVec(MVPContextPtr rt, StrBufView in, const MVPMetaInfo &meta,
                     const seal::SecretKey &sk, VecBuffer &out_share);

}  // namespace api
}  // namespace mvp
}  // namespace gemini
#endif  // MVP_PUBLIC_API_DEF_H
