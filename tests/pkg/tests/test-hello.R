library(rhubactionstest)
stopifnot(identical(hello(), "Hello, world!"))
stopifnot(identical(hello("BSD"), "Hello, BSD!"))

# Fail, instead of skipping, if setup-r-dependencies did not install
# the suggested packages. bitops has C code, so it also tests the
# compilers on the VM.
stopifnot(identical(bitops::bitAnd(12L, 10L), 8))

# Compiled code of the package itself, C and C++. On the sanitizer
# and valgrind platforms these run with the checks turned on.
stopifnot(identical(rhubactionstest:::sum_c(1:10), 55))
stopifnot(identical(rhubactionstest:::cumsum_cpp(1:4), c(1, 3, 6, 10)))
stopifnot(identical(rhubactionstest:::sum_c(numeric()), 0))

Greeter <- R6::R6Class("Greeter", public = list(
  greet = function(name) hello(name)
))
stopifnot(identical(Greeter$new()$greet("R6"), "Hello, R6!"))
