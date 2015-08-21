# Test updateProvenance

context("updateProvenance")

test_that("handles bad input", {
  expect_error(updateProvenance())
  expect_error(updateProvenance(cars))
  expect_error(updateProvenance(cars, 14))
  expect_error(updateProvenance(cars, "message", caller = 14))
})

test_that("updates correctly", {

  e <- environment()    # we don't want to mess up global state, here

  x <- 10
  expect_error(updateProvenance(x, "message", env = e))  # provenance not created yet

  x <- createProvenance(x, env = e)

  m1 <- "message1"
  updateProvenance(x, m1, env = e)
  p1 <- provenance(x, env = e)
  expect_equal(nrow(p1), 1)
  expect_equal(p1$message, m1)
  expect_equal(p1$digest, digest(x))

  x <- x + 1
  m2 <- "message2"
  updateProvenance(x, m2, env = e)
  p2 <- provenance(x, env = e)
  expect_equal(nrow(p2), 2)
  expect_equal(p2$message[2], m2)
  expect_false(p2$digest[1] == p2$digest[2])
})
