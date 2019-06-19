context("test-rcache")


test_that("test expire time", {
  cache <- Cacher$new(expire = 1)
  cache$set('a', iris)
  expect_identical(cache$get('a'), iris)
  Sys.sleep(1)
  expect_identical(cache$get('a'), NULL)
})


test_that("test exists", {
  cache <- Cacher$new(expire = 1)
  cache$set('a', iris)
  expect_true(cache$exist('a'))
  Sys.sleep(1)
  expect_false(cache$exist('a'))
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
                   
 
test_that('test callback directly', {
  cache <- Cacher$new(expire = 1)
  key = '1231'; val = 123
  expect_identical(cache$get_callback(key, function() val, expire=3), val)
  expect_identical(cache$exist(key), TRUE)
  expect_identical(cache$get(key), val)
  
  key2 = '456'; val2 = 456
  expect_identical(cache$get_callback(key2, function() val2, expire=30), val2)
  expect_identical(cache$exist(key2), TRUE)
  expect_identical(cache$get(key2), val2)
  
  Sys.sleep(3)
  # key will disappear while key2 will still alive
  expect_identical(cache$exist(key), FALSE)
  expect_identical(cache$get(key), NULL)
  expect_identical(cache$exist(key2), TRUE)
  expect_identical(cache$get(key2), val2)
})

