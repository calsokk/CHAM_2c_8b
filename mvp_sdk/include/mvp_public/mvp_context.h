#ifndef MVP_PUBLIC_MVP_CONTEXT_H
#define MVP_PUBLIC_MVP_CONTEXT_H
#include <seal/context.h>

#include <memory>
#include <optional>

#include "mvp_public/fpga_handler.h"
#include "mvp_public/mod_switch.h"
#include "mvp_public/status.h"
#include "mvp_public/util/ThreadPool.h"
#include "mvp_public/util/defines.h"
#include "mvp_public/version.h"

namespace seal {
class PublicKey;
}

class MVPTest_MVPContextCreate_Test;

namespace gemini {
namespace mvp {

class MVPContext {
 private:
  explicit MVPContext(const seal::SEALContext& sc, size_t tpool_size)
      : seal_context_(sc) {
    // NOTE(juhou) maximum 8 threads might be enough
    tpool_size = std::max(1UL, tpool_size);
    tpool_size = std::min(8UL, tpool_size);
    ms_helper_ = std::make_shared<ModulusSwitchHelper>(
        seal_context_, global::kSecretShareBitLen);
    tpool_ = std::make_shared<ThreadPool>(tpool_size);
  }

 public:
  ~MVPContext() = default;

  MVPContext(const MVPContext& other) = default;

  MVPContext(MVPContext&& other) = default;

  MVPContext& operator=(const MVPContext& other) = default;

  static std::shared_ptr<MVPContext> Create(size_t thread_pool_size = 1) {
    seal::EncryptionParameters parms(seal::scheme_type::ckks);
    parms.set_poly_modulus_degree(global::kPolyDegree);
    std::vector<seal::Modulus> coeff_modulus(global::kNumModulus);
    for (uint32_t i = 0; i < global::kNumModulus; ++i) {
      coeff_modulus[i] = global::kModulus[i];
    }
    parms.set_coeff_modulus(coeff_modulus);

    std::shared_ptr<MVPContext> ret;
    thread_pool_size = std::max(1UL, thread_pool_size);
    seal::SEALContext seal_context(parms, true, seal::sec_level_type::tc128);
    ret.reset(new MVPContext(seal_context, thread_pool_size));
    return ret;
  }

  MVPVersion version() const { return current_version_; }

  inline bool IsFPGAEnabled() const { return fpga_handler_.is_initialized(); }

  FPGAHandler& fpga_handler() { return fpga_handler_; }

  const seal::SEALContext& seal_context() const { return seal_context_; }

  const seal::PublicKey& public_key() const {
    if (!public_key_) {
      throw std::runtime_error("public_key is not set yet");
    }
    return *public_key_;
  }

  const ModulusSwitchHelper& modsw_helper() const { return *ms_helper_; }

  Status SetupPublicKey(const seal::PublicKey& pk);

  std::future<Status> LaunchSubTask(
      std::function<Status(uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite)> fn,
      uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite) {
    return tpool_->enqueue(fn, current_row_dims, current_col_dims, row_ite, col_ite);
  }

 private:
  friend class MVPPublicImpl;
  friend class MVPPrivImpl;
  friend class ::MVPTest_MVPContextCreate_Test;

  size_t thread_pool_size() const { return tpool_->pool_size(); }

  std::future<Status> LaunchSubTask(
      std::function<Status(size_t start, size_t end)> fn, size_t start,
      size_t end) {
    return tpool_->enqueue(fn, start, end);
  }

  //std::future<Status> LaunchSubTask(
  //    std::function<Status(uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite)> fn, 
  //    uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite) {
  //  return tpool_->enqueue(fn, current_row_dims, current_col_dims, row_ite, col_ite);
  //}

  std::future<Status> LaunchSubTask(std::function<Status()> fn) {
    return tpool_->enqueue(fn);
  }

  FPGAHandler fpga_handler_;
  seal::SEALContext seal_context_;
  MVPVersion current_version_;
  std::shared_ptr<seal::PublicKey> public_key_{nullptr};
  std::shared_ptr<ModulusSwitchHelper> ms_helper_{nullptr};
  std::shared_ptr<ThreadPool> tpool_{nullptr};
};

}  // namespace mvp
}  // namespace gemini
#endif  // MVP_PUBLIC_MVP_CONTEXT
