(ns photodb-server.utils)

(require 'photodb-server.core)
(require '[photodb-server.manage :as manage])
(require '[clojure.data.json :as json])

(defn export-images
  "Exports given type of images for given set of tags to given path. Creates path if not exists"
  [tags type path]

  (.mkdirs (new java.io.File path))
  (let [images (manage/images-find tags)]
    (doseq [image images]
      (let [filename (manage/path-name (:path image))
            output-stream (new java.io.FileOutputStream (str path "/" filename))
            image-bytes (photodb-server.core/render-image-api (:id image) type)]
        (.write output-stream image-bytes)
        (.close output-stream)))))

; todo use render/ methods
(defn export-images-and-create-album
  "Exports given type of images for given set of tags to given path and creates album html page.
  Creates path if not exists"
  [tags type path]

  (.mkdirs (new java.io.File path))
  (let [images (manage/images-find tags)]
    (with-open [album-writer (clojure.java.io/writer (str path "/index.html"))]
      (.write album-writer "<html>\n\t<head>\n\t</head>\n\t<body align='center'>\n")
      (doseq [image images]
        (let [filename (manage/path-name (:path image))
              image-bytes (photodb-server.core/render-image-api (:id image) type)]
          (with-open [output-stream (new java.io.FileOutputStream (str path "/" filename))]
            (.write output-stream image-bytes))
          (.write album-writer (str
                                 "\t\t<img src='"
                                 filename
                                 "' style='max-width:800px;max-height:800px;width:auto;height:auto;'"
                                 "></br></br></br></br></br>\n"))))
      (.write album-writer "\t</body>\n</html>"))))

(defn export-metadata
  "Exports metadata for given tags to given path"
  [tags path]
  (let [images (map
                 (fn [image] (dissoc image :_id))
                 (manage/images-find tags))
        json-str (clojure.data.json/write-str images)
        output-stream (new java.io.FileOutputStream path)]
    (.write output-stream (.getBytes json-str))
    (.close output-stream)))


; fns for data discovery on hard drive


;(defn md5checksum-fn-create []
;  (let [message-digest (java.security.MessageDigest/getInstance "MD5")]
;    (fn [input-stream]
;      (let [bytes (org.apache.commons.io.IOUtils/toByteArray input-stream)]
;        (.encodeToString (java.util.Base64/getEncoder) (.digest message-digest bytes))))))

; note used unsigned big int to get same as md5 *command
(defn null-input-stream-consumer [input-stream]
  (let [buffer (byte-array 16777216)]
    (loop []
      (if (not (= (.read input-stream buffer) -1))
        (recur)))))

(defn md5checksum-fn-create []
  (let [message-digest (java.security.MessageDigest/getInstance "MD5")]
    (fn [input-stream]
      (let [bytes (org.apache.commons.io.IOUtils/toByteArray input-stream)]
        (.toString (new java.math.BigInteger 1 (.digest message-digest bytes)) 16)))))

(defn md5checksum-on-stream-fn-create []
  (let [message-digest (java.security.MessageDigest/getInstance "MD5")]
    (fn [input-stream]
      (let [digest-input-stream (new java.security.DigestInputStream input-stream message-digest)]
        (null-input-stream-consumer digest-input-stream)
        (.toString (new java.math.BigInteger 1 (.digest message-digest)) 16)))))

(defn walk-directory-seq [directory-path]
  (let [path (if
               (string? directory-path)
               directory-path
               (clojure.string/join "/" directory-path))
        path-file (new java.io.File path)
        md5sum-fn (md5checksum-on-stream-fn-create)]
    (map
      (fn [file]
        (with-open [input-stream (new java.io.FileInputStream (.getPath file))]
          {
            :filename (.getName file)
            :path (.getPath file)
            :parent (.getParent file)
            :size (.length file)
            :md5sum (md5sum-fn input-stream)}))
      (filter
        #(not (.isDirectory %1))
        (file-seq path-file)))))

(defn write-files-info [directory-path report-file]
  (with-open [writer (clojure.java.io/writer report-file)]
    (reduce
      (fn [counter file-info]
        (.write writer (json/write-str file-info :escape-slash false))
        (.write writer "\n")

        (if (= (rem counter 1000) 0)
          (println "Files processed: " counter))
        (inc counter))
      0
      (walk-directory-seq directory-path))))


(defn write-images-db-to-file [db file-path]
  (with-open [writer (clojure.java.io/writer file-path)]
    (doseq [image (manage/images-seq)]
      (.write writer (json/write-str image))
      (.write writer "\n"))))


(defn old-id-to-new-one [old-id]
  (.toString
    (new
      java.math.BigInteger
      1
      (.toByteArray
        (new java.math.BigInteger old-id, 16)))
    16))



