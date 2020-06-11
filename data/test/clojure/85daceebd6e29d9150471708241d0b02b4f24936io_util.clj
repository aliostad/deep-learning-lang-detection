(ns
  ^{:doc "Random io util functions for the io and io-plugin namespaces"}

  fileape.util.io-util
  (:require [fileape.parquet.writer :as parquet-writer]
            [clojure.string :as string]
            [clojure.java.io :as io])
  (:import (java.io DataOutputStream FileOutputStream BufferedOutputStream File)
           (java.util.zip GZIPOutputStream)
           (org.xerial.snappy SnappyOutputStream)
           (org.apache.parquet.schema MessageType)))



(defn create-zip-out [file]
  (DataOutputStream. (GZIPOutputStream. (FileOutputStream. (io/file file)))))

(defn create-buffered-zip-out [file buffer-size]
  (DataOutputStream. (GZIPOutputStream. (BufferedOutputStream. (FileOutputStream. (io/file file)) (int buffer-size)))))

(defn create-snappy-out [file]
  (DataOutputStream. (SnappyOutputStream. (FileOutputStream. (io/file file)))))

(defn create-buffered-snappy-out [file buffer-size]
  (DataOutputStream. (SnappyOutputStream. (BufferedOutputStream. (FileOutputStream. (io/file file)) (int buffer-size)))))

(defn create-out [file]
  (DataOutputStream. (FileOutputStream. (io/file file))))

(defn create-buffered-out [file buffer-size]
  (DataOutputStream. (BufferedOutputStream. (FileOutputStream. (io/file file)) buffer-size)))

(defn validate-parquet-conf! [k env {:keys [parquet-codec message-type]}]
  (when-not
    (and parquet-codec
         message-type
         (instance? MessageType message-type))
    (throw (RuntimeException. (str "Parquet config must have parquet-codec, and message-type:MessageType but got " parquet-codec " " message-type " for k " k " conf is " (keys env))))))


(defn open-parquet-file! [k file env {:keys [env-key-parser] :or {env-key-parser identity} :as conf}]
  (let [env-key (env-key-parser k)
        {:keys [parquet-codec message-type] :as entry}  (get @env env-key)]
    (validate-parquet-conf! env-key @env entry)
    ;delete the file because the parquet open file will create it and fail if the file exists
    (.delete ^File (clojure.java.io/file file))
    (apply parquet-writer/open-parquet-file!
           k
           message-type
           file
           :codec parquet-codec
           (mapcat identity conf))))

(defn close-parquet-file! [parquet]
  (parquet-writer/close! parquet))