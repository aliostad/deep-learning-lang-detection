(ns eindproject.models.util
"Utility functions."
  (:import java.io.ByteArrayOutputStream
           java.util.zip.ZipInputStream)
  (:require [clojure.java.io]))

(defn unzip-from-url
  [url]
  (with-open [a (ZipInputStream. (clojure.java.io/input-stream url))]
    (let [size (.getSize (.getNextEntry a))
          buf (byte-array size)
          os (ByteArrayOutputStream.)]
      (loop [size size]
        (let [read (.read a buf 0 size)]
          (.write os buf 0 read)
          (when (< read size)
            (recur (- size read)))))
      (clojure.java.io/reader (.toByteArray os)))))