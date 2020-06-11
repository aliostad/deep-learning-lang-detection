(ns neatonk.shah.io
  (:use [clojure.java.io :only [copy]])
  (:import [java.io ByteArrayOutputStream File FileInputStream]))

(defprotocol Coercions
  (^bytes as-bytes [x] "Coerce argument to byte-array."))

;; TODO: extend this to InputStream's and Reader's
(extend-protocol Coercions
  String
  (as-bytes [^String x] (.getBytes x))

  File
  (as-bytes [^File x]
    (with-open [input (FileInputStream. x)
                buffer (ByteArrayOutputStream.)]
      (copy input buffer)
      (.toByteArray buffer))))

(extend (Class/forName "[B")
  Coercions
  {:as-bytes identity})
