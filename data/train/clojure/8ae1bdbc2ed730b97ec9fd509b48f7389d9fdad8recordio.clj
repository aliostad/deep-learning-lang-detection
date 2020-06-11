(ns meson.util.recordio
  (:require [meson.util.bytes :as util]
            [taoensso.timbre :as log]))

(defprotocol IRecordIOStream
  (get-size! [this]
    "Get the size of the next record in the stream.")
  (get-data! [this record-size]
    "Get the data of the next record in the stream.")
  (next! [this] [this return-type]
    "A wrapper method that gets the size and then the data for the next
    record in the stream."))

(defn- read-record-size
  [^java.io.InputStream stream]
  (loop [data []]
    (let [byte (.read stream)]
      (if (util/newline? byte)
        (util/bytes->int data)
        (recur (conj data byte))))))

(defn- read-record-data
  [^java.io.InputStream stream asize]
  (let [array (byte-array asize)]
    (loop [byte-index 0]
      (if (= byte-index asize)
        array
        (do
          ;(log/trace "Reading byte at index" byte-index)
          (aset-byte array byte-index (.read stream))
          (recur (inc byte-index)))))))

(defn- read-next
  ([^java.io.InputStream stream]
    (let [size (read-record-size stream)]
      (read-record-data stream size)))
  ([^java.io.InputStream stream as]
    (let [data (read-next stream)]
      (case as
        :json (util/bytes->json data)
        :string (util/bytes->str data)
        :bytes data
        data))))

(def recordio-behaviour
  {:get-size! read-record-size
   :get-data! read-record-data
   :next! read-next})

(extend java.io.InputStream IRecordIOStream recordio-behaviour)
