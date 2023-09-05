#include "mvp_public/fpga_handler.h"
#include <seal/galoiskeys.h>
#include "mvp_public/F3/mvp_fpga_lib.h"
#include "mvp_public/errors.h"
#include "mvp_public/util/defines.h"

namespace gemini {
namespace mvp {

Status FPGAHandler::InitFPGAKernel(const seal::GaloisKeys &evk) {
  unsigned long N = global::kPolyDegree;
  unsigned long logN = global::kLogPolyDegree;
  unsigned long num_modulus = global::kNumModulus;

  unsigned long evk_size =
      seal::util::mul_safe(2UL, N, num_modulus, 8UL);  // bytes
  std::vector<unsigned long *> evk_pointers(2 * logN);
  for (size_t i = 1, idx = 0; i <= logN; i++) {
    uint32_t galois_elt = (1U << i) + 1;
    GM_REQUIRES(evk.has_key(galois_elt),
                InvalidArgumentError("InitFPGAKernel: missing key"));
    const auto &keys = evk.key(galois_elt);
    GM_REQUIRES(keys.size() == 2,
                InvalidArgumentError("InitFPGAKernel: invalid evk size"));

    for (const seal::PublicKey &k : keys) {
      // sanity check for GaloisKey
      GM_REQUIRES(k.data().poly_modulus_degree() == N &&
                      k.data().coeff_modulus_size() == num_modulus,
                  InvalidArgumentError("InitFPGAKernel: invalid evk size"));
      for (size_t l = 0; l < num_modulus; ++l) {
        const uint64_t upper = global::kModulus[l];
        auto rns = k.data().data() + l * N;
        // each rns should in [0, prime).
        GM_REQUIRES(std::all_of(rns, rns + N,
                                [upper](uint64_t x) { return x < upper; }),
                    OutOfRangeError("InitFPGAKernel: invalid evk value"));
        // we reject galois key that *all* the coefficients are zero.
        GM_REQUIRES(
            std::any_of(rns, rns + N, [](uint64_t x) { return x > 0; }),
            InvalidArgumentError("InitFPGAKernel: invalid evk of all 0"));
      }

      // Note: FPGA runtime SDK requires pointer of type `unsigned long`
      auto _ptr = reinterpret_cast<const unsigned long *>(k.data().data());
      auto ksk_addr = const_cast<unsigned long *>(_ptr);
      evk_pointers[idx++] = ksk_addr;
    }
  }

  if (0 != KernelInit(evk_pointers.data(), evk_pointers.size(), evk_size)) {
    return InternalError("InitFPGAKernel: KernelInit failed");
  }

  is_initialized_ = true;
  return Status::OK();
}

Status FPGAHandler::Release() {
  is_initialized_ = false;
  return Status::OK();
}

}  // namespace mvp
}  // namespace gemini
