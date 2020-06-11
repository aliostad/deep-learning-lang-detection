(ns clj-atn.util
  (:import java.io.File)
  (:require [cheshire.core :refer :all])
  (:require [clojure.java.io :as io]))

(defn get-all-files
  "Get all files in a directory"
  [directory]
  (map #(.getPath %) (filter #(.isFile %) (.listFiles (File. directory)))))

(defn read-bin-file
  "Read file as a byte array"
  [filename]
  (with-open [input (java.io.FileInputStream. filename) 
              output (java.io.ByteArrayOutputStream.)]
    (io/copy input output)
    (.toByteArray output)))

; Fix me: filename should be default to name of actionfile
(defn write-json [tree filename]
  (generate-stream tree (io/writer filename) {:pretty true}))

(defn read-byte [stream]
  {:stream (next stream) :val (first stream)})

(defn- read-int [len stream]
  (let [[head rest] (split-at len stream)]
    {:stream rest :val (reduce #(+ (* 256 %1) %2) head)}))

(def read-int-16 (partial read-int 2))

(def read-int-32 (partial read-int 4))

(defn- seq-to-str [s]
  (String. (byte-array s)))

(defn read-unicode-string [stream]
  (let [{len :val rest :stream} (read-int-32 stream)
        str (take (* 2 len) rest)
        rev-str (flatten (map #(reverse %) (partition 2 str)))
        utf16-str (seq-to-str (map byte rev-str))]
    {:stream (drop (* 2 len) rest) :val utf16-str}))

(defn read-four-byte-string [stream]
  (let [[head rest] (split-at 4 stream)]
    {:stream rest :val (seq-to-str head)}))

(defn read-standard-string
  ([stream len]
     {:stream (drop len stream) :val (seq-to-str (take len stream))})
  ([stream]     
     (let [{len :val rest :stream} (read-int-32 stream)]
       (read-standard-string rest len))))

(defn read-token-or-string [stream]
  (let [{len :val rest :stream} (read-int-32 stream)]
    (if (zero? len)
      (read-four-byte-string rest)
      (read-standard-string rest len))))