(ns slouch.serialization
  (:require [clojure.java.io :as io]
            [taoensso.nippy :as nippy])
  (:import [java.io ByteArrayOutputStream ByteArrayInputStream]))

(nippy/extend-freeze
  Throwable 128
  [^Throwable throwable data-output-stream]
  (nippy/freeze-to-stream!
    data-output-stream
    [(.getMessage throwable)
     (.getCause throwable)
     (vec (.getStackTrace throwable))]))

(nippy/extend-thaw
  128
  [data-input-stream]
  (let [[message cause stacktrace-vec]
        (nippy/thaw-from-stream! data-input-stream)]
    (doto (Throwable. message cause)
      (.setStackTrace ,,, (into-array stacktrace-vec)))))

(nippy/extend-freeze
  StackTraceElement 127
  [^StackTraceElement element data-output-stream]
  (nippy/freeze-to-stream!
    data-output-stream
    [(.getClassName element)
     (.getMethodName element)
     (.getFileName element)
     (.getLineNumber element)]))

(nippy/extend-thaw
  127
  [data-input-stream]
  (let [[class-name method-name file-name line-number]
        (nippy/thaw-from-stream! data-input-stream)]
    (StackTraceElement. class-name method-name file-name line-number)))

(defn bytearray->stream [bytearray]
  (ByteArrayInputStream. bytearray))

(defmulti stream->bytearray type)
(defmethod stream->bytearray ByteArrayOutputStream [stream]
  (.toByteArray stream))
(defmethod stream->bytearray :default [stream]
  (let [out (ByteArrayOutputStream.)]
    (io/copy stream out)
    (stream->bytearray out)))

(defn serialize [data]
  (-> data
      nippy/freeze
      bytearray->stream))

(defn deserialize [bytes]
  (-> bytes
      stream->bytearray
      nippy/thaw))
