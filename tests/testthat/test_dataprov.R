# Test dataprov

context("dataprov")

test_that("functions", {
  p <- dataprov()
  expect_is(p, "data.frame")
  expect_is(p, "provenance")

  expect_equal(nrow(p), 0)

  reqfields <- c("timestamp", "caller", "message", "digest")
  expect_true(all(reqfields %in% names(p)))
  expect_true(all(names(p) %in% reqfields))
  expect_is(p$timestamp, "POSIXct")
  expect_is(p$caller, "character")
  expect_is(p$message, "character")
  expect_is(p$digest, "character")
})
