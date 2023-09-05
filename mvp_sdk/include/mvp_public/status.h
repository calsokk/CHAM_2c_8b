#ifndef MVP_PUBLIC_STATUS_H
#define MVP_PUBLIC_STATUS_H
#include <iosfwd>
#include <memory>
#include <string>

namespace gemini {

namespace error {

enum class Code {
  OK,
  INTERNAL,
  INVALID_ARGUMENT,
  OUT_OF_RANGE,
  UNIMPLEMENTED,
  UNAVAILABLE,
  FAILED_PRECONDITION,
  DATA_LOSS,
  UNKNOWN,
};

}

class Status {
 public:
  /// Create a success status.
  Status() {}

  static Status OK() { return Status(); }

  Status(error::Code code, const std::string msg) {
    state_ = std::unique_ptr<State>(new State);
    state_->code = code;
    state_->msg = msg;
  }

  /// Copy the specified status.
  Status(const Status& s);

  Status& operator=(const Status& s);

  error::Code code() const { return ok() ? error::Code::OK : state_->code; }

  bool ok() const { return (state_ == nullptr); }

  std::string ToString() const;

 private:
  struct State {
    error::Code code;
    std::string msg;
  };

  // OK status has a `NULL` state_.  Otherwise, `state_` points to
  // a `State` structure containing the error code and message(s)
  std::unique_ptr<State> state_;
};

inline Status::Status(const Status& s)
    : state_((s.state_ == nullptr) ? nullptr : new State(*s.state_)) {}

inline std::ostream& operator<<(std::ostream& os, const Status& x) {
  os << x.ToString();
  return os;
}

inline Status& Status::operator=(const Status& s) {
  if (state_ != s.state_) {
    if (s.state_ == nullptr) {
      state_ = nullptr;
    } else {
      state_ = std::unique_ptr<State>(new State(*s.state_));
    }
  }
  return *this;
}

#define DECLARE_ERROR(FUNC, CODE)                        \
  inline ::gemini::Status FUNC(const std::string& msg) { \
    return ::gemini::Status(error::Code::CODE, msg);     \
  }

DECLARE_ERROR(InvalidArgumentError, INVALID_ARGUMENT)
DECLARE_ERROR(UnavailableError, UNAVAILABLE)
DECLARE_ERROR(FailedPreconditionError, FAILED_PRECONDITION)
DECLARE_ERROR(OutOfRangeError, OUT_OF_RANGE)
DECLARE_ERROR(UnimplementedError, UNIMPLEMENTED)
DECLARE_ERROR(InternalError, INTERNAL)
DECLARE_ERROR(DataLossError, DATA_LOSS)
DECLARE_ERROR(UnknownError, UNKNOWN)

#undef DECLAR_ERROR
}  // namespace gemini

#endif  // MVP_PUBLIC_STATUS_H
