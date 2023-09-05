#include "mvp_public/status.h"

#include <stdio.h>

namespace gemini {

std::string error_name(error::Code code) {
  switch (code) {
    case error::Code::OK:
      return "OK";
      break;
    case error::Code::UNKNOWN:
      return "UNKNOWN";
      break;
    case error::Code::INVALID_ARGUMENT:
      return "INVALID_ARGUMENT";
      break;
    case error::Code::FAILED_PRECONDITION:
      return "FAILED_PRECONDITION";
      break;
    case error::Code::OUT_OF_RANGE:
      return "OUT_OF_RANGE";
      break;
    case error::Code::UNIMPLEMENTED:
      return "UNIMPLEMENTED";
      break;
    case error::Code::INTERNAL:
      return "INTERNAL";
      break;
    case error::Code::UNAVAILABLE:
      return "UNAVAILABLE";
      break;
    case error::Code::DATA_LOSS:
      return "DATA_LOSS";
      break;
    default:
      char tmp[30];
      snprintf(tmp, sizeof(tmp), "UNKNOWN_CODE(%d)", static_cast<int>(code));
      return tmp;
      break;
  }
}

std::string Status::ToString() const {
  if (state_ == nullptr) {
    return "OK";
  } else {
    std::string result(error_name(code()));
    result += ": ";
    result += state_->msg;
    return result;
  }
}

}  // namespace gemini
