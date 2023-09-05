#include "mvp_public/util/slotful_ntt.h"

#include <seal/util/uintarith.h>
#include <seal/util/uintarithsmallmod.h>

#include "mvp_public/util/defines.h"

namespace gemini {
namespace mvp {
namespace internal {

using MUM = seal::util::MultiplyUIntModOperand;

struct SlothfulNTT {
 public:
  const seal::Modulus &mod_p;
  const uint64_t p, Lp;  // prime p, and Lp = L*p
  explicit SlothfulNTT(const seal::Modulus &mod_p, uint64_t L)
      : mod_p(mod_p), p(mod_p.value()), Lp(L * p) {
    if (p >= (1L << 59)) {
      throw std::logic_error(
          "SlothfulNTT requires 59-bit modulus most, but got " +
          std::to_string(p));
    }
  }

  // x0' <- x0 + w * x1 mod p
  // x1' <- x0 - w * x1 mod p
  inline void forward_lazy(uint64_t *x0, uint64_t *x1, const MUM &w) const {
    uint64_t u, v;
    u = *x0;
    v = mulmod_lazy(*x1, w);

    *x0 = u + v;
    *x1 = u - v + Lp;
  }

  inline void forward_last_lazy(uint64_t *x0, uint64_t *x1,
                                const MUM &w) const {
    uint64_t u, v;
    u = reduce_barrett_lazy(*x0);
    v = mulmod_lazy(*x1, w);

    *x0 = u + v;
    *x1 = u - v + Lp;
  }

  inline void backward_corr_lazy(uint64_t *x0, uint64_t *x1,
                                 const MUM &w) const {
    uint64_t u = reduce_barrett_lazy(*x0);
    uint64_t v = reduce_barrett_lazy(*x1);
    *x0 = u + v;
    *x1 = mulmod_lazy(u + Lp - v, w);
  }

  // x0' <- x0 + x1 mod p
  // x1' <- x0 - w * x1 mod p
  inline void backward_lazy(uint64_t *x0, uint64_t *x1, const MUM &w) const {
    uint64_t u = *x0;
    uint64_t v = *x1;
    uint64_t t = u + v;
    t -= select(Lp, t < Lp);
    *x0 = t;
    *x1 = mulmod_lazy(u - v + Lp, w);
  }

  inline void backward_last_lazy(uint64_t *x0, uint64_t *x1, const MUM &inv_n,
                                 const MUM &inv_n_w) const {
    uint64_t u = *x0;
    uint64_t v = *x1;
    uint64_t t = u + v;
    t -= select(Lp, t < Lp);
    *x0 = mulmod_lazy(t, inv_n);
    *x1 = mulmod_lazy(u - v + Lp, inv_n_w);
  }

 private:
  // return 0 if cond = true, else return b if cond = false
  inline uint64_t select(uint64_t b, bool cond) const {
    return (b & -(uint64_t)cond) ^ b;
  }

  // x * y mod p using Shoup's trick, i.e., yshoup = floor(2^64 * y / p)
  inline uint64_t mulmod_lazy(uint64_t x, const MUM &y) const {
    unsigned long long q;
    seal::util::multiply_uint64_hw64(x, y.quotient, &q);
    return x * y.operand - q * p;
  }

  inline uint64_t mulmod(uint64_t x, const MUM &y) const {
    x = mulmod_lazy(x, y);
    return x - select(p, x < p);
  }

  // Basically mulmod_lazy(x, 1, shoup(1))
  inline uint64_t reduce_barrett_lazy(uint64_t x) const {
    return seal::util::barrett_reduce_64(x, mod_p);
  }
};

int slotful_ntt_lazy(gsl::span<uint64_t> operand,
                     const seal::util::NTTTables &tables) {
  const size_t n = size_t(1) << tables.coeff_count_power();
  if (operand.size() != n) {
    std::cerr << "slotful_ntt: invalid operand.size" << std::endl;
    return -1;
  }

  SlothfulNTT ntt_body(tables.modulus(), 2);

  size_t m = 1;
  size_t h = n >> 1;

  auto w = tables.get_from_root_powers() + 1;

  {  // main loop: for h >= 4
    for (; h > 2; m <<= 1, h >>= 1) {
      auto x0 = operand.data();
      auto x1 = x0 + h;
      for (size_t r = 0; r < m; ++r, ++w) {
        // group that use the same twiddle factor, i.e., w[r].
        for (size_t i = 0; i < h; i += 4) {  // unrolling
          ntt_body.forward_lazy(x0++, x1++, *w);
          ntt_body.forward_lazy(x0++, x1++, *w);
          ntt_body.forward_lazy(x0++, x1++, *w);
          ntt_body.forward_lazy(x0++, x1++, *w);
        }
        x0 += h;
        x1 += h;
      }
    }
  }

  {  // m = degree / 4, h = 2
    auto x0 = operand.data();
    auto x1 = x0 + 2;
    for (size_t r = 0; r < m; ++r, ++w) {  // unrolling
      ntt_body.forward_lazy(x0++, x1++, *w);
      ntt_body.forward_lazy(x0, x1, *w);  // combine the incr to following steps
      x0 += 3;
      x1 += 3;
    }
    m <<= 1;
  }

  {  // m = degree / 2, h = 1
    auto x0 = operand.data();
    auto x1 = x0 + 1;
    for (size_t r = 0; r < m; ++r, ++w) {
      ntt_body.forward_last_lazy(x0, x1, *w);
      x0 += 2;
      x1 += 2;
    }
  }
  // At the end operand[0 .. n) stay in [0, 4p).
  return 0;
}

int slotful_intt_lazy(gsl::span<uint64_t> operand,
                      const seal::util::NTTTables &tables) {
  const uint64_t n = 1L << tables.coeff_count_power();
  if (operand.size() != n) {
    std::cerr << "slotful_ntt: invalid operand.size" << std::endl;
    return -1;
  }

  const size_t L =
      std::min<size_t>(n >> 1, 1UL << (64 - tables.modulus().bit_count() - 1));
  SlothfulNTT intt_body(tables.modulus(), L);

  auto w = tables.get_from_inv_root_powers() + 1;
  {  // first loop: m = degree / 2, h = 1
    const size_t m = n >> 1;
    auto x0 = operand.data();
    auto x1 = x0 + 1;  // invariant: x1 = x0 + h during the iteration
    for (size_t r = 0; r < m; ++r, ++w) {
      // intt_body.backward_lazy(x0, x1, *w);
      // input will be in [0, L*p)
      intt_body.backward_corr_lazy(x0, x1, *w);
      x0 += 2;
      x1 += 2;
    }
  }

  {  // second loop: m = degree / 4, h = 2
    const size_t m = n / 4;
    auto x0 = operand.data();
    auto x1 = x0 + 2;
    for (size_t r = 0; r < m; ++r, ++w) {
      intt_body.backward_lazy(x0++, x1++, *w);
      intt_body.backward_lazy(x0, x1, *w);
      x0 += 3;
      x1 += 3;
    }
  }

  {  // main loop: for h >= 4
    const size_t nL = n / L;
    size_t m = n / 8;
    size_t h = 4;
    for (; m >= nL; m >>= 1, h <<= 1) {
      auto x0 = operand.data();
      auto x1 = x0 + h;
      for (size_t r = 0; r < m; ++r, ++w) {
        for (size_t i = 0; i < h; i += 4) {  // unrolling
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
        }
        x0 += h;
        x1 += h;
      }
    }

    // m > 1 to skip the last layer
    for (; m > 1; m >>= 1, h <<= 1) {
      auto x0 = operand.data();
      auto x1 = x0 + h;
      for (size_t r = 0; r < m; ++r, ++w) {
        size_t i = 0;
        for (; i < nL / (2 * m); i += 4) {
          intt_body.backward_corr_lazy(x0++, x1++, *w);
          intt_body.backward_corr_lazy(x0++, x1++, *w);
          intt_body.backward_corr_lazy(x0++, x1++, *w);
          intt_body.backward_corr_lazy(x0++, x1++, *w);
        }

        for (; i < h; i += 4) {
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
          intt_body.backward_lazy(x0++, x1++, *w);
        }
        x0 += h;
        x1 += h;
      }
    }
  }

  // Multiply n^{-1} merged with the last layer of butterfly.
  const auto &inv_n = tables.inv_degree_modulo();
  uint64_t _inv_n_w =
      seal::util::multiply_uint_mod(inv_n.operand, *w, tables.modulus());
  MUM inv_n_w;
  inv_n_w.set(_inv_n_w, tables.modulus());

  uint64_t *x0 = operand.data();
  uint64_t *x1 = x0 + n / 2;
  for (size_t i = n / 2; i < n; ++i) {
    intt_body.backward_last_lazy(x0++, x1++, inv_n, inv_n_w);
  }
  // At the end operand[0 .. n) stay in [0, 2p).
  return 0;
}

}  // namespace internal
}  // namespace mvp
}  // namespace gemini
