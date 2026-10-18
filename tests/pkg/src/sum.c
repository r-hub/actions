#include <stdlib.h>

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP rhubactionstest_cumsum_cpp(SEXP x);

/* Copies the input to a heap buffer first, so the sanitizers and
   valgrind have some memory access to watch. */

SEXP rhubactionstest_sum_c(SEXP x) {
  R_xlen_t i, n = XLENGTH(x);
  double *buf = malloc((n + 1) * sizeof(double));
  if (!buf) Rf_error("Out of memory");
  for (i = 0; i < n; i++) buf[i] = REAL(x)[i];
  double sum = 0;
  for (i = 0; i < n; i++) sum += buf[i];
  free(buf);
  return Rf_ScalarReal(sum);
}

static const R_CallMethodDef callMethods[] = {
  { "rhubactionstest_sum_c",      (DL_FUNC) &rhubactionstest_sum_c,      1 },
  { "rhubactionstest_cumsum_cpp", (DL_FUNC) &rhubactionstest_cumsum_cpp, 1 },
  { NULL, NULL, 0 }
};

void R_init_rhubactionstest(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
