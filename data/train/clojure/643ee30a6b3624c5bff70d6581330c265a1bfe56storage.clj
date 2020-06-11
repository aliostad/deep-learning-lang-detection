(ns clj.mapreduce.storage
  (:require [taoensso.nippy :as nippy])
  (:import (java.io IOException
                    File
                    FileOutputStream
                    FileInputStream
                    BufferedOutputStream
                    BufferedInputStream
                    DataOutputStream
                    DataInputStream)))

(defprotocol Storage
  (save! [_ m]
    "Persist key-value data to the underlying data storage")
  (read! [_]
    "Read from underlying data source and return the key-value pair seq"))

(defrecord DiskStorage [filename]
  Storage
  (save! [_ m]
    (let [targetfile (File. ^String filename)
          tmpfile (File. (str filename ".tmp"))]
      (when (.exists tmpfile)
        (throw (IOException. "Write conflict")))
      (try
        (with-open [out (->> tmpfile
                             FileOutputStream.
                             BufferedOutputStream.
                             DataOutputStream.)]
          (nippy/freeze-to-stream! out m))
        (.renameTo tmpfile targetfile)
        (catch IOException e
          (.delete tmpfile)))))
  (read! [_]
    (with-open [in (->> ^String filename
                        FileInputStream.
                        BufferedInputStream.
                        DataInputStream.)]
      (nippy/thaw-from-stream! in false))))


(defn disk-storage 
  "Create a disk storage backed by given file"
  [filename]
  (DiskStorage. filename))