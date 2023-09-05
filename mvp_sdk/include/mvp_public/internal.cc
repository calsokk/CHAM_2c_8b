#include <seal/seal.h>
#include <seal/util/polyarithsmallmod.h>
#include <seal/util/rlwe.h>

#include "mvp_public/types.h"
#include "mvp_public/util/common.h"
#include "mvp_public/util/slotful_ntt.h"

namespace gemini {
namespace mvp {
namespace internal {

bool transform_to_ntt_inplace(RLWECt& ct, const seal::SEALContext& context) {
  using namespace seal::util;
  if (ct.is_ntt_form()) return true;
  auto cntxt_data = context.get_context_data(ct.parms_id());
  if (!cntxt_data) {
    throw std::invalid_argument(
        "transform_to_ntt_inplace: invalid ct.parms_id");
  }
  auto ntt_tables = cntxt_data->small_ntt_tables();
  size_t n = ct.poly_modulus_degree();

  for (size_t k = 0; k < ct.size(); ++k) {
    auto ct_ptr = ct.data(k);
    for (size_t l = 0; l < ct.coeff_modulus_size(); ++l) {
      ntt_forward({ct_ptr, n}, ntt_tables[l]);
      ct_ptr += n;
    }
  }
  ct.is_ntt_form() = true;
  return true;
}

bool transfom_from_ntt_inplace(RLWEPt& pt, const seal::SEALContext& context) {
  using namespace seal::util;
  if (!pt.is_ntt_form()) return true;
  auto cntxt_data = context.get_context_data(pt.parms_id());
  if (!cntxt_data) {
    throw std::invalid_argument("transform_from_ntt_lazy: invalid ct.parms_id");
  }
  auto num_modulus = cntxt_data->parms().coeff_modulus().size();
  auto n = cntxt_data->parms().poly_modulus_degree();
  auto ntt_tables = cntxt_data->small_ntt_tables();
  auto pt_ptr = pt.data();
  for (size_t l = 0; l < num_modulus; ++l) {
    ntt_backward({pt_ptr, n}, ntt_tables[l]);
    pt_ptr += n;
  }
  return true;
}

bool add_inplace(RLWECt& ct0, const RLWECt& ct1,
                 const seal::SEALContext& context) {
  if (ct0.size() == 0) {
    ct0 = ct1;
    return true;
  }

  if (ct0.parms_id() != ct1.parms_id()) {
    throw std::invalid_argument("internal::add_inplace: ct.parms_id mismatch");
  }

  if (ct0.is_ntt_form() != ct1.is_ntt_form()) {
    throw std::invalid_argument(
        "internal::add_inplace: ct.is_ntt_form mismatch");
    return false;
  }

  if (ct0.size() != ct1.size()) {
    throw std::invalid_argument("internal::add_inplace: ct.size mismatch");
  }

  size_t N = ct0.poly_modulus_degree();
  size_t L = ct0.coeff_modulus_size();
  auto cntxt_data = context.key_context_data();
  auto& modulus = cntxt_data->parms().coeff_modulus();
  for (size_t k = 0; k < ct0.size(); ++k) {
    auto op0_ptr = ct0.data(k);
    auto op1_ptr = ct1.data(k);
    for (size_t l = 0; l < L; ++l) {
      seal::util::add_poly_coeffmod(op0_ptr, op1_ptr, N, modulus[l], op0_ptr);
      op0_ptr += N;
      op1_ptr += N;
    }
  }

  return true;
}

bool add_plain_inplace(RLWECt& ct, const RLWEPt& pt,
                       const seal::SEALContext& context) {
  using namespace seal::util;
  size_t N = ct.poly_modulus_degree();
  size_t L = ct.coeff_modulus_size();
  if (pt.coeff_count() != N * L) {
    throw std::invalid_argument(
        "internal::add_plain_inplace: pt.coeff_count mismatch");
  }
  auto cntxt_data = context.key_context_data();
  auto& modulus = cntxt_data->parms().coeff_modulus();
  ConstRNSIter plain_iter(pt.data(), N);
  RNSIter dest_iter = *iter(ct);
  add_poly_coeffmod(dest_iter, plain_iter, L, modulus, dest_iter);
  return true;
}

bool ckks_decrypt(const RLWECt& ct, const seal::SecretKey& sk,
                  const seal::SEALContext& context, RLWEPt& out) {
  using namespace seal::util;
  if (!ct.is_ntt_form() || ct.size() != 2) {
    throw std::invalid_argument(
        "internal::ckks_decrypt: requires ntt-form ct of sized-2");
  }

  if (!seal::is_metadata_valid_for(ct, context)) {
    throw std::invalid_argument("internal::ckks_decrypt: invalid ct");
  }

  if (!seal::is_valid_for(sk, context)) {
    throw std::invalid_argument("internal::ckks_decrypt: invalid secret key");
  }

  auto cntxt_data = context.get_context_data(ct.parms_id());
  if (!cntxt_data) {
    throw std::invalid_argument("internal::ckks_decrypt: invalid ct.parms_id");
  }

  out.parms_id() = seal::parms_id_zero;
  out.resize(ct.poly_modulus_degree() * ct.coeff_modulus_size());
  auto& parms = cntxt_data->parms();
  auto& coeff_modulus = parms.coeff_modulus();
  size_t coeff_count = parms.poly_modulus_degree();
  size_t coeff_modulus_size = coeff_modulus.size();

  ConstRNSIter secret_key_array(sk.data().data(), coeff_count);
  ConstRNSIter c0(ct.data(0), coeff_count);
  ConstRNSIter c1(ct.data(1), coeff_count);
  RNSIter destination(out.data(), coeff_count);

  SEAL_ITERATE(iter(c0, c1, secret_key_array, coeff_modulus, destination),
               coeff_modulus_size, [&](auto I) {
                 // put < c_1 * s > mod q in destination
                 dyadic_product_coeffmod(get<1>(I), get<2>(I), coeff_count,
                                         get<3>(I), get<4>(I));
                 // add c_0 to the result; note that destination should be in
                 // the same (NTT) form as encrypted
                 add_poly_coeffmod(get<4>(I), get<0>(I), coeff_count, get<3>(I),
                                   get<4>(I));
               });
  out.parms_id() = ct.parms_id();
  out.scale() = ct.scale();
  return true;
}

}  // namespace internal
}  // namespace mvp
}  // namespace gemini

