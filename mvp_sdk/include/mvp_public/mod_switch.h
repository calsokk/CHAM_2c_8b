#include <seal/context.h>

#include <vector>

#include "mvp_public/status.h"
#include "mvp_public/types.h"

namespace seal {
class Modulus;
}  // namespace seal

namespace gemini {
namespace mvp {

using uint128_t = __uint128_t;
// wrapper of uint128 
struct UInt128 {
  inline uint64_t hi() const { return limbs_.u64[1]; }
  inline uint64_t lo() const { return limbs_.u64[0]; }
  inline uint64_t &hi() { return limbs_.u64[1]; }
  inline uint64_t &lo() { return limbs_.u64[0]; }

  void set(uint64_t v) {
    lo() = v;
    hi() = 0;
  }

  void set(uint128_t v) { limbs_.u128 = v; }

  uint64_t barrett_rdc(const seal::Modulus &p) const;

  UInt128 rshift(uint32_t offset) const {
    auto ret = *this;
    ret.limbs_.u128 >>= offset;
    return ret;
  }

  UInt128 mul(uint64_t v) const {
    auto ret = *this;
    ret.limbs_.u128 *= v;
    return ret;
  }

  UInt128 div(UInt128 v) const {
    auto ret = *this;
    ret.limbs_.u128 /= v.limbs_.u128;
    return ret;
  }

  UInt128 add(UInt128 v) const {
    auto ret = *this;
    ret.limbs_.u128 += v.limbs_.u128;
    return ret;
  }

  UInt128 add(uint64_t v) const {
    auto ret = *this;
    ret.limbs_.u128 += v;
    return ret;
  }

  UInt128 sub(uint64_t v) const {
    auto ret = *this;
    ret.limbs_.u128 -= v;
    return ret;
  }

  bool operator<=(const UInt128 &v) const {
    return limbs_.u128 <= v.limbs_.u128;
  }

  bool operator<=(uint64_t v) const { return limbs_.u128 <= v; }

  union {
    uint64_t u64[2]{0, 0};
    uint128_t u128;
  } limbs_;
};

// Helper to modulus switch between [0, Q) <-> [0, t)
class ModulusSwitchHelper {
 public:
  explicit ModulusSwitchHelper(const seal::SEALContext &seal_context,
                               uint32_t base_mod_bitlen);

  Status ModulusUpAt(VecView src, size_t mod_idx,
                     gsl::span<uint64_t> out) const;

  // out = round(src*t/Q)
  Status ModulusDownRNS(VecView src, VecBuffer &out) const;

 private:
  uint32_t base_mod_bitlen_;  // t = 2^k
  // floor(t/2) used to convert [0, t) -> [-t/2, t/2)
  UInt128 t_, t_half_;
  // (Q mod t)
  UInt128 Q_mod_t_;
  // floor(Q div t) mod qi
  std::vector<uint64_t> Q_div_t_mod_qi_;
  seal::SEALContext context_;
};

}  // namespace mvp
}  // namespace gemini

