(ns bits.file-transfer-test
  (:import [java.io File InputStream FileInputStream FileOutputStream OutputStream]
           [java.net Socket]))

; Understand FileInput/OutputStream!

(defn read-bytes [^InputStream in]
  (let [ary (byte-array (.available in))]
    (.read in ary)
    (.close in)
    ary))

(defn write-bytes [^OutputStream out ^bytes b-array]
  (.write out b-array)
  (.close out))

(defn read-bytes-from-file [^String path]
  (let [f (File. path)]
    (read-bytes (FileInputStream. f))))

(defn write-bytes-to-file [^String path ^bytes b-array]
  (let [f (File. path)]
    (write-bytes (FileOutputStream. f) b-array)))

(defn read-bytes-from-sock [^Socket sock]
  (read-bytes (.getInputStream sock)))

(defn write-bytes-to-sock [^Socket sock ^bytes b-array]
  (write-bytes (.getOutputStream sock) b-array))