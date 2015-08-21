# Test listProvenances

context("listProvenances")

test_that("lists correctly", {

  e <- environment()    # we don't want to mess up global state, here

  x <- 10
  x <- createProvenance(x, env = e)
  y <- 11
  y <- createProvenance(y, env = e)
  updateProvenance(y, "ym1", env = e)
  z <- 12
  z <- createProvenance(z, env = e)
  updateProvenance(z, "zm1", env = e)
  updateProvenance(z, "zm2", env = e)

  d <- listProvenances(env = e)
  expect_equal(nrow(d), 3)
  expect_equal(ncol(d), 3)
  expect_equal(d$Entries, 0:2)
})
