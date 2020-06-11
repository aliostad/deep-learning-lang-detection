(ns midiboot.midi
  (:require [clojure.string :as string]
            [clojure.core.match :refer [match]]))

(def unknown-message [:unknown])

(defn status-byte? [byte]
  (>= byte 0x80))

(defn status-without-channel [byte]
  (assert (status-byte? byte))
  (bit-and 0xf0 byte))

(defn message-from-bytes [bytes]
  (if (not (= 3 (count bytes)))
    unknown-message
    (match (into [] (concat [(status-without-channel (first bytes))] (rest bytes)))
      [0x80 pitch velo] [:note-off pitch velo]
      [0x90 pitch velo] [(if (= 0 velo) :note-off :note-on) pitch velo]
      :else unknown-message)))

(defn- skip-bytes-until [predicate stream lead-byte]
  (loop [byte lead-byte]
    (let [byte (or byte (.read stream))]
      (if (or (not byte) (predicate byte))
        byte
        (recur nil)))))

(defn- read-bytes-while [predicate stream]
  (loop [bytes []]
    (let [byte (.read stream)]
      (if (not (and byte (predicate byte)))
        [bytes byte]
        (recur (conj bytes byte))))))

(defn- messages-from-stream* [stream byte]
  (let [status-byte (skip-bytes-until status-byte? stream byte)]
    (if status-byte
      (let [[data-bytes next-byte]
            (read-bytes-while (complement status-byte?) stream)
            all-message-bytes (into [] (concat [status-byte] data-bytes))]
        (lazy-seq (cons (message-from-bytes all-message-bytes)
                    (if next-byte
                      (messages-from-stream* stream next-byte)
                      nil)))))))

(defn messages-from-stream [stream]
  (messages-from-stream* stream nil))
