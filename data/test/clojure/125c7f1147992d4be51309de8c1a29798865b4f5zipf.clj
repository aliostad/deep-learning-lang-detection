(ns clj-epub.zipf
  "zip file output"
  (:import [java.util.zip ZipEntry ZipOutputStream CRC32]
           [java.io InputStreamReader
                    ByteArrayInputStream
                    ByteArrayOutputStream
                    FileOutputStream
                    FileInputStream]))

(defn open-zipstream
  "open ZipOutputStream by ByteArrayOutputStream"
  [#^ByteArrayOutputStream baos]
  (ZipOutputStream. baos))

(defn open-zipfile
  "open ZipOutputStream by file"
  [f]
  (ZipOutputStream. (FileOutputStream. f)))

;;;
; str base

(defn stored
  "add no deflated text to zip file "
  [#^ZipOutputStream zos {name :name text :text}]
  (.setMethod zos ZipOutputStream/STORED)
  (let [crc   (CRC32.)
        ze    (ZipEntry. name)
        bytes  (.getBytes text)
        count (alength bytes)]
    (.update crc bytes)
    (doto ze
      (.setSize count)
      (.setCrc (.getValue crc)))
    (doto zos
      (.putNextEntry ze)
      (.write bytes 0 count)
      (.closeEntry))))

(defn- output-stream
  ""
  [input #^ZipOutputStream output]
  (let [buf (char-array 1024)]
    (loop [count (.read input buf 0 1024)]
      (if (not= count -1)
        (let [str (String. buf 0 count)
              bytes (.getBytes str "UTF-8")
              len (alength bytes)]
          (.write output bytes 0 len)))
      (if (not= count -1) ; 前のifとまとめるとloop-recur syntax error
        (recur (.read input buf 0 1024))))))

(defn deflated
  "add deflated text to zip file"
  [#^ZipOutputStream zos {name :name text :text}]
  (.setMethod zos ZipOutputStream/DEFLATED)
  (.putNextEntry zos (ZipEntry. name))
  (let [fis (InputStreamReader. (ByteArrayInputStream. (.getBytes text "UTF-8")) "UTF-8")]
    (output-stream fis zos))
  (.closeEntry zos))