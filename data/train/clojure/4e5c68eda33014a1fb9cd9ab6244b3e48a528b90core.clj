(ns clj-compress.core
  (:require [clojure.java.io :as io])
  (:import [org.apache.commons.compress.archivers ArchiveInputStream ArchiveStreamFactory]
           [org.apache.commons.compress.archivers.zip ZipArchiveEntry]
           [java.io OutputStream FileOutputStream FileInputStream]))

(defn files->zip [files zip-file-path]
  (let [zip-file (io/file zip-file-path)
      fo (FileOutputStream. zip-file)
      archive (-> (ArchiveStreamFactory.)
                     (.createArchiveOutputStream ArchiveStreamFactory/ZIP fo))]
  (doseq [f files]
    (.putArchiveEntry archiveOut (ZipArchiveEntry. (.getName f)))
    (io/copy (FileInputStream. f) archive)
    (.closeArchiveEntry archive))
  (.close archive)
  (.close fo)
  zip-file))
