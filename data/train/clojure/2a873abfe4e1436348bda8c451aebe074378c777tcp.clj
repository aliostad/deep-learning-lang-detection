(ns net-protocols.streams.tcp
  (:refer-clojure :exclude [read flush])
  (:use [net-protocols.streams.base])
  (:require [clojure.java.io :as io])
  (:import  (java.net Socket)))

;; TODO: replace busy loop with one that is friendlier
(defn- read-with-timeout
  "Reads a single byte from the reader.
   It returns false if in case of eof.
   Throws a timeout exception if no data was available within
   the given timeout
  "
  [rdr timeout]
  (let [end (+ (System/currentTimeMillis) timeout)]
    (loop []
      (if (.ready rdr)
        (let [next-char (.read rdr)]
          (and (not (neg? next-char)) next-char))
        (if (< (System/currentTimeMillis) end)
          (recur)
          (throw (Exception. "Timeout")))))))


(defrecord TcpStream [socket reader writer]
  Stream
  (read [stream timeout]
    (when-let [data (read-with-timeout (:reader stream) timeout)]
      (char data)))
  (write [stream data]
    (.write (:writer stream) data))
  (flush [stream]
    (.flush (:writer stream)))
  (connected? [stream]
    (.isConnected? (:socket stream)))
  (close [stream]
    (.close (:reader stream))
    (.close (:writer stream))
    (.close (:socket stream))))

(defn connect [host port]
  (let [sock (Socket. host port)
        writer (io/writer sock)
        reader (io/reader sock)]
    (TcpStream. sock reader writer)))
