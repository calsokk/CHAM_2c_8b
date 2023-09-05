#include "mvp_public/mod_switch.h"

#include <seal/util/polyarithsmallmod.h>

#include "mvp_public/errors.h"

namespace gemini {
namespace mvp {

uint64_t UInt128::barrett_rdc(const seal::Modulus &p) const {
  if (hi() == 0) {
    return seal::util::barrett_reduce_64(lo(), p);
  } else {
    return seal::util::barrett_reduce_128(limbs_.u64, p);
  }
}

ModulusSwitchHelper::ModulusSwitchHelper(const seal::SEALContext &seal_context,
                                         uint32_t base_mod_bitlen)
    : base_mod_bitlen_(base_mod_bitlen), context_(seal_context) {
  auto pool = seal::MemoryManager::GetPool();
  auto cntxt = seal_context.first_context_data();
  auto &coeff_modulus = cntxt->parms().coeff_modulus();
  size_t num_modulus = coeff_modulus.size();
  auto bigQ = cntxt->total_coeff_modulus();

  if (!(base_mod_bitlen <= 64 && base_mod_bitlen >= 2)) {
    throw std::logic_error("base_mod_bitlen out-of-bound");
  }

  if (base_mod_bitlen < 64) {
    t_.set(static_cast<uint64_t>(1ULL) << base_mod_bitlen);
  } else {
    t_.set(static_cast<uint128_t>(1) << base_mod_bitlen);
  }
  t_half_ = t_.rshift(1);

  std::vector<uint64_t> temp_t(num_modulus, 0);
  temp_t[0] = t_.lo();
  temp_t[1] = t_.hi();
  std::vector<uint64_t> Q_div_t(num_modulus);  // Q div t
  std::vector<uint64_t> Q_mod_t(num_modulus);  // Q mod t
  seal::util::divide_uint(bigQ, temp_t.data(), num_modulus, Q_div_t.data(),
                          Q_mod_t.data(), pool);

  // Q_mod t
  Q_mod_t_.lo() = Q_mod_t[0];
  Q_mod_t_.hi() = Q_mod_t[1];

  // convert position form to RNS form
  auto rns_tool = cntxt->rns_tool();
  rns_tool->base_q()->decompose(Q_div_t.data(), pool);
  Q_div_t_mod_qi_ = Q_div_t;
}

Status ModulusSwitchHelper::ModulusUpAt(VecView src, size_t mod_idx,
                                        gsl::span<uint64_t> out) const {
  using namespace seal::util;
  size_t num_modulus = Q_div_t_mod_qi_.size();
  GM_REQUIRES(mod_idx >= 0 && mod_idx < num_modulus,
              InvalidArgumentError("ModulusUpAt: invalid mod_idx"));
  GM_REQUIRES(src.size() == out.size(),
              InvalidArgumentError("ModulusUpAt: size mismatch"));
  auto &modulus = context_.first_context_data()->parms().coeff_modulus();
  auto &mod_qj = modulus.at(mod_idx);

  std::transform(
      src.data(), src.data() + src.size(), out.data(), [&](uint64_t x) {
        // u = (Q mod t)*x mod qi
        auto u = multiply_uint_mod(x, Q_div_t_mod_qi_[mod_idx], mod_qj);
        // v = floor((r*x + t/2)/t) = round(r*x/t)
        auto v = Q_mod_t_.mul(x).add(t_half_).div(t_);
        return v.add(u).barrett_rdc(mod_qj);
      });

  return Status::OK();
}

// out = round(src*t/Q)
Status ModulusSwitchHelper::ModulusDownRNS(VecView src, VecBuffer &out) const {
  using namespace seal::util;
  size_t num_modulus = Q_div_t_mod_qi_.size();
  GM_REQUIRES(src.size() == num_modulus * out.size(),
              InvalidArgumentError("ModulusDown: size mismatch"));
  auto pool = seal::MemoryManager::GetPool();
  auto tmp = allocate_uint(src.size(), pool);
  std::copy_n(src.data(), src.size(), tmp.get());

  auto cntxt = context_.first_context_data();

  // RNS to BigInt
  cntxt->rns_tool()->base_q()->compose_array(tmp.get(), out.size(), pool);

  auto bigQ = cntxt->total_coeff_modulus();
  auto Qhalf = cntxt->upper_half_threshold();

  const uint64_t *bigint_ptr = tmp.get();
  std::vector<uint64_t> prod(num_modulus + 2);
  std::vector<uint64_t> add(num_modulus + 2);
  std::vector<uint64_t> div(num_modulus + 2);

  std::vector<uint64_t> _bigQ(num_modulus + 2, 0);
  std::copy_n((const uint64_t *)bigQ, num_modulus, _bigQ.data());

  for (size_t i = 0; i < out.size(); ++i, bigint_ptr += num_modulus) {
    // x*t
    multiply_uint(bigint_ptr, num_modulus, t_.limbs_.u64, 2, num_modulus + 2,
                  prod.data());
    // x*t+(Q/2)
    add_uint(prod.data(), num_modulus + 2, Qhalf, num_modulus, 0, add.size(),
             add.data());
    // floor((x*t+Q/2)/Q)
    divide_uint_inplace(add.data(), _bigQ.data(), num_modulus + 2, div.data(),
                        pool);
    out.at(i) = div[0];
  }
  return Status::OK();
}

}  // namespace mvp
}  // namespace gemini
