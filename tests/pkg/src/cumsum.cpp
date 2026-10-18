#include <algorithm>
#include <numeric>
#include <vector>

#include <R.h>
#include <Rinternals.h>

extern "C" SEXP rhubactionstest_cumsum_cpp(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  std::vector<double> buf(REAL(x), REAL(x) + n);
  std::partial_sum(buf.begin(), buf.end(), buf.begin());
  SEXP res = PROTECT(Rf_allocVector(REALSXP, n));
  std::copy(buf.begin(), buf.end(), REAL(res));
  UNPROTECT(1);
  return res;
}
