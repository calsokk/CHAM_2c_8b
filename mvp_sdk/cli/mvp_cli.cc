//
// Created by Lu WJ on 2022/6/27.
//

#include <fmt/format.h>
#include <seal/seal.h>
#include <spdlog/cfg/env.h>

#include <fstream>

#include "argparse.hpp"
#include "mvp_public/api_def.h"

constexpr char* kPriKeyPath = "./mvp_key";
constexpr char* kPubKeyPath = "./mvp_key.pub";
constexpr char* kMatFile = "./mvp_mat.txt";
constexpr char* kVecFile = "./mvp_vec.txt";
constexpr char* kResultFile = "./mvp_result.txt";

bool save_eval_key(const std::vector<std::string>& evk,
                   const std::string& file) {
  std::ofstream fout(file, std::ios::ate | std::ios::binary);
  if (!fout.is_open()) {
    return false;
  }
  uint32_t nkey = evk.size();
  fout.write(reinterpret_cast<char*>(&nkey), sizeof(uint32_t));
  for (const auto& key : evk) {
    uint32_t nbyte = key.length();
    fout.write(reinterpret_cast<char*>(&nbyte), sizeof(uint32_t));
    fout.write(key.c_str(), key.length());
  }
  fout.close();
  return true;
}

bool load_eval_key(const std::string& file, std::vector<std::string>& evk) {
  std::ifstream fin(file, std::ios::binary);
  if (!fin.is_open()) {
    return false;
  }
  uint32_t nkey;
  fin.read(reinterpret_cast<char*>(&nkey), sizeof(uint32_t));
  evk.resize(nkey);
  for (size_t i = 0; i < nkey; ++i) {
    uint32_t nbyte;
    fin.read(reinterpret_cast<char*>(&nbyte), sizeof(uint32_t));
    if (nbyte == 0 || nbyte > (1UL << 22)) return false;
    std::vector<char> buff(nbyte);
    fin.read(buff.data(), nbyte);
    evk[i] = std::string(buff.begin(), buff.end());
  }
  fin.close();
  return true;
}

void mvp_keygen() {
  using namespace gemini::mvp;
  gemini::Status status;

  auto mvp_context = MVPContext::Create();
  seal::SecretKey sk;
  status = api::GenerateKey(mvp_context, sk);
  if (!status.ok()) {
    std::cerr << fmt::format("api::GenerateKey failed due to {}",
                             status.ToString())
              << std::endl;
    return;
  }

  std::vector<std::string> evk;
  status = api::DeriveEvalKey(mvp_context, sk, evk);
  if (!status.ok()) {
    std::cerr << fmt::format("api::DeriveEvalKey failed due to {}",
                             status.ToString())
              << std::endl;
    return;
  }

  {
    std::ofstream fout(kPriKeyPath, std::ios::ate | std::ios::binary);
    std::cout << fmt::format("Saving private key to {}...", kPriKeyPath)
              << std::endl;
    sk.save(fout);
    fout.close();
    std::cout << fmt::format("Private key is saved to {}", kPriKeyPath)
              << std::endl;
  }

  {
    std::ofstream fout(kPubKeyPath, std::ios::ate | std::ios::binary);
    std::cout << fmt::format("Saving public key to {}...", kPubKeyPath)
              << std::endl;
    if (save_eval_key(evk, kPubKeyPath)) {
      std::cout << fmt::format("Public key is saved to {}", kPubKeyPath)
                << std::endl;
    } else {
      std::cerr << fmt::format("Failed to save to public key {}", kPubKeyPath)
                << std::endl;
    }
  }
}

bool save_matrix(const uint64_t* ptr, size_t nrows, size_t ncols, int precision,
                 const std::string& file) {
  std::ofstream fout(file, std::ios::ate | std::ios::binary);
  if (!fout.is_open()) {
    std::cerr << fmt::format("Cannot save to file {}", file) << std::endl;
    return false;
  }

  if (!ptr || nrows == 0 || ncols == 0) return false;

  double scale = static_cast<double>(1LL << precision);
  auto u64_to_real = [scale](uint64_t x) -> double {
    return static_cast<int64_t>(x) / scale;
  };

  for (size_t r = 0; r < nrows; ++r) {
    fout << u64_to_real(*ptr++);
    for (size_t c = 1; c < ncols; ++c) {
      fout << "," << u64_to_real(*ptr++);
    }
    if (r + 1 < nrows) fout << std::endl;
  }

  fout.close();
  return true;
}

std::vector<uint64_t> U64MatVec(gemini::mvp::MatView mat,
                                gemini::mvp::VecView vec) {
  if (mat.ncols() != vec.num_elements()) {
    throw std::runtime_error("dimension mismatch");
  }

  std::vector<uint64_t> out(mat.nrows(), 0);
  for (size_t r = 0; r < mat.nrows(); ++r) {
    uint64_t acc = 0;
    for (size_t c = 0; c < mat.ncols(); ++c) {
      acc += mat.row_at(r)[c] * vec.data()[c];
    }
    out[r] = acc;
  }
  return out;
}

void mvp_matvec(bool use_asym, int nrows, int ncols, int precision) {
  using namespace gemini::mvp;
  if (nrows < 1 || nrows > global::kMaxNumRows) {
    std::cerr << fmt::format("invalid nrows {}, expected within [{}, {}]",
                             nrows, 2, global::kMaxNumRows)
              << std::endl;
    return;
  }
  if (ncols == 0 || ncols > global::kMaxNumCols) {
    std::cerr << fmt::format("invalid ncols {}, expected within [{}, {}]",
                             ncols, 1, global::kMaxNumCols)
              << std::endl;
    return;
  }
  if (precision == 0 || precision > 30) {
    std::cerr << fmt::format("invalid precision {}, expected within [1, 30]",
                             precision)
              << std::endl;
    return;
  }

  gemini::Status status;

  auto mvp_context = MVPContext::Create();

  seal::SecretKey secret_key;
  std::vector<std::string> evk;
  {
    std::ifstream pub_fin(kPubKeyPath, std::ios::binary);
    std::ifstream pri_fin(kPriKeyPath, std::ios::binary);
    if (!pub_fin.is_open()) {
      std::cerr << fmt::format("Error: public key file {} is absent",
                               kPubKeyPath);
      return;
    }
    if (!pri_fin.is_open()) {
      std::cerr << fmt::format("Error: private key file {} is absent",
                               kPriKeyPath);
      pub_fin.close();
      return;
    }

    struct FileGuard {
      FileGuard(std::ifstream& f0, std::ifstream& f1) : f0_(f0), f1_(f1) {}

      ~FileGuard() {
        f0_.close();
        f1_.close();
      }

      std::ifstream& f0_;
      std::ifstream& f1_;
    } guard(pub_fin, pri_fin);

    if (!load_eval_key(kPubKeyPath, evk)) {
      std::cerr << fmt::format("Error: loading public key {}", kPubKeyPath);
      return;
    }

    try {
      secret_key.load(mvp_context->seal_context(), pri_fin);
    } catch (const std::logic_error& err) {
      std::cerr << fmt::format("Error: invalid private key {}", kPriKeyPath)
                << std::endl;
      return;
    }
  }

  status = api::SetupEvalKey(mvp_context, evk);
  if (!status.ok()) {
    std::cerr << fmt::format("api::SetupEvalKey failed due to {}",
                             status.ToString())
              << std::endl;
    return;
  }

  std::mt19937_64 rdv(std::time(0));
  std::uniform_real_distribution<double> uniform(-1., 1.);

  std::vector<uint64_t> mat(nrows * ncols);
  std::vector<uint64_t> vec(ncols);
  std::generate_n(mat.data(), mat.size(), [&]() -> uint64_t {
    double x = uniform(rdv);
    return static_cast<uint64_t>(x * (double)(1LL << precision));
  });
  std::generate_n(vec.data(), vec.size(), [&]() -> uint64_t {
    double x = uniform(rdv);
    return static_cast<uint64_t>(x * (double)(1LL << precision));
  });

  MatView matview(mat.data(), nrows, ncols);
  VecView vecview(vec.data(), vec.size());

  MVPMetaInfo meta;
  meta.ncols = ncols;
  meta.nrows = nrows;
  meta.base_mod_nbits = 64;
  meta.is_transposed = false;

  std::vector<std::string> encrypted_vec;
  if (use_asym) {
    status = api::Encrypt(mvp_context, vecview, meta, encrypted_vec);
  } else {
    status =
        api::Encrypt(mvp_context, vecview, meta, secret_key, encrypted_vec);
  }
  if (!status.ok()) {
    std::cerr << fmt::format("api::Encrypt failed due to {}", status.ToString())
              << std::endl;
    return;
  }

  std::vector<std::string> out;
  status = api::MatVec(mvp_context, matview, encrypted_vec, meta, out);
  if (!status.ok()) {
    std::cerr << fmt::format("api::MatVec failed due to {}", status.ToString())
              << std::endl;
    return;
  }

  VecBuffer matvec(meta.nrows);
  status = api::DecryptMatVec(mvp_context, out, meta, secret_key, matvec);
  if (!status.ok()) {
    std::cerr << fmt::format("api::DecryptMatVec failed due to {}",
                             status.ToString())
              << std::endl;
    return;
  }

  bool ok = save_matrix(mat.data(), nrows, ncols, precision, kMatFile);
  ok &= save_matrix(vec.data(), 1, ncols, precision, kVecFile);
  ok &= save_matrix(matvec.data(), nrows, 1, precision * 2, kResultFile);

  if (ok) {
    std::vector<uint64_t> ground_truth = U64MatVec(matview, vecview);
    int64_t max_err{0};
    for (size_t i = 0; i < ground_truth.size(); ++i) {
      int64_t diff = ground_truth[i] - matvec.at(i);
      max_err = std::max(max_err, std::abs(diff));
    }
    std::cout
        << fmt::format(
               "MatVec on {}x{} with {} fixed-point precision with max errors "
               "{} ({:2f} bits), "
               "\nCheck the matrix {}, vector {} and computed result {}",
               nrows, ncols, precision, max_err, std::log2(max_err + 1e-5),
               kMatFile, kVecFile, kResultFile)
        << std::endl;
  }
}

int main(int argc, char* argv[]) {
  spdlog::cfg::load_env_levels();
  argparse::ArgumentParser program("mvp_cli");

  program.add_argument("action").default_value("gen").action(
      [](const std::string& value) {
        static const std::vector<std::string> choices = {"gen", "matvec"};
        if (std::find(choices.begin(), choices.end(), value) != choices.end()) {
          return value;
        }
        return std::string{"gen"};
      });

  bool use_asym = false;
  program.add_argument("--asym")
      .nargs(0)
      .help("use asymmetric encryption")
      .action([&](const auto&) { use_asym = true; })
      .default_value(false)
      .implicit_value(true);

  int nrows = 128;
  int ncols = 128;
  int precision = 15;
  program.add_argument("-r", "--rows")
      .nargs(1)
      .help("number of rows")
      .scan<'i', int>()
      .default_value(nrows);
  program.add_argument("-c", "--cols")
      .nargs(1)
      .help("number of columns")
      .scan<'i', int>()
      .default_value(ncols);
  program.add_argument("-p", "--prec")
      .nargs(1)
      .help("fixed-point precision")
      .scan<'i', int>()
      .default_value(precision);

  try {
    program.parse_args(argc, argv);
  } catch (const std::runtime_error& err) {
    std::cerr << err.what() << std::endl;
    std::cerr << program;
    std::exit(1);
  }

  std::string action = program.get("action");

  if (action == "gen") {
    mvp_keygen();
  } else if (action == "matvec") {
    nrows = program.get<int>("-r");
    ncols = program.get<int>("-c");
    precision = program.get<int>("-p");

    mvp_matvec(use_asym, nrows, ncols, precision);
  } else {
    std::exit(1);
  }

  return 0;
}