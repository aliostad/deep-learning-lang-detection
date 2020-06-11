(ns natsume-server.utils.xz
  (:require [clojure.java.io :as io]
            [clojure.string :as string]
            [clojure.tools.reader.edn :as edn])
  (:import [org.apache.commons.compress.compressors.xz XZCompressorInputStream XZCompressorOutputStream]))

;; EDN writer and reader utils

(defn xz-reader
  [fn]
  (-> fn io/file io/input-stream XZCompressorInputStream. io/reader))

(defn xz-line-seq
  "Utility function that turns XZ compressed text files into a line-seq."
  [fn]
  (-> fn xz-reader line-seq))

(defn xz-string ^String [^String s]
  (prn-str (-> s java.io.PrintStream. XZCompressorOutputStream.)))

(defn read-edn [s]
  (edn/read-string s))

(defn spit-edn-xz [filename data]
  (with-open [xz-out (-> filename
                         (string/replace ".txt" ".edn.xz")
                         io/file
                         io/output-stream
                         XZCompressorOutputStream.)]
    (spit xz-out (prn-str data))))

(defn slurp-edn-xz [filename]
  (with-open [xz-in (-> filename
                        (string/replace ".txt" ".edn.xz")
                        io/file
                        io/input-stream
                        XZCompressorInputStream.)]
    (edn/read-string (slurp xz-in))))
