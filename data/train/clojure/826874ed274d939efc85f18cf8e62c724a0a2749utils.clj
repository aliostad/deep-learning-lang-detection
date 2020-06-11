(ns football.utils
  (:import (java.io ObjectOutputStream ObjectInputStream
             ByteArrayOutputStream ByteArrayInputStream)))

(defn serialize
  "Serializes a single object, returning a byte array."
  [v]
  (with-open [bout (ByteArrayOutputStream.)
              oos (ObjectOutputStream. bout)]
    (.writeObject oos v)
    (.flush oos)
    (.toByteArray bout)))

(defn deserialize
  "Deserializes and returns a single object from the given byte array."
  [bytes]
  (with-open [ois (-> bytes ByteArrayInputStream. ObjectInputStream.)]
    (.readObject ois)))
