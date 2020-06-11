(ns itvgame-checking.io
  (:require [clojure.java.io :as jio])
  (:import [java.io ByteArrayOutputStream InputStream])
)

(defn read-bytes [^InputStream is]
  (let [bytes (make-array Byte/TYPE 512)]
    (with-open [baos (ByteArrayOutputStream.)]
      (loop [ret (.read is bytes)]
        (if (neg? ret) (.toByteArray baos)
          (do (.write baos bytes 0 ret) (recur (.read is bytes))))))))

(defn open-is [path] (jio/input-stream (jio/resource path)))

(defn slurp-cp [path] (with-open [is (open-is path)] (slurp is)))