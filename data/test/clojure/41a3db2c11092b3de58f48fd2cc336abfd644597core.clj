(ns zippix.core
  (:use clojure.java.io)
  (:require [clojure.string :as string])
  (:import [java.util.zip ZipInputStream]
           [java.io BufferedOutputStream]
           [java.io FileOutputStream]))

(require '[clojure.string :as string])

(def file-separator
  (str (.get (java.lang.System/getProperties) "file.separator")))

(defn pathify
  [paths]
  (string/join file-separator paths))

(defn mkdir [args]
  (.mkdirs (apply file args)))

(defn load-resource
  [resource-name]
  (let [thr (Thread/currentThread)
        ldr (.getContextClassLoader thr)]
    (.getResourceAsStream ldr resource-name)))

(defn read-stream
  [stream buffer-fn]
  (loop [buffer (byte-array 1024)
         bytes-read (.read stream buffer)]
    (if (not (= -1 bytes-read))
      (recur (buffer-fn buffer) (.read stream buffer))
      buffer)))

(defn write-zip-entry
  [zip-stream entry out-file]
  (let [out (BufferedOutputStream. (FileOutputStream. out-file) 1024)
        data (byte-array 1024)]
    (loop [len (.read zip-stream data 0 1024)]
      (if (not (= -1 len))
        (do (.write out data 0 len)
            (recur (.read zip-stream data 0 1024)))))
    (.flush out)
    (.close out)))

(defn copy-zip-entry
  [zip-stream entry destination]
  (let [out-file (file (pathify [destination (.getName entry)]))]
    (if (.isDirectory entry)
      (.mkdirs out-file)
      (write-zip-entry zip-stream entry out-file))
    (.getNextEntry zip-stream)))

(defn unzip-stream
  [zip-stream destination]
  (loop [entry (.getNextEntry zip-stream)]
    (if entry
      (recur (copy-zip-entry zip-stream entry destination))))
  (.close zip-stream))

(defn unzip-resource
  [zip-resource destination]
  (let [zip-stream (ZipInputStream. (input-stream (resource zip-resource)))]
    (unzip-stream zip-stream destination)))