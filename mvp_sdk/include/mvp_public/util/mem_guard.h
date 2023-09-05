#ifndef MVP_PUBLIC_UTIL_MEM_GAURD_H
#define MVP_PUBLIC_UTIL_MEM_GAURD_H
namespace gemini::mvp {

struct MemGuard {
  MemGuard(gsl::span<uint64_t> mem) : mem_(mem) {}
  MemGuard(RLWEPt& pt) : mem_(pt.data(), pt.coeff_count()) {}

  ~MemGuard() {
    // automatically erase out the decryption object
    if (mem_.data() && mem_.size() > 0) {
      seal::util::seal_memzero(mem_.data(), mem_.size() * sizeof(uint64_t));
    }
  }
  gsl::span<uint64_t> mem_;
};

} // gemini::mvp
#endif // MVP_PUBLIC_UTIL_MEM_GAURD_H
