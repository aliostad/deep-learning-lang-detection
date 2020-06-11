(ns
  kafka.serializable
  (:use kafka.types)
  (:import (kafka.types Message)
           (java.nio Buffer ByteBuffer)
           (java.io Serializable 
                    ObjectOutputStream ByteArrayOutputStream
                    ObjectInputStream ByteArrayInputStream)
           ))

(extend-type Serializable
  Pack
    (pack [this]
      (let [bas (ByteArrayOutputStream.)]
        (with-open [oos (ObjectOutputStream. bas)]
          (.writeObject oos this))
        (Message. (.toByteArray bas)))))

(extend-type String
  Pack
    (pack 
      [this]
      (Message. (.getBytes this "UTF-8")))
    )

(extend-type ByteBuffer
  Pack
    (pack 
      [this]
      (Message. (.array this)))
    )

(extend-type Message
  Unpack
    (unpack [this]
      (with-open [ois (ObjectInputStream. (ByteArrayInputStream. (.bytes this)))]
        (.readObject ois))))

