(ns com.palletops.docker.utils
  (:require
   [clojure.java.io :refer [copy file]])
  (:import
   (java.io File FileInputStream FileOutputStream InputStream OutputStream
            PipedInputStream PipedOutputStream)
   (java.security MessageDigest DigestOutputStream)
   (org.apache.commons.compress.archivers.zip ZipArchiveEntry ZipFile)
   (org.apache.commons.compress.archivers.tar
    TarArchiveEntry TarArchiveInputStream TarArchiveOutputStream)))

(defn- tar-entries
  "Return a lazy-seq of tarfile entries."
  [^TarArchiveInputStream s]
  (when-let [e (.getNextTarEntry s)]
    (cons e (lazy-seq (tar-entries s)))))

(defn- extract-entry
  [^TarArchiveInputStream tar-stream ^TarArchiveEntry entry target]
  (when entry
    (when-not (.isDirectory entry)
      (let [entry-name (.getName entry)
            file (file target)
            path (.getPath file)]
        (.mkdirs (.getParentFile file))
        (when (.exists file)
          (.setWritable file true))
        (with-open [out (FileOutputStream. path)]
          (copy tar-stream out))
        (let [mode (.getMode entry)
              bxor (fn [x m] (pos? (bit-xor x m)))
              band (fn [x m] (pos? (bit-and x m)))]
          (.setReadable file (band mode 400) (bxor mode 004))
          (.setWritable file (band mode 200) (bxor mode 002))
          (.setExecutable file (band mode 100) (bxor mode 001)))))))

(defn untar-stream
  "Untar from input stream to target directory."
  [target ^InputStream input-stream strip-components]
  (with-open [tar-stream (TarArchiveInputStream. input-stream)]
    (doseq [^TarArchiveEntry entry (tar-entries tar-stream)]
      (extract-entry tar-stream entry (file target (.getName entry))))))

(defn untar-stream-file
  "Untar from input stream to target directory."
  [target ^InputStream input-stream]
  (with-open [tar-stream (TarArchiveInputStream. input-stream)]
    (let [^TarArchiveEntry entry (first (tar-entries tar-stream))]
      (extract-entry tar-stream entry target))))


(defn tar-output-stream
  "Return a tar output stream and an input stream that it can be read from."
  []
  (let [pis (PipedInputStream.)
        pos (PipedOutputStream. pis)
        os (TarArchiveOutputStream. pos)]
    {:piped-input-stream pis
     :piped-output-stream pos
     :tar-output-stream os}))

(defn tar-entry-from-string
  "Add an entry to a tar archive output stream at path based on a string."
  [^TarArchiveOutputStream os ^String path s]
  (let [tmp (doto (File/createTempFile "uberimage" "tmp")
              (.deleteOnExit))]
    (try
      (spit tmp s)
      (let [entry (TarArchiveEntry. tmp path)]
        (try
          (.putArchiveEntry os entry)
          (copy tmp os)
          (finally
            (.closeArchiveEntry os))))
      (finally
        (.delete tmp)))))

(defn tar-entry-from-file*
  "Add an entry to a tar archive output stream at path based on a file, f."
  [^TarArchiveOutputStream os ^String path ^File f]
  (let [entry (TarArchiveEntry. f path)]
    (try
      (.putArchiveEntry os entry)
      (copy f os)
      (finally
        (.closeArchiveEntry os)))))

(defn tar-entry-from-file
  "Add an entry to a tar archive output stream at path based on a file
  or directory, f."
  [^TarArchiveOutputStream os path ^File local-file]
  (cond
   (.isFile local-file)
   (tar-entry-from-file* os path local-file)

   (.isDirectory local-file)
   (doseq [^java.io.File subdir-file (.listFiles local-file)]
     (tar-entry-from-file os
                          (str path "/" (.getName subdir-file))
                          subdir-file))))
