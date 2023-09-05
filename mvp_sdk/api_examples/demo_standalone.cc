#include <random>

#include "mvp_public/api_def.h"
#include "mvp_public/util/timer.h"
#include "seal/seal.h"
#include "seal/util/polyarithsmallmod.h"
#include "seal/util/rlwe.h"
#include <spdlog/cfg/env.h>

// r -> round(r*2^p) mod 2^64
inline uint64_t RealTo2k(double r, int precision) {
  return static_cast<int64_t>(std::roundf(r * (1ULL << precision)));
}

inline double U2kToReal(uint64_t r, int precision) {
  return static_cast<int64_t>(r) / std::pow(2., precision);
}

// share0 + share1 mod 2^k = round(real * 2^precision)
void ShareIt(const std::vector<double> &reals, const int precision,
             std::vector<uint64_t> &share0, std::vector<uint64_t> &share1) {
  size_t n = reals.size();
  if (n == 0) return;
  share0.resize(n);
  share1.resize(n);

  std::random_device rdv;
  // sample from [0, 2^64)
  std::uniform_int_distribution<uint64_t> uniform(0, static_cast<uint64_t>(-1));
  std::generate_n(share1.begin(), n, [&]() { return uniform(rdv); });

  for (size_t i = 0; i < n; ++i) {
    uint64_t x = RealTo2k(reals[i], precision);
    share0[i] = x - share1[i];
  }
}

void ShareIt(const std::vector<uint64_t> &reals, std::vector<uint64_t> &share0,
             std::vector<uint64_t> &share1) {
  size_t n = reals.size();
  if (n == 0) return;
  share0.resize(n);
  share1.resize(n);

  std::random_device rdv;
  // sample from [0, 2^64)
  std::uniform_int_distribution<uint64_t> uniform(0, static_cast<uint64_t>(-1));
  std::generate_n(share1.begin(), n, [&]() { return uniform(rdv); });

  for (size_t i = 0; i < n; ++i) {
    share0[i] = reals[i] - share1[i];
  }
}

void RandomVector(std::vector<uint64_t> &reals, size_t n) {
  std::random_device rdv;
  std::uniform_int_distribution<uint64_t> uniform(0, static_cast<uint64_t>(-1));
  reals.resize(n);
  std::generate_n(reals.begin(), n, [&]() { return uniform(rdv); });
}

void RandomReal(std::vector<double> &reals, size_t n, double upper = 1.) {
  // std::mt19937 rdv(std::time(0));
  std::random_device rdv;
  upper = std::abs(upper);
  std::uniform_real_distribution<double> uniform(-upper, upper);
  reals.resize(n);
  std::generate_n(reals.begin(), n, [&]() { return uniform(rdv); });
}

int _main(int argc, char *argv[]) {
  using namespace gemini::mvp;
  MVPMetaInfo meta;
  meta.nrows = argc > 1 ? std::atoi(argv[1]) : 256;
  meta.ncols = argc > 2 ? std::atoi(argv[2]) : 4096;
  int num_threads = argc > 3 ? std::atoi(argv[3]) : 4;
  // 准备测试样例的输入
  const int precision = 15;
  std::vector<uint64_t> input_vec;
  std::vector<uint64_t> alice_input(meta.ncols);
  std::vector<uint64_t> bob_input(meta.ncols);
  // random sample vector from [-1., 1]
  RandomVector(input_vec, meta.ncols);
  // random sample matrix from [-1., 1]
  std::vector<double> real_mat;
  RandomReal(real_mat, meta.nrows * meta.ncols, 1.);
  // Convert the real matrix to fixed-point matrix
  std::vector<uint64_t> mat_2k(real_mat.size());
  std::transform(real_mat.begin(), real_mat.end(), mat_2k.data(),
                 [](double u) { return RealTo2k(u, precision); });
  // Convert the vector to secret share form
  ShareIt(input_vec, alice_input, bob_input);
  // Compute the ground truth
  // ground truth from the fixed-point values
  std::vector<uint64_t> gnd_prod_2k(meta.nrows);
  for (size_t r = 0; r < meta.nrows; ++r) {
    uint64_t acc{0};
    for (size_t c = 0; c < meta.ncols; ++c) {
      uint64_t v = alice_input[c] + bob_input[c];
      acc += (v * mat_2k[r * meta.ncols + c]);
    }
    gnd_prod_2k[r] = acc;
  }

  gemini::Status status;
  /******* Demo begins ******/
  // Pv generate keys in-the-fly
  auto alice_mvp_context = MVPContext::Create();

  seal::SecretKey alice_sk;
  status = api::GenerateKey(alice_mvp_context, alice_sk);
  if (!status.ok()) {
    std::cout << "GenerateKey error: " << status << "\n";
    return -1;
  }

  std::vector<std::string> alice_evk;
  status = api::DeriveEvalKey(alice_mvp_context, alice_sk, alice_evk);
  if (!status.ok()) {
    std::cout << "DeriveEvalKey error: " << status << "\n";
    return -1;
  }

  status = api::SetupEvalKey(alice_mvp_context, alice_evk);
  if (!status.ok()) {
    std::cout << "SetupEvalKey error: " << status << "\n";
    return -1;
  }

  std::vector<std::string> alice_ct;
  // Pv encrypts his vector
  status = api::Encrypt(alice_mvp_context, alice_input, meta, alice_ct);
  if (!status.ok()) {
    std::cout << "Encrypt error: " << status << "\n";
    return -1;
  }
  /*    ||
   *  eval_key, alice_ct
   *    ||
   *    ||
   *    \/
   */
  // Pm receives eval_key and ct from Pv and then init the FPGA
  auto bob_mvp_context = MVPContext::Create(num_threads);
  status = api::SetupEvalKey(bob_mvp_context, alice_evk);
  if (!status.ok()) {
    std::cout << "SetupEvalKey error: " << status << "\n";
    return -1;
  }

  // Pm perform the matrix-vector multiplication
  MatView mat_view(mat_2k.data(), meta.nrows, meta.ncols);
  VecBuffer bob_out_share(meta.nrows);
  std::vector<std::string> out_share_ct;
  double exe_time{0.};
  {
    MSecTimer timer(&exe_time);
    status = api::MatVec(bob_mvp_context, mat_view, bob_input, alice_ct, meta,
                         bob_out_share, out_share_ct);
  }
  api::ReleaseFPGA(bob_mvp_context);
  /*    ||
   *  out_share_ct
   *    ||
   *    ||
   *    \/
   */
  // Pv waits for the computation result and then decrypt it
  VecBuffer alice_out_share(meta.nrows);
  status = api::DecryptMatVec(alice_mvp_context, out_share_ct, meta, alice_sk,
                              alice_out_share);
  /***** Demo done ******/
  // Accuracy Check
  std::vector<uint64_t> computed_2k(meta.nrows);
  std::transform(alice_out_share.data(),
                 alice_out_share.data() + alice_out_share.num_elements(),
                 bob_out_share.data(), computed_2k.data(),
                 [](uint64_t u, uint64_t v) { return u + v; });

  std::vector<double> computed(computed_2k.size());
  std::transform(
      computed_2k.begin(), computed_2k.end(), computed.data(),
      [&](uint64_t v) { return U2kToReal(v, precision + precision); });

  int64_t max_err_2k{0};
  for (size_t i = 0; i < computed.size(); ++i) {
    int64_t e_2k =
        std::abs(static_cast<int64_t>(computed_2k[i] - gnd_prod_2k[i]));
    max_err_2k = std::max(e_2k, max_err_2k);
  }

  printf("use num_threads = %d\n", num_threads);
  printf("took %.2fms\n%zd*%zd maximum abs error %ld (%.2f bits) on %d precisions\n",
         exe_time, meta.nrows, meta.ncols, max_err_2k,
         std::log2(1e-10 + max_err_2k), precision);
  return 0;
}

int main(int argc, char *argv[]) {
  spdlog::cfg::load_env_levels();
  spdlog::set_pattern("[%Y-%m-%d %H:%M:%S:%e] [p:%P/t:%t] [%n:%l] [%s:%#:%!] %v");
  return _main(argc, argv);
}
