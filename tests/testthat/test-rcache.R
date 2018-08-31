context("test-rcache")


test_that("test expire time", {
  cache <- Cacher$new(expire = 1)
  cache$set('a', iris)
  expect_identical(cache$get('a'), iris)
  Sys.sleep(1)
  expect_identical(cache$get('a'), NULL)
})

test_that("test callback", {
  cache <- Cacher$new(expire = 1)
  cache$set('a', iris)
  expect_identical(cache$get('a'), iris)
  Sys.sleep(1)
  expect_identical(cache$get_callback('a', function() 1), 1)
  expect_identical(cache$get('a'), 1)
  Sys.sleep(1)
  expect_identical(cache$get('a'), NULL)
})
