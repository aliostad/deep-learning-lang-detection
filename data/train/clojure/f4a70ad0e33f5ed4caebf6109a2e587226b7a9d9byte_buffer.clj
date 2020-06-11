(ns me.moocar.byte-buffer
  (:require [clojure.java.io :as jio])
  (:import (java.io InputStream OutputStream)
           (java.nio ByteBuffer)))

(defn byte-buffer-input-stream
  "Creates an InputStream that reads bytes from a ByteBuffer"
  [buf opts]
  (proxy [InputStream] []
    (read
      ([]
       (if-not (.hasRemaining buf)
         -1
         (bit-and (.get buf) 0xFF)))
      ([bytes off len]
       (if-not (.hasRemaining buf)
         -1
         (let [len (Math/min len (.remaining buf))]
           (.get buf bytes off len)
           len))))))

(defn byte-buffer-output-stream
  "Creates an OutputStream that writes bytes to a ByteBuffer"
  [buf opts]
  (proxy [OutputStream] []
    (write
      ([b]
       (.put buf (byte b)))
      ([bytes off len]
       (.put buf bytes off len)))))

(extend ByteBuffer
  jio/IOFactory
  (assoc jio/default-streams-impl
         :make-input-stream byte-buffer-input-stream
         :make-output-stream byte-buffer-output-stream))
