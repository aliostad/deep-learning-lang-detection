(ns org.altlaw.util.zip
  (:import (java.io File FileOutputStream FileInputStream
                    InputStream OutputStream
                    ByteArrayInputStream ByteArrayOutputStream)
           (java.util.zip GZIPInputStream GZIPOutputStream
                          ZipInputStream ZipOutputStream ZipEntry)
           (org.apache.commons.io FileUtils IOUtils)))

(defn write-zip-file
  "Write a ZIP file to the stream, an OutputStream.  sources is a
  sequence of Files.  root is a File naming the top-level directory of
  the ZIP file; its path will be stripped off each source."
  [stream sources #^File root]
  (let [root-str (str (.getAbsolutePath root) File/separator)
        root-length (count root-str)]
    ;; First, check that everything's under root.  This can't be done
    ;; in the main loop because the Exception gets hidden by
    ;; "ZipException: ZIP file must have at least one entry"
    (doseq [#^File source (filter #(.isFile #^File %) sources)]
      (when-not (.startsWith (.getAbsolutePath source) root-str)
        (throw (Exception. (str "File <" source "> is not under <" root ">")))))
    ;; Now create the ZIP file.
    (let [out (ZipOutputStream. stream)]
      (doseq [#^File source (filter #(.isFile #^File %) sources)] ; source is a java.io.File
          (with-open [in (FileInputStream. source)]
          (let [source-path (.getAbsolutePath source)]
            (.putNextEntry out (ZipEntry. #^String (subs source-path root-length)))
            (IOUtils/copy in out)
            (.closeEntry out))))
      (.finish out))))

(defn unzip-stream [stream #^File dir]
  (when (and (.exists dir) (not (.isDirectory dir)))
    (throw (Exception. (str "Not a directory: " dir))))
  (.mkdirs dir)
  (let [in (ZipInputStream. stream)]
    (loop [entry (.getNextEntry in)]
      (when entry
        (let [name (.getName entry)
              path (File. dir name)]
          (if (.isDirectory entry)
            (.mkdir path)
            (with-open [out (FileOutputStream. path)]
              (IOUtils/copy in out)))
          (.closeEntry in)
          (recur (.getNextEntry in)))))))

(defn gzip-bytes [bytes]
  (let [input (ByteArrayInputStream. bytes)
        output (ByteArrayOutputStream.)
        gzip-output (GZIPOutputStream. output)]
    (IOUtils/copy input gzip-output)
    (.close gzip-output)
    (.toByteArray output)))

(defn gzip-utf8-string
  "Converts a string to gzipped UTF-8 text, returns a byte array."
  [s]
  (let [input (ByteArrayInputStream. (.getBytes s "UTF-8"))
        output (ByteArrayOutputStream.)
        gzip-output (GZIPOutputStream. output)]
    (IOUtils/copy input gzip-output)
    (.close gzip-output)
    (.toByteArray output)))

