library(rhubactionstest)
stopifnot(identical(hello(), "Hello, world!"))
stopifnot(identical(hello("BSD"), "Hello, BSD!"))

# Fail, instead of skipping, if setup-r-dependencies did not install
# the suggested packages. bitops has C code, so it also tests the
# compilers on the VM.
stopifnot(identical(bitops::bitAnd(12L, 10L), 8))

Greeter <- R6::R6Class("Greeter", public = list(
  greet = function(name) hello(name)
))
stopifnot(identical(Greeter$new()$greet("R6"), "Hello, R6!"))
