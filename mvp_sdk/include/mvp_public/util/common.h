#ifndef MVP_PUBLIC_UTIL_COMMON_H
#define MVP_PUBLIC_UTIL_COMMON_H

#include <spdlog/spdlog.h>

#include <array>

#include "mvp_public/types.h"

namespace gemini::mvp {

#define LOG_ERROR(msg)             \
  do {                             \
    std::cerr << msg << std::endl; \
  } while (0)

#define GM_LOG_INFO(...)       \
  do {                         \
    spdlog::info(__VA_ARGS__); \
  } while (0)
#define GM_LOG_WARN(...)       \
  do {                         \
    spdlog::warn(__VA_ARGS__); \
  } while (0)
#define GM_LOG_DEBUG(...)       \
  do {                          \
    spdlog::debug(__VA_ARGS__); \
  } while (0)
#define GM_LOG_ERROR(...)       \
  do {                          \
    spdlog::error(__VA_ARGS__); \
  } while (0)
#define GM_LOG_FATAL(...)         \
  do {                            \
    spdlog::critical(__VA_ARGS__); \
  } while (0)
#define GM_TRACE(...)           \
  do {                          \
    spdlog::trace(__VA_ARGS__); \
  } while (0)

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

#define CATCH_SEAL_ERROR(state)                                      \
  do {                                                               \
    try {                                                            \
      state;                                                         \
    } catch (const std::logic_error &e) {                            \
      std::cerr << "SEAL_ERROR " << __FILE__ << __LINE__ << e.what() \
                << std::endl;                                        \
    }                                                                \
  } while (0)

std::array<size_t, 2> GetSubmatrixShape(const MVPMetaInfo &meta, size_t N);

size_t ExpectMatVecInputLen(const MVPMetaInfo &meta);

size_t ExpectMatVecOutputLen(const MVPMetaInfo &meta);

}  // namespace gemini::mvp
#endif  // MVP_PUBLIC_UTIL_COMMON_H
