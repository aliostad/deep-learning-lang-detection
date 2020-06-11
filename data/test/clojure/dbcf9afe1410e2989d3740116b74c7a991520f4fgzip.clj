(ns ^{:doc "GZIP compression/decompression convenience functions"}
  kits.gzip
  (:import
    java.io.ByteArrayOutputStream
    java.io.ByteArrayInputStream
    java.io.BufferedReader
    java.io.InputStreamReader
    java.util.zip.GZIPOutputStream
    java.util.zip.GZIPInputStream))

(defn compress [^String in]
  (let [^ByteArrayOutputStream byte-stream (ByteArrayOutputStream.)]
    (with-open [^GZIPOutputStream gzip-stream (GZIPOutputStream. byte-stream)]
      (.write gzip-stream (.getBytes in "UTF-8")))
    (.toByteArray byte-stream)))

(defn stream-contents [byte-stream & [^String encoding]]
  (let [buf (StringBuffer.)]
    (with-open [^GZIPInputStream gzip-stream (GZIPInputStream. byte-stream)]
      (let [reader (BufferedReader.
                    (InputStreamReader. gzip-stream (or encoding "UTF-8")))]
        (loop [l (.readLine reader)]
          (if (nil? l)
            (.toString buf)
            (do
              (.append buf l)
              (recur (.readLine reader)))))))))

(defn decompress [byte-array & [encoding]]
  (stream-contents (ByteArrayInputStream. byte-array) encoding))
