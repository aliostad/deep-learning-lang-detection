(ns gzip-util.core
  (:import [java.io ByteArrayOutputStream]
           [java.util.zip GZIPInputStream GZIPOutputStream]
           [org.apache.commons.io IOUtils]))

(defn str->gzipped-bytes
  [str]
  (with-open [out (ByteArrayOutputStream.)
              gzip (GZIPOutputStream. out)]
    (do
      (.write gzip (.getBytes str))
      (.finish gzip)
      (.toByteArray out))))

(defn gzipped-input-stream->str
  [input-stream encoding]
  (with-open [out (ByteArrayOutputStream.)]
    (IOUtils/copy (GZIPInputStream. input-stream) out)
    (.close input-stream)
    (.toString out encoding)))
