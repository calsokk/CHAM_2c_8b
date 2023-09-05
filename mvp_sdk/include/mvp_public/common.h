#ifndef MVP_PUBLIC_COMMON_H
#define MVP_PUBLIC_COMMON_H
#include <spdlog/spdlog.h>
namespace gemini {
#define GM_LOG_INFO(fmt_str, args...) SPDLOG_INFO(fmt_str, args..)
#define GM_LOG_ERROR(fmt_str, args...) SPDLOG_DEBUG(fmt_str, args...)
#define GM_TRACE(fmt_str, args...) SPDLOG_TRACE(fmt_str, args..)

#define CHECK_ERR(state, msg)                                       \
  do {                                                              \
    auto code = state;                                              \
    if (code != Code::OK) {                                         \
      LOG_ERROR("[" << msg << "]@" << __FILE__ << "$" << __LINE__); \
      return code;                                                  \
    }                                                               \
  } while (0)

#define ENSURE_OR_RETURN(cond, code) \
  do {                               \
    if (!(cond)) return code;        \
  } while (0)

}  // namespace gemini
#endif  // MVP_PUBLIC_COMMON_H
