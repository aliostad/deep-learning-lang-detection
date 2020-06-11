(ns dbexport.util
  (:require [clojure.java.io :as io])
  (:import (java.io InputStreamReader BufferedReader FileInputStream InputStream)
           (java.util.zip GZIPInputStream)
           (org.xerial.snappy SnappyInputStream)))

(defn read-file [^InputStream in]
  (let [buff (StringBuilder.)]
    (with-open [in (BufferedReader. (InputStreamReader. in))]
      (loop []
        (if-let [line (.readLine in)]
          (do (prn line ) (.append buff line))
          (recur))))
    (.toString buff)))

(defn read-gzip [file]
  (read-file (GZIPInputStream. (FileInputStream. (io/file file)))))

(defn read-snappy [file]
  (read-file (SnappyInputStream. (FileInputStream. (io/file file)))))
