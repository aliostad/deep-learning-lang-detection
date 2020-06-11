(ns hurricane.codebase.zip-utils
  (:require [clojure.java.io :as io])
  (:import (java.util.zip ZipEntry ZipOutputStream)
           (java.io FileInputStream File ByteArrayOutputStream)
           (org.shisoft.hurricane UnzipUtil)))

(defn zip [src stream]
  (with-open [zip (ZipOutputStream. stream)]
    (doseq [f (file-seq (io/file src)) :when (.isFile f)]
      (.putNextEntry zip (ZipEntry. (.getPath f)))
      (io/copy f zip)
      (.closeEntry zip))))

(defn zip-to-file [src out]
  (zip src (io/output-stream out)))

(defn zip-in-mem [src]
  (let [mem-stream (ByteArrayOutputStream.)]
    (zip src mem-stream)
    mem-stream))

(defn unzip [src out]
  (UnzipUtil/unzip src out))