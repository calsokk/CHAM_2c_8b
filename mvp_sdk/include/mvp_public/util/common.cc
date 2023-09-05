#include "mvp_public/util/common.h"

#include "mvp_public/util/math.h"
#include "mvp_public/fpga_handler.h"

namespace gemini::mvp {

std::array<size_t, 2> GetSubmatrixShape(const MVPMetaInfo& meta, size_t N) {
  auto ncols = meta.is_transposed ? meta.nrows : meta.ncols;
  auto nrows = meta.is_transposed ? meta.ncols : meta.nrows;
  if (ncols < 1) {
    throw std::invalid_argument("GetSubmatrixShape: invalid ncols");
  }

  if (nrows < 1 || nrows > N) {
    throw std::invalid_argument("GetSubmatrixShape: invalid nrows");
  }

  ncols = std::min(N, ncols);
  nrows = NextPow2(nrows);
  size_t subnrows = std::min(nrows, 1UL << Log2(N / ncols));

  if (subnrows * ncols <= N) {
    subnrows = std::max(1UL, subnrows / 2);
    ncols = N / NextPow2(subnrows);
  }

  return std::array<size_t, 2>{subnrows, ncols};
}

size_t ExpectMatVecInputLen(const MVPMetaInfo &meta) {
  return meta.is_transposed ? meta.nrows : meta.ncols;
}

size_t ExpectMatVecOutputLen(const MVPMetaInfo &meta) {
  return meta.is_transposed ? meta.ncols : meta.nrows;
}

}  // namespace gemini::mvp

