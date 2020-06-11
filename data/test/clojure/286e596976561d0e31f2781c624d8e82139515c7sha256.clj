(ns fileyard.sha256
  "Calculate SHA-256 hash of input stream"
  (:import (java.security MessageDigest DigestInputStream)
           (javax.xml.bind.annotation.adapters HexBinaryAdapter)))


(defn with-digest-input-stream
  "Create a digest input stream that calculates SHA-256 hash of the bytes.
  Calls callback with the input stream for further processing and returns
  the digest."
  [input-stream callback]
  (let [md (MessageDigest/getInstance "SHA-256")]
    (with-open [dis (DigestInputStream. input-stream md)]
      (callback dis))
    (.marshal (HexBinaryAdapter.) (.digest md))))
