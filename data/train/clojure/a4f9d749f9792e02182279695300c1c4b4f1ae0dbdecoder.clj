(ns yobc.bdecoder
  (:require [clojure.java.io :as io]))

(defn get-next-char
  "Given a stream returns the next character to be read"
  [stream]
  (let [value (.read stream)]
    (if (not= (int value) -1) (char value) nil)))

(declare decode-stream)

(defn decode-integer
  "Decodes a bencoded integer"
  [stream ch delimiter]
  (loop [marker (or ch (get-next-char stream))
         result ""]
    (if (= marker delimiter)
      (Integer/parseInt (str result))
      (recur (get-next-char stream) (str result marker)))))

(defn decode-string
  "Decodes a bencoded string"
  [stream ch]
  (let [len (decode-integer stream ch \:)
        buffer (byte-array len)]
    (.read stream buffer)
    (String. buffer "ISO-8859-1")))

(defn decode-list
  "Decodes a bencoded list"
  [stream]
  (loop [result []]
    (let [marker (get-next-char stream)
          append (decode-stream stream marker)]
      (if (or (nil? marker) ( = marker \e))
        result
        (recur (conj result append))))))

(defn decode-dict
  "Decodes a bencoded list"
  [stream]
  (do
    (apply sorted-map (decode-list stream))))

(defn decode-stream
  "Decode markers in a bencoded stream"
  [stream ch]
  (let [marker (or ch (get-next-char stream))]
    (cond
      (nil? marker) nil
      (Character/isDigit marker) (decode-string stream marker)
      (= marker \i ) (decode-integer stream nil \e)
      (= marker \l) (decode-list stream)
      (= marker \d) (decode-dict stream))))

(defn bdecode
  "Read torrent file as a stream and decode it"
  [filename]
  (with-open [rdr (io/input-stream (io/file filename))]
    (do (get-next-char rdr) (decode-dict rdr))))
