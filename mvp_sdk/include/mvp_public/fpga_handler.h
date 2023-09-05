#ifndef MVP_PUBLIC_FPGA_HANDLER_H
#define MVP_PUBLIC_FPGA_HANDLER_H
#include <memory>
#include <vector>

#include "mvp_public/status.h"
namespace seal {
class GaloisKeys;
}

namespace gemini {
namespace mvp {

struct FPGAHandler {
 public:
  inline bool is_initialized() const { return is_initialized_; }

  Status InitFPGAKernel(const seal::GaloisKeys& evk);

  Status Release();

 private:
  bool is_initialized_{false};
};

}  // namespace mvp
}  // namespace gemini
#endif  // MVP_PUBLIC_FPGA_HANDLER_H
