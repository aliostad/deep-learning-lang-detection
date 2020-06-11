(ns manenko.compression.zip
  (:require [boot.util                 :as util]
            [clojure.java.io           :as io]
            [manenko.permissions.posix :as posix-permissions]
            [clojure.string :as str]
            [boot.core :as boot])
  (:import [org.apache.commons.compress.archivers     ArchiveStreamFactory]
           [org.apache.commons.compress.archivers.zip ZipFile ZipArchiveEntry]))


(defn ^:private unzip-entry
  "Extracts ZIP entry (a file or directory) creating all directories
  and setting Unix permissions (if run on a POSIX compliant file
  system)."
  [zip-file zip-entry output-dir]
  (let [permissions (posix-permissions/octal->symbolic (.getUnixMode zip-entry))
        entry-name  (.getName zip-entry)
        output-file (io/file output-dir entry-name)]
    (util/dbug "%s %s...\n" permissions entry-name)
    (if (.isDirectory zip-entry)
      (.mkdirs output-file)
      (do
        (io/make-parents output-file)
        (with-open [in  (io/input-stream (.getInputStream zip-file zip-entry))
                    out (io/output-stream output-file)]
          (io/copy in out))))
    (posix-permissions/set-file-permissions! output-file permissions)))


(defn unzip
  "Extracts the given ZIP archive into the given directory while
  preserving the Unix permissions."
  [archive output-dir]
  (with-open [zip-file (ZipFile. archive)]
    (doseq [zip-entry (enumeration-seq (.getEntries zip-file))]
      (unzip-entry zip-file zip-entry output-dir))))


(defn ^:private make-archive-output-stream
  "Creates a ZIP archive output stream from output stream."
  [output-stream]
  (-> (ArchiveStreamFactory.)
      (.createArchiveOutputStream ArchiveStreamFactory/ZIP output-stream)))


(defn ^:private make-archive-entry
  "Creates a new ZIP entry."
  [input-dir tmp-file]
  (let [full-path  (boot/tmp-path tmp-file)
        ;; Remove the input folder path from the path to the file
        entry-name (str/replace-first full-path input-dir "")
        entry-name (if (.startsWith entry-name "/")
                     (subs entry-name 1)
                     entry-name)]
    (ZipArchiveEntry. entry-name)))


(defn ^:private write-file-to-archive
  "Writes the input-file to the archive-stream as a ZIP archive entry."
  [input-dir tmp-file archive-stream]
  (let [entry      (make-archive-entry input-dir tmp-file)
        input-file (boot/tmp-file tmp-file)]
    (when-let [permissions (posix-permissions/get-file-permissions input-file)]
      (util/dbug "%s " permissions)
      (.setUnixMode entry (posix-permissions/symbolic->octal permissions)))
    (util/dbug "%s...\n" (.getName entry))
    (.putArchiveEntry archive-stream entry)
    (with-open [input-stream (io/input-stream input-file)]
      (io/copy input-stream archive-stream))
    (.closeArchiveEntry archive-stream)))


(defn zip
  "Compresses the content of the given TmpFiles (should reside in the
  same root directory) and writes ZIP archive to the given file."
  [input-dir input-files output-file]
  (io/make-parents output-file)
  (with-open [output-stream (io/output-stream output-file)]
    (let [archive-stream (make-archive-output-stream output-stream)]
      (doseq [input-file input-files]
        (write-file-to-archive input-dir input-file archive-stream))
      (.finish archive-stream))))
