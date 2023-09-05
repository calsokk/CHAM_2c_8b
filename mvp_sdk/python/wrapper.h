#ifndef MVP_PUBLIC_PYTHON_MVP_H
#define MVP_PUBLIC_PYTHON_MVP_H

#include "mvp_public/api_def.h"
#include <pybind11/numpy.h>

namespace seal {
class SecretKey;
}  // namespace seal

class MVPEvalKeys {
public:
  MVPEvalKeys(const std::string &data) : data_(data) {}

  const std::string& data() const { return data_; }

private:
  std::string data_;  
};

class MVPEncryptedVec {
public:
  MVPEncryptedVec(const std::string &data, size_t vec_len) : data_({data}), vec_len_(vec_len) {}

  MVPEncryptedVec(const std::vector<std::string> &data, size_t vec_len) : data_(data), vec_len_(vec_len) {}

  const std::vector<std::string>& view() const { return data_; };

  size_t vector_len() const { return vec_len_; }

private:
  std::vector<std::string> data_;
  size_t vec_len_;
};

class MVPMatVecProd {
public:
  MVPMatVecProd(const std::string &data, size_t vec_len, double scale) 
    : data_(data), vec_len_(vec_len), scale_(scale) {}

  MVPMatVecProd(std::string &&data, size_t vec_len, double scale) 
    : data_(std::move(data)), vec_len_(vec_len), scale_(scale) {}

  const std::string& view() const { return data_; };

  size_t vector_len() const { return vec_len_; }

  double scale() const { return scale_; }

  void scale_down(double factor) { if (factor < 1e-5) return; scale_ *= factor; }

private:
  std::string data_;
  size_t vec_len_;
  double scale_{1.};
};




class MVPMatVecProd_Set {
public:
  MVPMatVecProd_Set(const std::vector<MVPMatVecProd> &data)
    : data_(data) {}

  const std::vector<MVPMatVecProd> &view() const { return data_; };

  //size_t vector_len() const { return vec_len_; }

  //double scale() const { return scale_; }

  void scale_down(double factor) { 
     if (factor < 1e-5) return; 
     for(int i=0; i< data_.size(); i++)
         data_[i].scale_down(factor);
   }

private:
  std::vector<MVPMatVecProd> data_;
};


class MVPProtocol {
 public:
  explicit MVPProtocol(int kDefaultThreads = 4, double kDefaultScale = (1L << 15) );

  ~MVPProtocol();

  void Activate(bool gen_secret_key = false);

  MVPEvalKeys GenEvalKey();

  void SetupEvalKey(const MVPEvalKeys& keys);

  std::vector<MVPEncryptedVec> EncryptVector(const pybind11::array_t<double> &vec, bool is_symmetric);
  std::vector<MVPEncryptedVec> EncryptVector(const pybind11::list &vec, bool is_symmetric);

  // vec0 + vec1
  std::vector<MVPEncryptedVec> AddVector(const pybind11::array_t<double> &vec0, const std::vector<MVPEncryptedVec> &ct_in);
  std::vector<MVPEncryptedVec> AddVector(const pybind11::list &vec0, const std::vector<MVPEncryptedVec> &ct_in);

  // (mat*vec0) + vec1
  MVPMatVecProd UpdateVector(const pybind11::array_t<double> &vec, const MVPMatVecProd &ct_in);
  MVPMatVecProd UpdateVector(const pybind11::list &vec, const MVPMatVecProd &ct_in);

  // mat * vec
  MVPMatVecProd MatVec(const pybind11::array_t<double> &mat, const std::vector<MVPEncryptedVec> &ct_vec, const std::array<int, 2> &mat_dims);
  MVPMatVecProd MatVec(const pybind11::list &mat, const std::vector<MVPEncryptedVec> &ct_vec, const std::array<int, 2> &mat_dims);

  // mat * (vec0 + vec1)
  MVPMatVecProd MatVecFMA(const pybind11::array_t<double> &mat, 
                          const pybind11::array_t<double> &vec0, 
                          const MVPEncryptedVec &ct_vec1,
                          const std::array<int, 2> &mat_dims);

  std::vector<double> Decrypt(const MVPMatVecProd &ct);
  std::vector<double> Decrypt(const MVPEncryptedVec &ct);

 private:
  gemini::mvp::api::MVPContextPtr mvp_context_;
  std::shared_ptr<seal::SecretKey> secret_key_;
  int kDefaultThreads_ = 4;
  double kDefaultScale_ = 1L << 15;
};

#endif
