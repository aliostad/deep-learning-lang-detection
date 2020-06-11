(ns webserver.io
  (:require [webserver.mime :refer [ext-to-data-type]])
  (:import [java.io File]))

(defn get-ext [file]
  (let [parts (clojure.string/split (.getName file) #"\.")]
    (if (> (.length parts) 1) (last parts) nil)))

(defn open-string-reader [socket]
  (java.io.BufferedReader. 
    (java.io.InputStreamReader.
      (.getInputStream socket))))

(defn open-string-writer [socket]
  (java.io.PrintStream.
    (.getOutputStream socket)))

(defn open-binary-writer [socket]
  (java.io.FilterOutputStream.
    (.getOutputStream socket)))

(defn- read-binary-file [file]
  (let [stream (java.io.FileInputStream. file)
        length (.length file)
        buffer (byte-array (map byte (take length (repeat 0))))]
    (.read stream buffer)
    {:length length :body buffer}))

(defn- read-text-file [file]
  (let [body (slurp file)]
    {:length (.length body) :body body}))

(defn read-file [file]
  (let [data-type (ext-to-data-type (get-ext file))
        content (if (= :binary data-type)
                  (read-binary-file file)
                  (read-text-file file))]
    (merge content {:data-type data-type})))
