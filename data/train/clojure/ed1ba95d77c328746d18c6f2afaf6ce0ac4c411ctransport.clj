(ns connect-four.server.transport
  (:require [cognitect.transit :as transit])
  (:import [java.io InputStream StringBufferInputStream ByteArrayOutputStream]))

(defn serialize [data]
  (let [out (ByteArrayOutputStream. 4096)
        writer (transit/writer out :json)]
    (transit/write writer data)
    (.toString out)))


(defn get-input-stream [data]
  (cond
    (instance? String data) (StringBufferInputStream. data)
    (instance? InputStream data) data))

(defn deserialize [data]
  (let [in (get-input-stream data)
        reader (transit/reader in :json)]
    (transit/read reader)))