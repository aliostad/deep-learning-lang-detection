(ns chriscnc.utils.io
  (:require [clojure.java.io :as io])
  (:import [java.util.zip GZIPInputStream GZIPOutputStream]))


(defn gzip-reader
  "Takes the same args as clojure.java.io.reader, presuming that the argument
  refers to a gzipped text file."
  [x & args]
  (apply io/reader (GZIPInputStream. (io/input-stream x)) args))


(defn gzip-writer
  "Takes the same args as clojure.java.io.writer, writing a gzipped text file."
  [x & args]
  (apply io/writer (GZIPOutputStream. (io/output-stream x)) args))

