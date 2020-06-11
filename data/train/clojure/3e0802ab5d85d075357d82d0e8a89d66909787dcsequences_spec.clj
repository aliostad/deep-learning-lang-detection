(ns clojure-http.utility.sequences-spec
  (:import (java.io ByteArrayInputStream))
  (:use speclj.core
        clojure-http.utility.sequences)
  (:use [clojure.contrib.io :only [reader]]))

(describe "sequences"

  (it "creates a byte sequence from a stream"
    (let [as_bytes  (. "ABC123" getBytes)
          stream    (reader (ByteArrayInputStream. as_bytes))]
      (should= (seq as_bytes) (byte-seq stream))))

  (it "creates a character sequence from a stream"
    (let [content   "ABC123"
          as_bytes  (. content getBytes)
          stream    (reader (ByteArrayInputStream. as_bytes))]
      (should= (seq content) (char-seq stream))))

)

(run-specs)
