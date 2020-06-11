(ns net.umask.imageresizer.memorystore
  (:require [clojure.java.io :as io]
            [net.umask.imageresizer.source :refer [ImageSource]])
  (:import (java.io ByteArrayOutputStream)))

(defn- tobytes [stream]
  (let [bos (ByteArrayOutputStream.)]
    (io/copy stream bos)
    (.toByteArray bos)))


(defn memorystore-write [this name stream]
  (swap! (:store this) assoc name (tobytes stream)))

(defrecord MemoryStore [store]
  ImageSource
  (get-image-stream [this name]
    (if-let [b (get @(:store this) name)]
      (io/input-stream b))))

(defn create-memstore []
  (->MemoryStore (atom {})))
