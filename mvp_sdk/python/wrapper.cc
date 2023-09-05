#include "python/wrapper.h"

#include <fmt/format.h>
#include <pybind11/functional.h>
#include <pybind11/numpy.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/stl_bind.h>
#include <seal/seal.h>

#include "mvp_public/util/common.h"
#include "mvp_public/util/defines.h"
#include "mvp_public/util/timer.h"
#include "mvp_public/status.h"

//#define EXT_MAX_NROWS 40000000
//#define EXT_MAX_NCOLS 40000000
#define BLK_NROWS 4096
#define BLK_NCOLS 8192

namespace py = pybind11;

PYBIND11_MAKE_OPAQUE(std::vector<std::string>);

// NOTE(juhou): might load from config file
//constexpr double kDefaultScale = 1L << 15;
//constexpr int kDefaultThreads = 4;

static inline uint64_t RealTo2k(double r, double scale) {
  return static_cast<int64_t>(std::roundf(r * scale));
}

static inline double U2kToReal(uint64_t r, double scale) {
  return static_cast<int64_t>(r) / scale;
}

MVPProtocol::MVPProtocol(int kDefaultThreads, double kDefaultScale_in):
kDefaultThreads_(kDefaultThreads), kDefaultScale_(kDefaultScale_in)
{}

MVPProtocol::~MVPProtocol() {}

void MVPProtocol::Activate(bool gen_secret_key) {
  mvp_context_ =
      gemini::mvp::MVPContext::Create(gen_secret_key ? 1 : kDefaultThreads_);

  if (gen_secret_key) {
    secret_key_ = std::make_shared<seal::SecretKey>();
    gemini::mvp::api::GenerateKey(mvp_context_, *secret_key_);
  } else {
    secret_key_ = nullptr;
  }
}

MVPEvalKeys MVPProtocol::GenEvalKey() {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }

  std::vector<std::string> evk;
  auto state = gemini::mvp::api::DeriveEvalKey(mvp_context_, *secret_key_, evk);
  if (!state.ok()) {
    throw std::runtime_error("GenEvalKey failed: " + state.ToString());
  }

  return MVPEvalKeys(evk[0]);
}

void MVPProtocol::SetupEvalKey(const MVPEvalKeys &eval_keys) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }

  gemini::mvp::StrBufView evk_view(&eval_keys.data(), 1);
  auto state = gemini::mvp::api::SetupEvalKey(mvp_context_, evk_view);
  if (!state.ok()) {
    throw std::runtime_error("SetupEvalKey failed: " + state.ToString());
  }
}

std::vector<MVPEncryptedVec> MVPProtocol::EncryptVector(const py::list &vec,
                                           bool is_symmetric) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (is_symmetric && !secret_key_) {
    throw std::invalid_argument("secret key is absent");
  }
  if (vec.size() == 0) { // || vec.size() > EXT_MAX_NCOLS){ //gemini::mvp::global::kMaxNumCols) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  std::vector<MVPEncryptedVec> encrypt_result_vec;
  uint32_t vector_dims;

  for (uint32_t ite =0; ite< vec.size(); ite = ite + BLK_NCOLS) {
    if (ite + BLK_NCOLS > vec.size())
       vector_dims = vec.size() - ite;
    else
       vector_dims = BLK_NCOLS;

    std::vector<uint64_t> input(vector_dims);
    //std::transform(vec.data() + ite, vec.data() + ite + vector_dims, input.data(),
    //               [](double r) { return RealTo2k(r, kDefaultScale); });
    for (size_t j = 0; j < vector_dims; ++j) {
      input[j] = RealTo2k(vec[ite+j].cast<double>(), kDefaultScale_);
     }

    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(1);
    meta.ncols = static_cast<size_t>(vector_dims);

    std::vector<std::string> ct_out;

    gemini::Status state;
    if (is_symmetric) {
      state = gemini::mvp::api::Encrypt(mvp_context_, input, meta, *secret_key_,
                                        ct_out);
    } else {
      state = gemini::mvp::api::Encrypt(mvp_context_, input, meta, ct_out);
    }

    if (!state.ok()) {
      throw std::runtime_error("Encrypt failed: " + state.ToString());
    }

    MVPEncryptedVec encrypt_result(ct_out, vector_dims);
    encrypt_result_vec.push_back(encrypt_result);
  }
  return encrypt_result_vec;
}

std::vector<MVPEncryptedVec> MVPProtocol::EncryptVector(const py::array_t<double> &vec,
                                           bool is_symmetric) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (is_symmetric && !secret_key_) {
    throw std::invalid_argument("secret key is absent");
  }
  if (vec.size() == 0) { // || vec.size() > EXT_MAX_NCOLS){ //gemini::mvp::global::kMaxNumCols) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  std::vector<MVPEncryptedVec> encrypt_result_vec;
  uint32_t vector_dims;  

  for (uint32_t ite =0; ite< vec.size(); ite = ite + BLK_NCOLS) {
    if (ite + BLK_NCOLS > vec.size())
       vector_dims = vec.size() - ite;
    else
       vector_dims = BLK_NCOLS;
    
    std::vector<uint64_t> input(vector_dims);
    std::transform(vec.data() + ite, vec.data() + ite + vector_dims, input.data(),
                   [=](double r) { return RealTo2k(r, kDefaultScale_); });

    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(1);
    meta.ncols = static_cast<size_t>(vector_dims);

    std::vector<std::string> ct_out;

    gemini::Status state;
    if (is_symmetric) {
      state = gemini::mvp::api::Encrypt(mvp_context_, input, meta, *secret_key_,
                                        ct_out);
    } else {
      state = gemini::mvp::api::Encrypt(mvp_context_, input, meta, ct_out);
    }

    if (!state.ok()) {
      throw std::runtime_error("Encrypt failed: " + state.ToString());
    }
    //printf("my test: is_symmetric=%d, ct_out size =%d vec.size=%d \n", is_symmetric, ct_out.size(), vec.size());
    MVPEncryptedVec encrypt_result(ct_out, vector_dims);
    encrypt_result_vec.push_back(encrypt_result);
  }
  return encrypt_result_vec;
}

std::vector<MVPEncryptedVec> MVPProtocol::AddVector(const py::list &vec,
                                       const std::vector<MVPEncryptedVec> &ct_vec) {

  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (vec.size() == 0) { // || vec.size() > gemini::mvp::global::kMaxNumCols) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  uint64_t total_vec_len = 0;
  for (int i=0; i<ct_vec.size();i++)
     total_vec_len = total_vec_len + ct_vec[i].vector_len();

  if (vec.size() != total_vec_len) {
    throw std::invalid_argument(
        fmt::format("vector length mismatch expected {} but got {}",
                    total_vec_len, vec.size()));
  }

  std::vector<MVPEncryptedVec> add_result_vector;

  for (int i=0; i< total_vec_len; i=i+BLK_NCOLS) {
    uint32_t current_vec_len;
    if (i + BLK_NCOLS > total_vec_len)
       current_vec_len = total_vec_len - i;
    else
       current_vec_len = BLK_NCOLS;


    uint32_t ct_index = (i + BLK_NCOLS - 1)/BLK_NCOLS;
    MVPEncryptedVec ct_in = ct_vec[ct_index];
    if (ct_in.vector_len() != current_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      current_vec_len, ct_in.vector_len()));
    }


    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(1);
    meta.ncols = static_cast<size_t>(current_vec_len);

    std::vector<uint64_t> input_vec(vec.size());
    //std::transform(vec.data() + i, vec.data() + i + current_vec_len, input_vec.data(),
    //               [](double r) { return RealTo2k(r, kDefaultScale); });
    for (size_t j = 0; j < current_vec_len; ++j) {
      input_vec[j] = RealTo2k(vec[i+j].cast<double>(), kDefaultScale_);
     }

    
    gemini::mvp::VecView vec_view(input_vec.data(), current_vec_len);

    std::vector<std::string> ct_out;
    auto state = gemini::mvp::api::AddVector(mvp_context_, vec_view, ct_in.view(),
                                             meta, ct_out);
    if (!state.ok()) {
      throw std::runtime_error("AddVector failed: " + state.ToString());
    }
    MVPEncryptedVec add_result(ct_out, current_vec_len);
    add_result_vector.push_back(add_result);
  }
  return add_result_vector;


}

std::vector<MVPEncryptedVec> MVPProtocol::AddVector(const py::array_t<double> &vec,
                                       const std::vector<MVPEncryptedVec> &ct_vec) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (vec.size() == 0) { // || vec.size() > gemini::mvp::global::kMaxNumCols) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  uint64_t total_vec_len = 0;
  for (int i=0; i<ct_vec.size();i++)
     total_vec_len = total_vec_len + ct_vec[i].vector_len();

  if (vec.size() != total_vec_len) {
    throw std::invalid_argument(
        fmt::format("vector length mismatch expected {} but got {}",
                    total_vec_len, vec.size()));
  }

  std::vector<MVPEncryptedVec> add_result_vector;

  for (int i=0; i< total_vec_len; i=i+BLK_NCOLS) {
    uint32_t current_vec_len;
    if (i + BLK_NCOLS > total_vec_len)
       current_vec_len = total_vec_len - i;
    else
       current_vec_len = BLK_NCOLS;


    uint32_t ct_index = (i + BLK_NCOLS - 1)/BLK_NCOLS;
    MVPEncryptedVec ct_in = ct_vec[ct_index];
    if (ct_in.vector_len() != current_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      current_vec_len, ct_in.vector_len()));
    }


    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(1);
    meta.ncols = static_cast<size_t>(current_vec_len);

    std::vector<uint64_t> input_vec(vec.size());
    std::transform(vec.data() + i, vec.data() + i + current_vec_len, input_vec.data(),
                   [=](double r) { return RealTo2k(r, kDefaultScale_); });
    gemini::mvp::VecView vec_view(input_vec.data(), current_vec_len);

    std::vector<std::string> ct_out;
    auto state = gemini::mvp::api::AddVector(mvp_context_, vec_view, ct_in.view(),
                                             meta, ct_out);
    if (!state.ok()) {
      throw std::runtime_error("AddVector failed: " + state.ToString());
    }
    //return MVPEncryptedVec(ct_out, vec.size());
    MVPEncryptedVec add_result(ct_out, current_vec_len);
    add_result_vector.push_back(add_result);
  }
  return add_result_vector;
}


MVPMatVecProd MVPProtocol::UpdateVector(const py::list &vec,
                                        const MVPMatVecProd &MVP_ct_set) {

  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (vec.size() == 0) {// || vec.size() > gemini::mvp::global::kMaxNumRows) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  //std::vector<MVPMatVecProd> ct_vec = MVP_ct_set.view();

  std::string cipher_buffer = MVP_ct_set.view();
  uint32_t buffer_ptr =0;
  double scale = MVP_ct_set.scale();
  uint64_t total_vec_len = MVP_ct_set.vector_len();
  //printf("total_vec_len=%d \n", total_vec_len);
  //for (int i=0; i<ct_vec.size();i++)
    // total_vec_len = total_vec_len + ct_vec[i].vector_len();


  if (vec.size() != total_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      total_vec_len, vec.size()));
  }

  std::vector<MVPMatVecProd> update_result_vector;
  uint32_t current_vec_len = BLK_NROWS;
  for (int i=0; i< total_vec_len; i=i+current_vec_len) {
    if (i + BLK_NROWS > total_vec_len)
       current_vec_len = total_vec_len - i;
    else if(i + BLK_NROWS == total_vec_len - 1)
       current_vec_len = BLK_NROWS - 1;
    else
       current_vec_len = BLK_NROWS;
    
    //printf("current_vec_len=%d, i=%d ,total_vec_len=%d \n", current_vec_len, i, total_vec_len);
    //uint32_t ct_index = (i + BLK_NROWS - 1)/BLK_NROWS;
    //MVPMatVecProd ct_in = ct_vec[ct_index];
    std::string len_string = cipher_buffer.substr(buffer_ptr, buffer_ptr+10);
    size_t rec_length = atoi(len_string.c_str()) & 0xfffff;
    MVPMatVecProd ct_in(cipher_buffer.substr(buffer_ptr+10, buffer_ptr+10+rec_length), current_vec_len, scale);
    buffer_ptr = buffer_ptr+10+rec_length;


    if (ct_in.vector_len() != current_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      current_vec_len, ct_in.vector_len()));
    }


    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(current_vec_len);
    meta.ncols = static_cast<size_t>(1);

    std::vector<uint64_t> input_vec(current_vec_len);
    //std::transform(vec.data() + i, vec.data() + i + current_vec_len, input_vec.data(),
                   //[&](double r) { return RealTo2k(r, ct_in.scale()); });
    for (size_t j = 0; j < current_vec_len; ++j) {
      input_vec[j] = RealTo2k(vec[i+j].cast<double>(), ct_in.scale());
     }

    gemini::mvp::VecView vec_view(input_vec.data(), current_vec_len);

    std::vector<std::string> ct_out;
    auto state = gemini::mvp::api::UpdateMatVec(mvp_context_, vec_view,
                                                ct_in.view(), meta, ct_out);
    if (!state.ok()) {
      throw std::runtime_error("UpdateVector failed: " + state.ToString());
    }
    //return MVPMatVecProd(ct_out[0], vec.size(), ct_in.scale());
    MVPMatVecProd update_result(ct_out[0], current_vec_len, ct_in.scale());
    update_result_vector.push_back(update_result);
  }
  //return update_result_vector;
  std::string mvp_merge;
  for (int i=0;i<update_result_vector.size(); i++) {
    std::string str_tmp = update_result_vector[i].view();
    //size_t vec_len = MVP_result_vector[i].vector_len();
    //printf("MVP[%d].size=%d \n",i, str_tmp.size());
    mvp_merge = mvp_merge + std::to_string(str_tmp.size() | (1 << 30));
    mvp_merge = mvp_merge + str_tmp;
  }
  //printf("mvp_merge size =%d \n",mvp_merge.size());
  MVPMatVecProd MVP_result_merge(mvp_merge, total_vec_len, update_result_vector[0].scale());
  return MVP_result_merge;


  //MVPMatVecProd_Set update_result_set(update_result_vector);
  //return update_result_set;

}


MVPMatVecProd MVPProtocol::UpdateVector(const py::array_t<double> &vec,
                                        const MVPMatVecProd &MVP_ct_set) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (vec.size() == 0) {// || vec.size() > gemini::mvp::global::kMaxNumRows) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }

  //std::vector<MVPMatVecProd> ct_vec = MVP_ct_set.view();

  std::string cipher_buffer = MVP_ct_set.view();
  uint32_t buffer_ptr =0;
  double scale = MVP_ct_set.scale();
  uint64_t total_vec_len = MVP_ct_set.vector_len();
  //printf("total_vec_len=%d \n", total_vec_len);
  //for (int i=0; i<ct_vec.size();i++)
    // total_vec_len = total_vec_len + ct_vec[i].vector_len();


  if (vec.size() != total_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      total_vec_len, vec.size()));
  }

  std::vector<MVPMatVecProd> update_result_vector;
  uint32_t current_vec_len = BLK_NROWS;
  for (int i=0; i< total_vec_len; i=i+current_vec_len) {
    if (i + BLK_NROWS > total_vec_len)
       current_vec_len = total_vec_len - i;
    else if(i + BLK_NROWS == total_vec_len - 1)
       current_vec_len = BLK_NROWS - 1;
    else
       current_vec_len = BLK_NROWS;
    
    //printf("current_vec_len=%d, i=%d ,total_vec_len=%d \n", current_vec_len, i, total_vec_len);
    //uint32_t ct_index = (i + BLK_NROWS - 1)/BLK_NROWS;
    //MVPMatVecProd ct_in = ct_vec[ct_index];
    std::string len_string = cipher_buffer.substr(buffer_ptr, buffer_ptr+10);
    size_t rec_length = atoi(len_string.c_str()) & 0xfffff;
    MVPMatVecProd ct_in(cipher_buffer.substr(buffer_ptr+10, buffer_ptr+10+rec_length), current_vec_len, scale);
    buffer_ptr = buffer_ptr+10+rec_length;


    if (ct_in.vector_len() != current_vec_len) {
      throw std::invalid_argument(
          fmt::format("vector length mismatch expected {} but got {}",
                      current_vec_len, ct_in.vector_len()));
    }


    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = static_cast<size_t>(current_vec_len);
    meta.ncols = static_cast<size_t>(1);

    std::vector<uint64_t> input_vec(current_vec_len);
    std::transform(vec.data() + i, vec.data() + i + current_vec_len, input_vec.data(),
                   [&](double r) { return RealTo2k(r, ct_in.scale()); });
    gemini::mvp::VecView vec_view(input_vec.data(), current_vec_len);

    std::vector<std::string> ct_out;
    auto state = gemini::mvp::api::UpdateMatVec(mvp_context_, vec_view,
                                                ct_in.view(), meta, ct_out);
    if (!state.ok()) {
      throw std::runtime_error("UpdateVector failed: " + state.ToString());
    }
    //return MVPMatVecProd(ct_out[0], vec.size(), ct_in.scale());
    MVPMatVecProd update_result(ct_out[0], current_vec_len, ct_in.scale());
    update_result_vector.push_back(update_result);
  }
  //return update_result_vector;
  std::string mvp_merge;
  for (int i=0;i<update_result_vector.size(); i++) {
    std::string str_tmp = update_result_vector[i].view();
    //size_t vec_len = MVP_result_vector[i].vector_len();
    //printf("MVP[%d].size=%d \n",i, str_tmp.size());
    mvp_merge = mvp_merge + std::to_string(str_tmp.size() | (1 << 30));
    mvp_merge = mvp_merge + str_tmp;
  }
  //printf("mvp_merge size =%d \n",mvp_merge.size());
  MVPMatVecProd MVP_result_merge(mvp_merge, total_vec_len, update_result_vector[0].scale());
  return MVP_result_merge;


  //MVPMatVecProd_Set update_result_set(update_result_vector);
  //return update_result_set;
}

MVPMatVecProd MVPProtocol::MatVecFMA(const py::array_t<double> &mat,
                                     const py::array_t<double> &vec,
                                     const MVPEncryptedVec &ct_in,
                                     const std::array<int, 2> &mat_dims) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (vec.size() == 0 || vec.size() > gemini::mvp::global::kMaxNumCols) {
    throw std::invalid_argument(
        fmt::format("vector length {} out-of-bound", vec.size()));
  }
  if (vec.size() != ct_in.vector_len()) {
    throw std::invalid_argument(
        fmt::format("vector length mismatch expected {} but got {}",
                    ct_in.vector_len(), vec.size()));
  }
  if (mat.size() != static_cast<size_t>(mat_dims[0] * mat_dims[1])) {
    throw std::invalid_argument("mat shape mismatches mat_dim");
  }
  if (vec.size() != mat_dims[1]) {
    throw std::invalid_argument(fmt::format(
        "vector length {} mismatches mat_dim[1] {}", vec.size(), mat_dims[1]));
  }

  gemini::mvp::MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.nrows = static_cast<size_t>(mat_dims[0]);
  meta.ncols = static_cast<size_t>(mat_dims[1]);

  std::vector<uint64_t> input_mat(mat.size());
  std::transform(mat.data(), mat.data() + mat.size(), input_mat.data(),
                 [=](double r) { return RealTo2k(r, kDefaultScale_); });

  std::vector<uint64_t> input_vec(vec.size());
  std::transform(vec.data(), vec.data() + vec.size(), input_vec.data(),
                 [=](double r) { return RealTo2k(r, kDefaultScale_); });

  std::vector<std::string> ct_out;
  gemini::mvp::MatView mat_view(input_mat.data(), meta.nrows, meta.ncols);
  gemini::mvp::VecView vec_view(input_vec.data(), meta.ncols);
  auto state = gemini::mvp::api::MatVec(mvp_context_, mat_view, vec_view,
                                        ct_in.view(), meta, ct_out);
  if (!state.ok()) {
    throw std::runtime_error("MatVecFMA failed: " + state.ToString());
  }
  return MVPMatVecProd(ct_out[0], vec.size(), kDefaultScale_ * kDefaultScale_);
}


MVPMatVecProd MVPProtocol::MatVec(const py::list &mat,
                                  const std::vector<MVPEncryptedVec> &ct_in_vec,
                                  const std::array<int, 2> &mat_dims) {
 if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (mat_dims[0] <= 0 || mat_dims[1] <= 0 ||
      static_cast<int>(mat.size()) != mat_dims[0] * mat_dims[1]) {
    throw std::invalid_argument("mat shape mismatches mat_dim");
  }
  
  uint32_t ct_vec_num = ct_in_vec.size();
//  gemini::mvp::MVPMetaInfo meta;
//  meta.is_transposed = false; 
  uint32_t matrix_nrows = mat_dims[0];
  uint32_t matrix_ncols = mat_dims[1];
  
  if ( (matrix_ncols + BLK_NCOLS -1)/BLK_NCOLS  !=  ct_vec_num ) {
    throw std::invalid_argument("mat col and mismatches mat_dim");
  }

  //std::vector<MVPMatVecProd> MVP_result_vector;
  //std::vector<uint64_t> input(BLK_NROWS* BLK_NCOLS);
  
  //uint32_t row_ite =0;
  uint32_t current_row_dims = BLK_NROWS;
  std::string mvp_merge;
  std::string str_tmp;
  //std::vector<std::string> mvp_col_result(ct_vec_num);
  bool MT_in_subblock;
  if (matrix_ncols> 1*BLK_NCOLS || matrix_nrows> BLK_NROWS)
    MT_in_subblock = false;
  else
    MT_in_subblock = true;
  printf("MT_in_subblock=%d \n", MT_in_subblock);
  uint32_t row_sub_block_num = (matrix_nrows + BLK_NROWS -1) / BLK_NROWS; 


  std::vector<std::vector<std::string>> mvp_matrix_result;
  mvp_matrix_result.resize(row_sub_block_num, std::vector<std::string>(ct_vec_num));
  //printf("mvp_matrix_result size= %d \n", mvp_matrix_result.size());
  //printf("mvp_matrix_result sub size= %d \n", mvp_matrix_result[0].size());

  auto MVP_col_MT = [&, this](uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite) {
      //double thread_time = 0.;
      //MSecTimer _timer(&thread_time);

      gemini::mvp::MVPMetaInfo meta;
      meta.is_transposed = false;
      if(current_row_dims == 1)
        meta.nrows = static_cast<size_t>(2);
      else
        meta.nrows = static_cast<size_t>(current_row_dims);
      meta.ncols = static_cast<size_t>(current_col_dims); 
      uint32_t ct_index = (col_ite + BLK_NCOLS - 1)/BLK_NCOLS;
      uint32_t row_index = (row_ite + BLK_NROWS - 1)/BLK_NROWS;
      MVPEncryptedVec ct_in = ct_in_vec[ct_index]; 
     

      if (ct_in.vector_len() != static_cast<size_t>(current_col_dims)) {
        throw std::invalid_argument(
            fmt::format("vector length {} mismatches col_dim {}",
                      ct_in.vector_len(), current_col_dims));
      }

      std::vector<uint64_t> input(BLK_NROWS* BLK_NCOLS);  
      uint64_t *input_ptr;
      //const double *meta_ptr;
      input_ptr =  input.data();
      uint32_t input_ptr_offset = 0;
      for (uint32_t blk_row=0; blk_row < current_row_dims; blk_row++){
         //meta_ptr = mat.data()+row_ite*matrix_ncols + blk_row*matrix_ncols + col_ite;
         //std::transform(meta_ptr , meta_ptr + current_col_dims, input_ptr,
                     //[=](double r) { return RealTo2k(r, kDefaultScale_); });
         //input_ptr = input_ptr + current_col_dims;
         uint32_t met_ptr_offset = row_ite*matrix_ncols + blk_row*matrix_ncols + col_ite;
         for (size_t j = 0; j < current_col_dims; ++j) {
           input[input_ptr_offset] = RealTo2k(mat[met_ptr_offset + j].cast<double>(), kDefaultScale_);
           input_ptr_offset++;
         }
         input_ptr = input_ptr + current_col_dims;

      }
      if(current_row_dims == 1)
        memset(input_ptr,0x0,current_col_dims*sizeof(uint64_t));

      std::vector<std::string> ct_out;
      gemini::mvp::MatView mat_view(input.data(), meta.nrows, meta.ncols);
      //printf("mt before call hardware 2 \n");
      auto state = gemini::mvp::api::MatVec(mvp_context_, mat_view, ct_in.view(),
                                            meta, ct_out, MT_in_subblock);
      //printf("mt after call hardware  \n");
      if (!state.ok()) {
        throw std::runtime_error("MatVec failed: " + state.ToString());
      }
      //mvp_col_result[ct_index] = ct_out[0];
      mvp_matrix_result[row_index][ct_index] = ct_out[0];
      //_timer.stop();
      //GM_LOG_INFO("mvp col thread took {} ms", thread_time);
      return gemini::Status::OK();
  };


  std::vector<std::future<gemini::Status>> mvp_col_tasks;
  
  for (uint32_t row_ite =0;row_ite < matrix_nrows; row_ite = row_ite + current_row_dims) {
    if (row_ite + BLK_NROWS > matrix_nrows)
       current_row_dims = matrix_nrows - row_ite;
    else if(row_ite + BLK_NROWS == matrix_nrows - 1)
       current_row_dims = BLK_NROWS - 1;
    else
       current_row_dims = BLK_NROWS;
    //printf("current_row_dims=%d \n", current_row_dims);    
    //std::vector<std::future<gemini::Status>> mvp_col_tasks;

    for (uint32_t col_ite =0;col_ite < matrix_ncols; col_ite = col_ite + BLK_NCOLS) {
      uint32_t current_col_dims;
      //printf("col_ite=%d \n", col_ite);    

      if (col_ite + BLK_NCOLS > matrix_ncols)
         current_col_dims = matrix_ncols - col_ite;
      else
         current_col_dims = BLK_NCOLS;

       if(MT_in_subblock)
         MVP_col_MT(current_row_dims, current_col_dims, row_ite,  col_ite);   
       else
         mvp_col_tasks.emplace_back(mvp_context_->LaunchSubTask(MVP_col_MT, current_row_dims, current_col_dims, row_ite, col_ite));

    }
    
  } 

  if(!MT_in_subblock) {
  for (auto&& t : mvp_col_tasks) {
    t.get();
    }
    //std::cout << "multi thread done" <<std::endl;
  }



  for (unsigned int row_index =0; row_index<row_sub_block_num; row_index++) {
    str_tmp = mvp_matrix_result[row_index][0];
    for (int i=1;i< ct_vec_num; i++) {
      gemini::mvp::MVPMetaInfo acc_meta;
      acc_meta.is_transposed = false;
      acc_meta.nrows = static_cast<size_t>(current_row_dims);

      std::vector<std::string> Matvec_added;
      auto add_state = gemini::mvp::api::AddMatVec(mvp_context_, str_tmp, mvp_matrix_result[row_index][i], acc_meta, Matvec_added);
      if (!add_state.ok()) {
         throw std::runtime_error("MVP merge UpdateVector failed: " + add_state.ToString());
      }
      str_tmp = Matvec_added[0];
    }

    mvp_merge = mvp_merge + std::to_string(str_tmp.size() | (1 << 30));
    mvp_merge = mvp_merge + str_tmp;
  }



  MVPMatVecProd MVP_result_merge(mvp_merge, matrix_nrows, kDefaultScale_ * kDefaultScale_);
  return MVP_result_merge;  

}





MVPMatVecProd MVPProtocol::MatVec(const py::array_t<double> &mat,
                                  const std::vector<MVPEncryptedVec> &ct_in_vec,
                                  const std::array<int, 2> &mat_dims) {
  
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (mat_dims[0] <= 0 || mat_dims[1] <= 0 ||
      static_cast<int>(mat.size()) != mat_dims[0] * mat_dims[1]) {
    throw std::invalid_argument("mat shape mismatches mat_dim");
  }
  
  uint32_t ct_vec_num = ct_in_vec.size();
//  gemini::mvp::MVPMetaInfo meta;
//  meta.is_transposed = false; 
  uint32_t matrix_nrows = mat_dims[0];
  uint32_t matrix_ncols = mat_dims[1];
  
  if ( (matrix_ncols + BLK_NCOLS -1)/BLK_NCOLS  !=  ct_vec_num ) {
    throw std::invalid_argument("mat col and mismatches mat_dim");
  }

  //std::vector<MVPMatVecProd> MVP_result_vector;
  //std::vector<uint64_t> input(BLK_NROWS* BLK_NCOLS);
  
  //uint32_t row_ite =0;
  uint32_t current_row_dims = BLK_NROWS;
  std::string mvp_merge;
  std::string str_tmp;
  //std::vector<std::string> mvp_col_result(ct_vec_num);
  bool MT_in_subblock;
  if (matrix_ncols> 1*BLK_NCOLS || matrix_nrows> BLK_NROWS)
    MT_in_subblock = false;
  else
    MT_in_subblock = true;
  printf("MT_in_subblock=%d \n", MT_in_subblock);
  uint32_t row_sub_block_num = (matrix_nrows + BLK_NROWS -1) / BLK_NROWS; 


  std::vector<std::vector<std::string>> mvp_matrix_result;
  mvp_matrix_result.resize(row_sub_block_num, std::vector<std::string>(ct_vec_num));
  //printf("mvp_matrix_result size= %d \n", mvp_matrix_result.size());
  //printf("mvp_matrix_result sub size= %d \n", mvp_matrix_result[0].size());

  auto MVP_col_MT = [&, this](uint32_t current_row_dims, uint32_t current_col_dims, uint32_t row_ite,  uint32_t col_ite) {
      //double thread_time = 0.;
      //MSecTimer _timer(&thread_time);

      gemini::mvp::MVPMetaInfo meta;
      meta.is_transposed = false;
      if(current_row_dims == 1)
        meta.nrows = static_cast<size_t>(2);
      else
        meta.nrows = static_cast<size_t>(current_row_dims);
      meta.ncols = static_cast<size_t>(current_col_dims); 
      uint32_t ct_index = (col_ite + BLK_NCOLS - 1)/BLK_NCOLS;
      uint32_t row_index = (row_ite + BLK_NROWS - 1)/BLK_NROWS;
      MVPEncryptedVec ct_in = ct_in_vec[ct_index]; 
     

      if (ct_in.vector_len() != static_cast<size_t>(current_col_dims)) {
        throw std::invalid_argument(
            fmt::format("vector length {} mismatches col_dim {}",
                      ct_in.vector_len(), current_col_dims));
      }

      std::vector<uint64_t> input(BLK_NROWS* BLK_NCOLS);  
      uint64_t *input_ptr;
      const double *meta_ptr;
      input_ptr =  input.data();
      for (uint32_t blk_row=0; blk_row < current_row_dims; blk_row++){
         meta_ptr = mat.data()+row_ite*matrix_ncols + blk_row*matrix_ncols + col_ite;
         std::transform(meta_ptr , meta_ptr + current_col_dims, input_ptr,
                     [=](double r) { return RealTo2k(r, kDefaultScale_); });
         input_ptr = input_ptr + current_col_dims;
      }
      if(current_row_dims == 1)
        memset(input_ptr,0x0,current_col_dims*sizeof(uint64_t));

      std::vector<std::string> ct_out;
      gemini::mvp::MatView mat_view(input.data(), meta.nrows, meta.ncols);
      //printf("mt before call hardware 2 \n");
      auto state = gemini::mvp::api::MatVec(mvp_context_, mat_view, ct_in.view(),
                                            meta, ct_out, MT_in_subblock);
      //printf("mt after call hardware  \n");
      if (!state.ok()) {
        throw std::runtime_error("MatVec failed: " + state.ToString());
      }
      //mvp_col_result[ct_index] = ct_out[0];
      mvp_matrix_result[row_index][ct_index] = ct_out[0];
      //_timer.stop();
      //GM_LOG_INFO("mvp col thread took {} ms", thread_time);
      return gemini::Status::OK();
  };


  std::vector<std::future<gemini::Status>> mvp_col_tasks;
  
  for (uint32_t row_ite =0;row_ite < matrix_nrows; row_ite = row_ite + current_row_dims) {
    if (row_ite + BLK_NROWS > matrix_nrows)
       current_row_dims = matrix_nrows - row_ite;
    else if(row_ite + BLK_NROWS == matrix_nrows - 1)
       current_row_dims = BLK_NROWS - 1;
    else
       current_row_dims = BLK_NROWS;
    //printf("current_row_dims=%d \n", current_row_dims);    
    //std::vector<std::future<gemini::Status>> mvp_col_tasks;

    for (uint32_t col_ite =0;col_ite < matrix_ncols; col_ite = col_ite + BLK_NCOLS) {
      uint32_t current_col_dims;
      //printf("col_ite=%d \n", col_ite);    

      if (col_ite + BLK_NCOLS > matrix_ncols)
         current_col_dims = matrix_ncols - col_ite;
      else
         current_col_dims = BLK_NCOLS;

       if(MT_in_subblock)
         MVP_col_MT(current_row_dims, current_col_dims, row_ite,  col_ite);   
       else
         mvp_col_tasks.emplace_back(mvp_context_->LaunchSubTask(MVP_col_MT, current_row_dims, current_col_dims, row_ite, col_ite));

    }
    
  } 

  if(!MT_in_subblock) {
  for (auto&& t : mvp_col_tasks) {
    t.get();
    }
    //std::cout << "multi thread done" <<std::endl;
  }



  for (unsigned int row_index =0; row_index<row_sub_block_num; row_index++) {
    str_tmp = mvp_matrix_result[row_index][0];
    for (int i=1;i< ct_vec_num; i++) {
      gemini::mvp::MVPMetaInfo acc_meta;
      acc_meta.is_transposed = false;
      acc_meta.nrows = static_cast<size_t>(current_row_dims);

      std::vector<std::string> Matvec_added;
      auto add_state = gemini::mvp::api::AddMatVec(mvp_context_, str_tmp, mvp_matrix_result[row_index][i], acc_meta, Matvec_added);
      if (!add_state.ok()) {
         throw std::runtime_error("MVP merge UpdateVector failed: " + add_state.ToString());
      }
      str_tmp = Matvec_added[0];
    }

    mvp_merge = mvp_merge + std::to_string(str_tmp.size() | (1 << 30));
    mvp_merge = mvp_merge + str_tmp;
  }



  MVPMatVecProd MVP_result_merge(mvp_merge, matrix_nrows, kDefaultScale_ * kDefaultScale_);
  return MVP_result_merge;  
}

std::vector<double> MVPProtocol::Decrypt(const MVPMatVecProd &MVP_ct_set) {
  
  //std::vector<MVPMatVecProd> ct_vec = MVP_ct_set.view();
  std::string cipher_buffer = MVP_ct_set.view();  
  uint32_t buffer_ptr =0;
  //uint32_t split_num = (MVP_ct_set.vector_len()+ BLK_NROWS -1 )/ BLK_NROWS;  
  double scale = MVP_ct_set.scale();
  uint64_t matrix_nrows = MVP_ct_set.vector_len();
  //for (int i=0; i<ct_vec.size();i++)
    // total_vec_len = total_vec_len + ct_vec[i].vector_len();
  
  std::vector<double> out(matrix_nrows);
  uint64_t out_offset = 0;

 

   uint32_t current_row_dims = BLK_NROWS;
   for (uint32_t row_ite =0;row_ite < matrix_nrows; row_ite = row_ite + current_row_dims) {
     if (row_ite + BLK_NROWS > matrix_nrows)
        current_row_dims = matrix_nrows - row_ite;
     else if(row_ite + BLK_NROWS == matrix_nrows - 1)
        current_row_dims = BLK_NROWS - 1;
     else
        current_row_dims = BLK_NROWS;
 
  //for (int i=0; i<split_num; i++) {
    std::string len_string = cipher_buffer.substr(buffer_ptr, buffer_ptr+10);
    size_t rec_length = atoi(len_string.c_str()) & 0xfffff;
    MVPMatVecProd ct(cipher_buffer.substr(buffer_ptr+10, buffer_ptr+10+rec_length), current_row_dims, scale);
    buffer_ptr = buffer_ptr+10+rec_length; 
    //MVPMatVecProd ct = ct_vec[i];

    if (!mvp_context_) {
      throw std::runtime_error("MVPProtocol is not activated yet");
    }
    if (!secret_key_) {
      throw std::runtime_error("secret_key is absent");
    }
    if (ct.vector_len() > gemini::mvp::global::kMaxNumRows) {
      throw std::invalid_argument(
          fmt::format("invalid ct.vector_len {}", ct.vector_len()));
    }
    gemini::mvp::MVPMetaInfo meta;
    meta.is_transposed = false;
    meta.nrows = ct.vector_len();
    meta.ncols = 1;
    //std::vector<double> out(ct.vector_len());


    const std::string ct_ptr = ct.view();

    gemini::mvp::VecBuffer out_u64(meta.nrows);
    auto state = gemini::mvp::api::DecryptMatVec(mvp_context_, ct_ptr, meta,
                                                 *secret_key_, out_u64);
    if (!state.ok()) {
      throw std::runtime_error("Decrypt failed: " + state.ToString());
    }
    std::transform(out_u64.data(), out_u64.data() + out_u64.size(), out.data()+out_offset,
                   [&](uint64_t u) { return U2kToReal(u, ct.scale()); });

    //printf("decrypt done ! \n");
    //printf("ct_ptr size = %d  \n", ct_ptr.size());
    //printf("my test: ct.vector_len=%d, out_u64.size= %d  \n ", ct.vector_len(), out_u64.size());
    
    out_offset = out_offset + out_u64.size();  
  }
  return out;
}

std::vector<double> MVPProtocol::Decrypt(const MVPEncryptedVec &ct) {
  if (!mvp_context_) {
    throw std::runtime_error("MVPProtocol is not activated yet");
  }
  if (!secret_key_) {
    throw std::runtime_error("secret_key is absent");
  }
  if (ct.vector_len() > gemini::mvp::global::kMaxNumRows) {
    throw std::invalid_argument(
        fmt::format("invalid ct.vector_len {}", ct.vector_len()));
  }
  gemini::mvp::MVPMetaInfo meta;
  meta.is_transposed = false;
  meta.nrows = ct.vector_len();
  meta.ncols = 1;

  gemini::mvp::VecBuffer out_u64(meta.nrows);
  auto state = gemini::mvp::api::DecryptMatVec(mvp_context_, ct.view(), meta,
                                               *secret_key_, out_u64);
  if (!state.ok()) {
    throw std::runtime_error("Decrypt failed: " + state.ToString());
  }

  std::vector<double> out(out_u64.size());
  std::transform(out_u64.data(), out_u64.data() + out_u64.size(), out.data(),
                 [&](uint64_t u) { return U2kToReal(u, 1); });
  return out;
}

PYBIND11_MODULE(_mvp_py, m) {
  m.doc() = R"pbdoc(
      MVP backend entry for python API.
    )pbdoc";

  py::module m_mvp = m.def_submodule("mvp");

  py::class_<MVPEvalKeys>(m_mvp, "MVPEvalKeys")
      .def(py::init<const std::string &>())
      .def(py::pickle(
          [](const MVPEvalKeys &obj) {  // __getstate__
            return py::make_tuple(py::bytes(obj.data()));
          },
          [](py::tuple t) {  // __setstate__
            if (t.size() != 1) throw std::runtime_error("Invalid state!");
            return MVPEvalKeys(t[0].cast<std::string>());
          }));

  py::class_<MVPEncryptedVec>(m_mvp, "MVPEncryptedVec")
      .def(py::init<const std::string &, size_t>())
      .def(py::pickle(
          [](const MVPEncryptedVec &obj) {  // __getstate__
            // Currently num_str \in [1, 4]
            const auto &ct_strs = obj.view();
            uint32_t num_str = ct_strs.size();
            if (num_str < 1 || num_str > 4) {
              throw std::invalid_argument("invalid encrypted vector");
            }
            return py::make_tuple(
                py::bytes(ct_strs[0]), py::bytes(num_str > 1 ? ct_strs[1] : ""),
                py::bytes(num_str > 2 ? ct_strs[2] : ""),
                py::bytes(num_str > 3 ? ct_strs[3] : ""), obj.vector_len());
          },
          [](py::tuple t) {  // __setstate__
            if (t.size() != 5) throw std::runtime_error("Invalid state!");
            std::vector<std::string> ct_strs;
            for (size_t i = 0; i < 4; ++i) {
              const std::string &str = t[i].cast<std::string>();
              if (str.length() == 0) break;
              ct_strs.push_back(str);
            }
            if (ct_strs.size() < 1) {
              throw std::runtime_error("Invalid state!");
            }
            return MVPEncryptedVec(ct_strs, t[4].cast<size_t>());
          }));

  py::class_<MVPMatVecProd>(m_mvp, "MVPMatVecProd")
      .def(py::init<const std::string &, size_t, double>())
      .def("scale_down", &MVPMatVecProd::scale_down, py::arg("factor"))
      .def(py::pickle(
          [](const MVPMatVecProd &obj) {  // __getstate__
            return py::make_tuple(py::bytes(obj.view()), obj.vector_len(),
                                  obj.scale());
          },
          [](py::tuple t) {  // __setstate__
            if (t.size() != 3) throw std::runtime_error("Invalid state!");
            return MVPMatVecProd(t[0].cast<std::string>(), t[1].cast<size_t>(),
                                 t[2].cast<double>());
          }));


   py::class_<MVPMatVecProd_Set>(m_mvp, "MVPMatVecProd_Set")
      .def(py::init<const std::vector<MVPMatVecProd> &>())
      .def("scale_down", &MVPMatVecProd_Set::scale_down, py::arg("factor"));
      //.def(py::pickle(
      //    [](const MVPMatVecProd_Set &obj) {
      //      return py::make_tuple(py::bytes(obj.view() ) );
      //    },
      //    [](py::tuple t) {
      //      if (t.size() != 1) throw std::runtime_error("Invalid state!");
      //      return MVPMatVecProd_Set(t[0].cast<std::vector<MVPMatVecProd>>());
      //    }));

  py::class_<MVPProtocol>(m_mvp, "MVPProtocol")
      .def(py::init<int, double>(),
           py::arg("multi_threads_num") = 4, py::arg("scale") = (1L << 15) )
      .def("activate", &MVPProtocol::Activate,
           py::arg("gen_secret_key") = false)
      .def("gen_eval_keys", &MVPProtocol::GenEvalKey)
      .def("setup_eval_keys", &MVPProtocol::SetupEvalKey, py::arg("eval_keys"))

      .def("encrypt_vector",
           py::overload_cast<const py::list &, bool>(
               &MVPProtocol::EncryptVector),
           py::arg("vec"), py::arg("is_symmetric") = false)
      .def("encrypt_vector",
           py::overload_cast<const py::array_t<double> &, bool>(
               &MVPProtocol::EncryptVector),
           py::arg("vec"), py::arg("is_symmetric") = false)

      .def("add_vector",
           py::overload_cast<const py::list &, const std::vector<MVPEncryptedVec> &>(
               &MVPProtocol::AddVector),
           py::arg("vec_plain"), py::arg("vec_cipher"))
      .def("add_vector",
           py::overload_cast<const py::array_t<double> &,
                             const std::vector<MVPEncryptedVec> &>(
               &MVPProtocol::AddVector),
           py::arg("vec_plain"), py::arg("vec_cipher"))

      .def("update_vector",
           py::overload_cast<const py::list &, const MVPMatVecProd &>(
               &MVPProtocol::UpdateVector),
           py::arg("vec_plain"), py::arg("vec_cipher"))
      .def(
          "update_vector",
          py::overload_cast<const py::array_t<double> &, const MVPMatVecProd &>(
              &MVPProtocol::UpdateVector),
          py::arg("vec_plain"), py::arg("vec_cipher"))

      .def("matvec",
           py::overload_cast<const py::list &, const std::vector<MVPEncryptedVec> &,
                             const std::array<int, 2> &>(&MVPProtocol::MatVec),
           py::arg("mat"), py::arg("vec_cipher"), py::arg("mat_dims"))
      .def("matvec",
           py::overload_cast<const py::array_t<double> &,
                             const std::vector<MVPEncryptedVec> &,
                             const std::array<int, 2> &>(&MVPProtocol::MatVec),
           py::arg("mat"), py::arg("vec_cipher"), py::arg("mat_dims"))

      .def("matvec2", &MVPProtocol::MatVecFMA, py::arg("mat"),
           py::arg("vec_plain"), py::arg("vec_cipher"), py::arg("mat_dims"))

      //.def("decrypt", &MVPProtocol::Decrypt, py::arg("vec_cipher"));
      .def("decrypt", 
           py::overload_cast<const MVPMatVecProd &>(
           &MVPProtocol::Decrypt), 
           py::arg("vec_cipher"))

      .def("decrypt",
           py::overload_cast<const MVPEncryptedVec &>(
           &MVPProtocol::Decrypt),
           py::arg("vec_cipher"));

}
