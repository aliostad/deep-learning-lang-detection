(ns subtitles-downloader.hash-calc
  (:require digest)
  (:require [clojure.java.io :as io])
  (:gen-class))

  (def read-size (* 64 1024))

  (defn calculate-hash
    [file-name]

    (let [file (io/file file-name)]
      (when (.exists file)
        (with-open [stream (io/input-stream file)]
          (let [double-size (* read-size 2) file-array (byte-array double-size) skip-size (- (.length file) double-size)]
            (.read stream file-array 0 read-size)
            (.skip stream skip-size)
            (.read stream file-array read-size read-size)
            (digest/md5 file-array))))))
