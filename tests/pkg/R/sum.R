sum_c <- function(x) {
  .Call(rhubactionstest_sum_c, as.double(x))
}

cumsum_cpp <- function(x) {
  .Call(rhubactionstest_cumsum_cpp, as.double(x))
}
