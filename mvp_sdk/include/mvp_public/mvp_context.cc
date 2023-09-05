#include "mvp_public/mvp_context.h"

#include <seal/publickey.h>

#include "mvp_public/errors.h"
namespace gemini {
namespace mvp {

Status MVPContext::SetupPublicKey(const seal::PublicKey &pk) {
  if (!seal_context_.parameters_set()) {
    return InternalError("invalid seal context");
  }

  GM_REQUIRES(seal::is_data_valid_for(pk, seal_context_),
              InvalidArgumentError("invalid public key"));
  public_key_ = std::make_shared<seal::PublicKey>(pk);
  return Status::OK();
}

}  // namespace mvp
}  // namespace gemini
