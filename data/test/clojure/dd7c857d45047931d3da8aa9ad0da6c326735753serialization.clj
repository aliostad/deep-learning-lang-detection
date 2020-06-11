(ns cronicmq.serialization
  (:import (java.io ByteArrayOutputStream ObjectOutputStream ObjectInputStream ByteArrayInputStream)))

(set! *warn-on-reflection* true)

(defn ^bytes serialize
  "Given a java.io.Serializable thing, serialize it to a byte array."
  [^java.io.Serializable data]
  (let [buff (ByteArrayOutputStream.)]
    (with-open [dos (ObjectOutputStream. buff)]
      (.writeObject dos data))
    (.toByteArray buff)))

(defn deserialize
  "Deserialize whatever is provided into a data structure"
  [^bytes bytes]
  (with-open [dis (ObjectInputStream. (ByteArrayInputStream. bytes))]
    (.readObject dis)))
