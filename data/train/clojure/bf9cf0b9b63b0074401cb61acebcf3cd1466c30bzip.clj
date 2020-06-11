(ns lobsang.zip
  (:require [clojure.java.io :as io])
  (:import (java.util.zip GZIPOutputStream
                          GZIPInputStream)))

(defn zip-bytes [bytes]
  (with-open [baos (java.io.ByteArrayOutputStream.)
              zos (GZIPOutputStream. baos)]
    (io/copy (io/input-stream bytes)
             zos)
    (.close zos)
    (.toByteArray baos)))

(defn unzip-bytes [bytes]
  (with-open [bais (java.io.ByteArrayInputStream. bytes)
              zos (GZIPInputStream. bais)
              baos (java.io.ByteArrayOutputStream.)]
    (io/copy zos baos)
    (.toByteArray baos)))
