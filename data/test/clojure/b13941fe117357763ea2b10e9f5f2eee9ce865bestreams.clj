(ns shell.streams
  (:refer-clojure :exclude [print])
  (:require [clojure.core.async :as async]
            [clojure.java.io :as io]
            [clojure.core.async :as async]
            [clojure.java.io :as io])
  (:import java.io.InputStream))

(defprotocol Pipeable
  (pipe [this out-stream]
    "Pipe this to the supplied out-stream. This may or may not close
    the out-stream depending on implementation."))

(extend-type InputStream
  Pipeable
  (pipe [this out-stream]
    (io/copy this out-stream)
    (.close out-stream)))

(extend-type String
  Pipeable
  (pipe [this out-stream]
    ;; TODO: encoding
    (io/copy (.getBytes this) out-stream)
    (.close out-stream)))

(extend-type nil
  Pipeable
  (pipe [_ out-stream]
    ;; TODO: should this close? how would you type and C-d?
    (.close out-stream)))

(defn null-input-stream []
  (java.io.ByteArrayInputStream. (make-array Byte/TYPE 0)))

(defn string-input-stream [string]
  (java.io.ByteArrayInputStream. (.getBytes string)))

;; TODO: encoding
(defn stream->lines
  "Returns a lazy seq of lines produced by consuming from the given
  string. This does not close the given stream."
  [stream]
  (if-not stream
    []
    (let [reader (java.io.BufferedReader.
                  (java.io.InputStreamReader. stream))]
      ((fn this []
         (lazy-seq
          (when-let [line (.readLine reader)]
            (cons line (this)))))))))

(defn close! [& streams]
  (doseq [stream streams]
    (when stream (.close stream))))

(defn join [stream-a stream-b]
  (letfn [(pump [line stream]
            (async/thread (io/copy line stream)))]
    (cond (nil? stream-a) stream-b
          (nil? stream-b) stream-a
          :else
          (let [ch-a (async/chan)
                ch-b (async/chan)
                merged (async/merge [ch-a ch-b])
                out-stream (java.io.PipedOutputStream.)
                in-stream (java.io.PipedInputStream. out-stream)]
            (async/onto-chan ch-a (stream->lines stream-a))
            (async/onto-chan ch-b (stream->lines stream-b))
            (async/go-loop [line (async/<! merged)]
              (async/<! (pump line out-stream))
              (if-let [next-line (async/<! merged)]
                (recur next-line)
                (close! stream-a stream-b out-stream)))
            ;; TODO: closing this should close stream-a and stream-b
            in-stream))))

(defn print
  ([stream] (print stream *out*))
  ([stream out] (io/copy stream out)))
