# Test createProvenance

context("createProvenance")

test_that("handles bad input", {
  expect_error(createProvenance())
  expect_error(updateProvenance(cars))
  expect_error(updateProvenance(cars, 14))
  expect_error(updateProvenance(cars, "message", caller = 14))
})

test_that("creates correctly", {
  x <- 10
  e <- environment()    # we don't want to mess up global state, here

  x <- createProvenance(x, env = e)
  expect_error(createProvenance(x, env = e))  # provenance already exists

  expect_is(attr(x, "provenance"), "character")

  provlist <- get(".provenance_list", env = e)
  expect_is(provlist, "list")
  prov <- provlist[[attr(x, "provenance")]]
  expect_equal(prov, dataprov())  # should be an empty provenance

  rm(".provenance_list")

})
