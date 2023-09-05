#ifndef MVP_PUBLIC_ERRORS_H
#define MVP_PUBLIC_ERRORS_H
#include "mvp_public/status.h"

namespace gemini {

#define GM_RETURN_IF_ERROR(EXP) \
  do {                          \
    auto __status__(EXP);       \
    if (!__status__.ok()) {     \
      return __status__;        \
    }                           \
  } while (0)

#define GM_REQUIRES(EXP, STATUS) \
  do {                           \
    if (!(EXP)) {                \
      return STATUS;             \
    }                            \
  } while (0)

#define GM_REQUIRES_OK(EXP, STATUS) \
  do {                              \
    auto __status = (EXP);          \
    if (!__status.ok()) {           \
      return STATUS;                \
    }                               \
  } while (0)

#define GM_CATCH_SEAL_ERROR(EXP)                                    \
  do {                                                              \
    try {                                                           \
      (EXP);                                                        \
    } catch (const std::logic_error &e) {                           \
      return InternalError("SEAL error: " + std::string(e.what())); \
    }                                                               \
  } while (0)

}  // namespace gemini
#endif  // MVP_PUBLIC_ERRORS_H
