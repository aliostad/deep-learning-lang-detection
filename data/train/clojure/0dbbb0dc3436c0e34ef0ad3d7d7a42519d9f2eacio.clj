(ns ring.util.io
  "Utility functions for I/O in Ring."
  (:require [clojure.java.io :as io])
  (:import [java.io PipedInputStream
                    PipedOutputStream
                    ByteArrayInputStream
                    File
                    Closeable
                    IOException]))

(defn piped-input-stream
  "Create an input stream from a function that takes an output stream as its
  argument. The function will be executed in a separate thread. The stream
  will be automatically closed after the function finishes.

  e.g. (piped-input-stream
        (fn [ostream]
          (spit ostream \"Hello\")))"
  [func]
  (let [input  (PipedInputStream.)
        output (PipedOutputStream.)]
    (.connect input output)
    (future         ; future 包裹一段表达式并生成一个future对象 
      (try          ; 该对象将在另外一个线程中调用其中的代码
        (func output)
        (finally (.close output))))
    input))

(defn string-input-stream
  "Returns a ByteArrayInputStream for the given String."
  ([^String s]
     (ByteArrayInputStream. (.getBytes s)))
  ([^String s ^String encoding]
     (ByteArrayInputStream. (.getBytes s encoding))))

(defn close!
  "Ensure a stream is closed, swallowing any exceptions."
  [stream]
  (when (instance? java.io.Closeable stream)
    (try
      (.close ^java.io.Closeable stream)
      (catch IOException _ nil))))

(defn last-modified-date
  "Returns the last modified date for a file, rounded down to the nearest
  second."
  [^File file]
  (-> (.lastModified file)      ; 毫秒
      (/ 1000) (long) (* 1000)  ; 截断到秒
      (java.util.Date.)))
