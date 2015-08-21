# Test updateProvenance

context("updateProvenance")

test_that("handles bad input", {
  expect_error(updateProvenance())
  expect_error(updateProvenance(cars))
  expect_error(updateProvenance(cars, 14))
  expect_error(updateProvenance(cars, "message", caller = 14))
})

test_that("updates correctly", {
  m <- "message1"
  d <- updateProvenance(cars, "message1")
  p <- provenance(d)
  expect_equal(nrow(p), 1)
  expect_equal(p$message, m)
  expect_equal(p$digest, digest(d))
})
