#ifndef MVP_PUBLIC_TYPES_H
#define MVP_PUBLIC_TYPES_H
#include <cassert>
#include <gsl/span>
#include <vector>
#include <string>

#include "mvp_public/version.h"

namespace seal {
class SEALContext;
class Ciphertext;
class Plaintext;
class GaloisKeys;
class Encryptor;
class Decryptor;
class Evaluator;
class KSwitchKeys;
};  // namespace seal

using RLWECt = seal::Ciphertext;
using RLWEPt = seal::Plaintext;

namespace gemini::mvp {

struct VecView {
 public:
  explicit VecView(const uint64_t* data, size_t len) : data_(data, len) {
	if (!data || len == 0) throw std::invalid_argument("nullptr");
  }

  VecView(const std::vector<uint64_t>& data) : data_(data) {}

  inline size_t num_elements() const { return data_.size(); }

  inline size_t size() const { return data_.size(); }

  const uint64_t* data() const { return data_.data(); }

 protected:
  gsl::span<const uint64_t> data_;
};

struct MatView {
 public:
  explicit MatView(const uint64_t* data, size_t nrows, size_t ncols)
      : data_(data, nrows * ncols), nrows_(nrows), ncols_(ncols) {
    if (!data) throw std::invalid_argument("nullptr");
    if (!data || nrows == 0 || ncols == 0) {
      throw std::invalid_argument("MatView");
    }
    assert(nrows > 0 && ncols > 0);
  }

  inline size_t num_elements() const { return data_.size(); }
  inline size_t nrows() const { return nrows_; }
  inline size_t ncols() const { return ncols_; }

  inline const uint64_t* data() const { return data_.data(); }

  const uint64_t* row_at(size_t r) const {
    if (r >= nrows_) {
      throw std::runtime_error("MatView::row_at");
    }
    return data_.data() + r * ncols_;
  }

 protected:
  gsl::span<const uint64_t> data_;
  size_t nrows_, ncols_;
  size_t num_elements_;
};

struct StrBufView {
 public:
  StrBufView(const std::vector<std::string>& str)
      : raw_(str.data(), str.size()) {}

  StrBufView(const std::string& str)
      : raw_(&str, 1) {}

  StrBufView(const std::string* str, size_t n) : raw_(str, n) {}

  size_t size() const { return raw_.size(); }

  const std::string& operator[](size_t i) const { return raw_[i]; }

 private:
  gsl::span<const std::string> raw_;
};

struct VecBuffer {
 public:
  explicit VecBuffer(size_t len) { resize(len); }

  VecBuffer(std::vector<uint64_t>&& stl) : data_(std::move(stl)) {}

  void resize(size_t len) {
    if (len > 0 || len != num_elements()) {
      data_.resize(len);
      len_ = len;
    }
  }

  inline size_t size() const { return len_; }

  inline size_t num_elements() const { return len_; }

  const uint64_t* data() const { return data_.data(); }

  uint64_t* data() { return data_.data(); }

  uint64_t at(size_t i) const {
    if (data_.empty() || i >= len_) {
      throw std::runtime_error("VecBuffer::at");
    }
    return data_[i];
  }

  uint64_t& at(size_t i) {
    if (data_.empty() || i >= len_) {
      throw std::runtime_error("VecBuffer::at accessing index: " +
                               std::to_string(i));
    }
    return data_.at(i);
  }

 protected:
  std::vector<uint64_t> data_;
  size_t len_{0};
};

struct MsgHeader {
  uint8_t matrix_tranposed{0};
  uint8_t base_mod_nbits{0};

  uint16_t nrows{0};
  uint16_t ncols{0};

  MVPVersion mvp_ver;
};

struct MVPMetaInfo {
  bool is_transposed = false;
  uint32_t base_mod_nbits = global::kSecretShareBitLen;
  size_t nrows, ncols;
};

}  // namespace gemini::mvp

#endif  // GEMINI_MVP_TYPES_H
