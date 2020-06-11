(ns clj-gzip.core
  (:require [clojure.java.io :as io])
  (:import [java.io ByteArrayOutputStream ByteArrayInputStream]
           [java.util.zip GZIPInputStream GZIPOutputStream]))

(defn compress-byte-array [byte-array]
  (let [out (ByteArrayOutputStream.)]
    (with-open [out out
                gzip (GZIPOutputStream. out)]
      (io/copy (ByteArrayInputStream. byte-array)
               gzip))
    (.toByteArray out)))

(defn uncompress-byte-array [byte-array]
  (let [out (ByteArrayOutputStream.)]
    (with-open [out out
                gzip (GZIPInputStream. (ByteArrayInputStream. byte-array))]
      (io/copy gzip
               out))
    (.toByteArray out)))