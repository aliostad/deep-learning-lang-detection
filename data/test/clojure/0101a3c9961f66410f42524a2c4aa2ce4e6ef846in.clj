(ns kwt.in
  (:require [clojure.data.codec.base64 :as b64]
           [clojure.java.io :as io])
  (:import (java.util.zip InflaterInputStream)
           (java.io ByteArrayInputStream ByteArrayOutputStream InputStream)
           javax.websocket.Session
           us.b3k.kafka.ws.transforms.Transform)
  (:gen-class
   :extends us.b3k.kafka.ws.transforms.Transform
   :name kwt.in.Transform))

(defn unbase64 [m]
  (b64/decode m))

(defn remove-first-byte [m]
  (when (= (first m) 0)
    (rest m)))

(defn to-byte-array
  "Returns a byte array for the InputStream provided."
  [is]
  (let [chunk-size 8192
        baos (ByteArrayOutputStream.)
        buffer (byte-array chunk-size)]
    (loop [len (.read ^InputStream is buffer 0 chunk-size)]
      (when (not= -1 len)
        (.write baos buffer 0 len)
        (recur (.read ^InputStream is buffer 0 chunk-size))))
    (.toByteArray baos)))

(defn zlib-inflate [m]
  (InflaterInputStream. (ByteArrayInputStream. (byte-array m))))

(defn ->json [msg]
  (-> msg
      unbase64
      byte-array
      remove-first-byte
      zlib-inflate))

(proxy [Transform]
      (transform [^TextMessage msg ^Session session]
                 (->json msg)))

