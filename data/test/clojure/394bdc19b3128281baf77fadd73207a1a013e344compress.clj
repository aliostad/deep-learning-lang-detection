(ns mazai.compress
  (:require [clojure.data.codec.base64 :as b64])
  (:import (java.io ByteArrayInputStream
                    ByteArrayOutputStream)
           (java.util.zip InflaterInputStream
                          DeflaterOutputStream)))


(defn encode-bytes [^bytes bb]
  (with-open [out (ByteArrayOutputStream.)
              gzip (DeflaterOutputStream. out)]
    (.write gzip bb)
    (.finish gzip)
    (b64/encode (.toByteArray out))))


(defn decode-bytes [^bytes bb]
  (with-open [in (ByteArrayInputStream. (b64/decode bb))
              gzip (InflaterInputStream. in)]
    (slurp gzip)))
