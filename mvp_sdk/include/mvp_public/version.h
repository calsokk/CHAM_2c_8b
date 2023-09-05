#ifndef MVP_PUBLIC_VERSION_H
#define MVP_PUBLIC_VERSION_H
#include "mvp_public/util/defines.h"

namespace gemini {
namespace mvp {

struct MVPVersion {
  uint8_t major = MVP_VERSION_MAJOR;
  uint8_t minor = MVP_VERSION_MINOR;
  uint8_t patch = MVP_VERSION_PATCH;
  uint8_t tweak = 0;
};

}  // namespace mvp
}  // namespace gemini

#endif  // MVP_PUBLIC_VERSION_H
