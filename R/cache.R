library(R6)

#' Cache Data
#' @description Offer a `Cacher` object to save data in a range of time.
#' @import R6
#' @param expire Cache time(seconds). The default value is 3600, which means one hour.
#' @param key Cached key.
#' @param value Cached value.
#' @param callback A callback function used to set the cached value, if the given key is not existed.
#' @usage
#' cache = Cacher$new(expire=3600)
#'
#' cache$set(key, value, expire)
#'
#' cache$get(key)
#'
#' cache$exist(key)
#'
#' cache$get_callback(key, callback, ...)
#' @examples
#' cache = Cacher$new(expire = 3) # cache 3 seconds
#' cache$set('a', 1)
#' cache$get('a') # 1
#' Sys.sleep(3)
#' cache$get('a') # NULL
#'
#' # set expire time explicitly
#' cache$set('b', 1, expire=10)
#'
#' # exist or not
#' cache$exist('b')  # return FALSE if it is expired
#'
#' # `get_callback` if key exists, return the cached value, otherwise
#' # run the callback function and cache its returned value
#' cache$get_callback('b', function() 123, expire=60)
#' Sys.sleep(10)
#' cache$get_callback('b', function() 123, expire=60)
#'
#' @export
Cacher <- R6Class("Cacher",
  private = list(
    expire = 3600
  ),
  public = list(
    data = list(),
    expireList = list(),
    setTimeList = list(),

    initialize = function(expire=3600){
      private$expire = expire
    },

    set = function(key, value, expire=private$expire){
      stopifnot(is.character(key))
      stopifnot(is.numeric(expire))
      self$data[[key]] = value
      self$expireList[[key]] = expire
      self$setTimeList[[key]] = as.numeric(Sys.time())
      message(sprintf('%s will be expired in %ss', key, expire))
    },

    exist = function(key){
      setTime = self$setTimeList[[key]]
      if (is.null(setTime)) return(TRUE)
      if (as.numeric(Sys.time()) - setTime > self$expireList[[key]]){
        self$del(key)
        return(FALSE)
      }
      return(TRUE)
    },

    del = function(key){
      self$data[[key]] = NULL
      self$expireList[[key]] = NULL
      self$setTimeList[[key]] = NULL
    },

    get = function(key){
      if (self$exist(key)) return(self$data[[key]])
      NULL
    },

    get_callback = function(key, callback, ...){
      if (self$exist(key)) return(self$data[[key]])
      if (is.function(callback)){
        value = callback()
        self$set(key, value, ...)
        return(value)
      }
    }
  )
)
