(ns mc.serial
  (:import [java.io Serializable ObjectOutputStream ObjectInputStream InputStream 
            ByteArrayOutputStream ByteArrayInputStream]))

(def BYTE-ARRAY-CLASS (.getClass (byte-array 0)))

(defn serialize 
  ([^Serializable object]
    (let [bos (ByteArrayOutputStream.)]
      (serialize object (ObjectOutputStream. bos))
      (.toByteArray bos)))
  ([^Serializable object ^ObjectOutputStream object-output-stream]
    (.writeObject object-output-stream object)))

(defn deserialize 
  ([source]
    (cond
      (= BYTE-ARRAY-CLASS (type source)) 
        (.readObject (ObjectInputStream. (ByteArrayInputStream. source)))
      (instance? ObjectInputStream source ) 
        (.readObject ^ObjectInputStream source)
      (instance? InputStream source) 
        (deserialize (ObjectInputStream. source))
      :else 
        (throw (Error. (str "Can't deserialise object of type " (type source)))))))