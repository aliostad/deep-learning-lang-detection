(ns odessa.zip
  (:import
   [java.util.zip ZipInputStream ZipEntry])
  (:require
   [clojure.java.io :as io]))

(defn- entries [^ZipInputStream zip-stream]
  (lazy-seq
   (if-let [entry (.getNextEntry zip-stream)]
     (cons entry (entries zip-stream)))))

(defn- read-entry [^ZipInputStream zip-stream ^ZipEntry entry]
  (let [buf-size (.getSize entry)
        buf (byte-array buf-size)
        chunk-size 4096]
    (loop [i 0
           len (.read zip-stream buf 0 chunk-size)]
      (if (> len 0)
        (let [j (+ i len)]
          (recur j (.read zip-stream buf j (- buf-size j))))
        (do
          (.closeEntry zip-stream)
          {:filename (.getName entry)
           :last-modified  (.. entry getLastModifiedTime toInstant)
           :bytes buf})))))

(defn extract [uri pred]
  (with-open [zip-stream (ZipInputStream. (io/input-stream uri))]
    (->>
     zip-stream
     entries
     (map (partial read-entry zip-stream))
     (filter pred)
     first)))
