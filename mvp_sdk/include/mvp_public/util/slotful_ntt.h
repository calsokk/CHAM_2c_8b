#ifndef MVP_PUBLIC_UTIL_SLOTFUL_NTT_H
#define MVP_PUBLIC_UTIL_SLOTFUL_NTT_H
#include <seal/util/ntt.h>

#include <gsl/span>

namespace gemini {
namespace mvp {

inline void ntt_forward_lazy(gsl::span<uint64_t> operand,
                             const seal::util::NTTTables &tables) {
  seal::util::ntt_negacyclic_harvey_lazy(operand.data(), tables);
}

inline void ntt_backward_lazy(gsl::span<uint64_t> operand,
                              const seal::util::NTTTables &tables) {
  seal::util::inverse_ntt_negacyclic_harvey(operand.data(), tables);
}

inline int ntt_forward(gsl::span<uint64_t> operand,
                       const seal::util::NTTTables &tables) {
  ntt_forward_lazy(operand, tables);
  // [0, 4p) -> [0, p)
  uint64_t p = tables.modulus().value();
  uint64_t Lp = p * 2;
  std::transform(operand.data(), operand.data() + operand.size(),
                 operand.data(),
                 [&](uint64_t v) { return v - (v < Lp ? 0 : Lp); });

  std::transform(operand.data(), operand.data() + operand.size(),
                 operand.data(),
                 [&](uint64_t v) { return v - (v < p ? 0 : p); });
  return 0;
}

inline int ntt_backward(gsl::span<uint64_t> operand,
                        const seal::util::NTTTables &tables) {
  ntt_backward_lazy(operand, tables);
  // [0, 2p) -> [0, p)
  uint64_t p = tables.modulus().value();
  std::transform(operand.data(), operand.data() + operand.size(),
                 operand.data(),
                 [&](uint64_t v) { return v - (v < p ? 0 : p); });
  return 0;
}

}  // namespace mvp
}  // namespace gemini

#endif
