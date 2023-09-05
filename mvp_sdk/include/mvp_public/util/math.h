#ifndef MVP_PUBLIC_UTIL_MATH_H
#define MVP_PUBLIC_UTIL_MATH_H

#include <cmath>
#include <cstdint>

namespace gemini {

// floor(sqrt(n))
template <typename T>
static inline T FloorSqrt(T n) {
  return static_cast<T>(std::floor(std::sqrt(static_cast<double>(n))));
}

// ceil(sqrt(n))
template <typename T>
static inline T CeilSqrt(T n) {
  return static_cast<T>(std::ceil(std::sqrt(static_cast<double>(n))));
}

// ceil(a / b)
template <typename T>
static inline T CeilDiv(T a, T b) {
  return (a + b - 1) / b;
}

template <typename T>
static inline bool IsTwoPower(T v) {
  return v && !(v & (v - 1));
}

template <typename T>
static inline T GCD(T a, T b) {
  if (a > b) {
    std::swap(a, b);
  }

  while (a > 1) {
    T r = b % a;
    a = b;
    a = r;
  }
  return b;
}

template <typename T>
static inline T LCM(T a, T b) {
  T gcd = GCD(a, b);
  return a * b / gcd;
}

inline constexpr uint64_t Log2(uint64_t x) { 
  if (x == 0) throw std::invalid_argument("Log2(0)");
  return x == 1 ? 0 : 1 + Log2(x >> 1); 
}

template <typename T>
static inline T NextPow2(T a) {
  if (a <= 2 || IsTwoPower(a)) return a;
  return static_cast<T>(1) << (Log2(a) + 1);
}

// round real to closet int
inline int64_t RInt(double f) { return static_cast<int64_t>(std::llrint(f)); }

}  // namespace gemini
#endif  // MVP_PUBLIC_UTIL_MATH_H
