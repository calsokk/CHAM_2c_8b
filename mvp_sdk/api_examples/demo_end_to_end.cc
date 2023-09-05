#include <seal/seal.h>

#include "demo_common.h"
#include "mvp_public/api_def.h"
#include "mvp_public/util/timer.h"

int api_demo_netio(size_t nrows, size_t ncols, bool is_matrix_holder) {
  using namespace gemini::mvp;
  // Prepare tests
  constexpr int vec_prec = 15;  // Fixed-point value precision
  constexpr int mat_prec = 20;  // Fixed-point value precision
  // Prepare matrix and vector
  std::vector<double> real_mat;
  std::vector<double> real_vec;
  RandomReal(real_mat, nrows * ncols, 1.);
  RandomReal(real_vec, ncols, 1.);
  // The input vector is in the secret-shares form
  std::vector<uint64_t> v0(ncols);
  std::vector<uint64_t> v1(ncols);
  ShareToU64(real_vec, vec_prec, v0, v1);
  // Convert the real matrix to fixed-point matrix
  std::vector<uint64_t> mat_2k(real_mat.size());
  std::transform(real_mat.begin(), real_mat.end(), mat_2k.data(),
                 [](double u) { return RealToU64(u, mat_prec); });
  // Compute the ground truth in mod 2^k
  std::vector<uint64_t> gnd_prod_2k(nrows);
  for (size_t r = 0; r < nrows; ++r) {
    uint64_t acc{0};
    for (size_t c = 0; c < ncols; ++c) {
      uint64_t v = v0[c] + v1[c];
      acc += (v * mat_2k[r * ncols + c]);
    }
    gnd_prod_2k[r] = acc;
  }

  // Server and client is connected via network
  LocalLoopIO netchannel(is_matrix_holder, 12345);

  // Demo begins
  MVPMetaInfo meta;
  meta.nrows = nrows;
  meta.ncols = ncols;
  meta.is_transposed = false; // M*v
  meta.base_mod_nbits = 64;  // mod 2^64

  auto context = gemini::mvp::MVPContext::Create(is_matrix_holder ? /*thread_pool*/ 6 : 1);
  gemini::Status status;

  if (is_matrix_holder) {
    {
      // Server: wait for the evaluation key from the client
      std::vector<std::string> evk;
      netchannel.recv_strings(evk);
      double setup_time{0};
      MSecTimer timer(&setup_time);
      status = api::SetupEvalKey(context, evk);
      if (!status.ok()) {
        std::cerr << "SetupFPGA: " << status << std::endl;
        return -1;
      }
      timer.stop();
      printf("EvalKey (%zd KB) setup time %.2fms\n", TotalKiloBytes(evk), setup_time);
    }

    // mimic that eval key is already setup
    uint8_t sync;
    netchannel.send_data(&sync, 1);
    netchannel.flush();

    double prot_executime{0.};
    MSecTimer timer(&prot_executime);

    // Server: wait for the encrypted vector from client
    std::vector<std::string> query;
    netchannel.recv_strings(query);

    MatView matview(mat_2k.data(), nrows, ncols);
    VecBuffer output(meta.nrows);
    std::vector<std::string> response;
    status = api::MatVec(context, matview, v1, query, meta, output, response);
    std::cerr << "Execute: " << status << std::endl;
    if (!status.ok()) {
      std::cerr << "Execute: " << status << std::endl;
      return -1;
    }
    netchannel.send_strings(response);
    netchannel.flush();
    timer.stop();
    // Server end computation done

    printf(
        "Server: matrix %zdx%zd execute time %.2fms. "
        "Query %zd KB; response %zd KB\n",
        nrows, ncols, prot_executime,
        TotalKiloBytes(query), TotalKiloBytes(response));

    // To check the correctness, server sends its output share to client.
    netchannel.send_data((const uint8_t *)output.data(),
                         output.num_elements() * sizeof(uint64_t));
    netchannel.flush();
  } else {
    seal::SecretKey sk;
    status = api::GenerateKey(context, sk);
    if (!status.ok()) {
      std::cerr << "GenerateKey " << status << std::endl;
      return -1;
    }

    std::vector<std::string> evk;
    status = api::DeriveEvalKey(context, sk, evk);
    if (!status.ok()) {
      std::cerr << "DeriveEvalKey " << status << std::endl;
      return -1;
    }
    netchannel.send_strings(evk);
    netchannel.flush();

    uint8_t sync;
    netchannel.recv_data(&sync, 1);

    double prot_executime{0.};
    MSecTimer timer(&prot_executime);
    std::vector<std::string> query;
    status = api::Encrypt(context, v0, meta, sk, query);
    std::cerr << "Encrypt: " << status << std::endl;
    if (!status.ok()) {
      std::cerr << "Encrypt: " << status << std::endl;
      return -1;
    }
    netchannel.send_strings(query);
    netchannel.flush();

    std::vector<std::string> response;
    netchannel.recv_strings(response);
    VecBuffer output(meta.nrows);
    status = api::DecryptMatVec(context, response, meta, sk, output);
    if (!status.ok()) {
      std::cerr << "Decrypt: " << status << std::endl;
      return -1;
    }
    timer.stop();
    // Protocol Finish

    // Check correctness
    VecBuffer output1(output.num_elements());
    netchannel.recv_data((uint8_t *)output1.data(),
                         output.num_elements() * sizeof(uint64_t));

    std::vector<uint64_t> computed_2k(meta.nrows);
    // reconstruct in mod 2^64
    std::transform(output.data(), output.data() + output.num_elements(),
                   output1.data(), computed_2k.data(),
                   [](uint64_t u, uint64_t v) { return u + v; });
    int64_t max_err_2k{0};
    for (size_t i = 0; i < computed_2k.size(); ++i) {
      int64_t e_2k =
          std::abs(static_cast<int64_t>(computed_2k[i] - gnd_prod_2k[i]));
      max_err_2k = std::max(e_2k, max_err_2k);
    }

    printf("abs max error %ld (~%.2f bits), on %d bits fixed-point precions\n",
           max_err_2k, std::ceil(std::log2(max_err_2k + 1)),
           mat_prec + vec_prec);
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc != 4) {
    printf("nrows ncols is_server\n");
    return 1;
  }

  size_t nrows = std::atoi(argv[1]);
  size_t ncols = std::atoi(argv[2]);
  bool is_server = std::atoi(argv[3]) != 0;

  nrows = std::min<size_t>(std::max(1UL, nrows), gemini::mvp::global::kPolyDegree);
  ncols = std::min<size_t>(std::max(1UL, ncols), gemini::mvp::global::kPolyDegree);

  api_demo_netio(nrows, ncols, is_server);
  return 0;
}
