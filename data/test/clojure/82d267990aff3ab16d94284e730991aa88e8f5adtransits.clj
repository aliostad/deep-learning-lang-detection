(ns chapter04
 (:import [java.io ByteArrayInputStream ByteArrayOutputStream])
 (:require [cognitect.transit :as transit]))

;; Write data to a stream
(def out (ByteArrayOutputStream. 4096))
(def writer (transit/writer out :msgpack))

(transit/write writer{:friends {:friend "Nick" :age 15}})

;; Take a peek at the JSON
(.toString out)
;; => "{\"~#'\":\"foo\"} [\"^ \",\"~:a\",[1,2]]"

;; Read data from a stream
(def in (ByteArrayInputStream. (.toByteArray out)))
(def reader (transit/reader in :msgpack))

(prn (transit/read reader))  ;; => {:a [1 2]}n
