rcache
======

This package offers a `Cacher` object, which can be used to cache data in a range of time.

## Insallation

```R
devtools::install_github('badbye/rcache')
```

## Usage

```R
cache = Cacher$new(expire = 3) # cache 3 seconds
cache$set('a', 1)
cache$get('a') # 1
Sys.sleep(3)
cache$get('a') # NULL

# set expire time explicitly
cache$set('b', 1, expire=10)

# exist or not
cache$exist('b')  # return FALSE if it is expired

# `get_callback` if key exists, return the cached value, otherwise
# run the callback function and cache its returned value
cache$get_callback('b', function() 123, expire=60)
Sys.sleep(10)
cache$get_callback('b', function() 123, expire=60)
```

The `get_callback` method sometimes could be very useful. Here is a satuation: 

```R
old_data_fun <- function() {
 # the returned data will change every day
}
cache = Cacher$new() 
new_data_fun <- function() {
  key = 'what ever you set'
  time2tomorrow <- function() {
    tomorrow = as.numeric(as.POSIXct(format(Sys.Date() + 1, '%Y-%m-%d 00:00:00'))) 
    tomorrow - as.numeric(Sys.time())
  } 
  cache$get_callback(key, old_data_fun, expire=time2tomorrow()) 
}
```

The `new_data_fun` function will return data immediately if it is cached. Otherwise, it will call the `old_data_fun` function to get data, and cache it until tomorrow.
