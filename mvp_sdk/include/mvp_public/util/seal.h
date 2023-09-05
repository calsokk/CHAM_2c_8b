#ifndef GEMINI_CORE_UTIL_SEAL_H
#define GEMINI_CORE_UTIL_SEAL_H
#include <cstdint>

#include "mvp_public/status.h"

namespace seal {
class Ciphertext;
class GaloisKeys;
class SEALContext;
}  // namespace seal

namespace gemini {
// modified from seal/evaluator.cpp
// To handle key-switching for CKKS (resp. BFV) ciphertext in non-ntt form
// (resp. ntt form).
Status apply_galois_inplace(seal::Ciphertext &encrypted, uint32_t galois_elt,
                            const seal::GaloisKeys &galois_keys,
                            const seal::SEALContext &context);

}  // namespace gemini
#endif  // GEMINI_CORE_UTIL_SEAL_H
