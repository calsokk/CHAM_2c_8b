#ifndef MVP_PUBLIC_UTIL_DEFINES_H
#define MVP_PUBLIC_UTIL_DEFINES_H

#define MVP_VERSION "1.2.0"
#define MVP_VERSION_MAJOR 1
#define MVP_VERSION_MINOR 2
#define MVP_VERSION_PATCH 0

#define MVP_TAG_SEAL_HEADER 0

namespace gemini::mvp::global {

constexpr uint32_t kLogPolyDegree = 12;
constexpr uint32_t kPolyDegree = 4096;

constexpr uint32_t kMaxNumRows = kPolyDegree;
constexpr uint32_t kMaxNumCols = 16384;

constexpr uint32_t kNumModulus = 3;
constexpr uint32_t kSecretShareBitLen = 64;

// clang-format off
constexpr uint64_t kModulus[kNumModulus]{
    (1ULL << 34) | (1ULL << 27) | 1ULL, 
	(1ULL << 34) | (1ULL << 19) | 1ULL,
    (1ULL << 38) | (1ULL << 23) | 1ULL};
// clang-format on

constexpr uint8_t MVP_USE_EXTRA_PRIME_FLAG = 0x1;

}  // namespace gemini::mvp::global
#endif  // MVP_PUBLIC_UTIL_DEFINES_H
