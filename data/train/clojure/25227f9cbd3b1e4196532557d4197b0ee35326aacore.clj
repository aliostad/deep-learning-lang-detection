(ns clj-serializer.core
  (:import (clj_serializer Serializer)
           (java.io DataOutputStream ByteArrayOutputStream
                    DataInputStream  ByteArrayInputStream)))

(defn serialize [obj]
  (let [baos (ByteArrayOutputStream.)
        dos  (DataOutputStream. baos)]
    (Serializer/serialize dos obj)
    (.toByteArray baos)))

(defn deserialize [bytes eof-val]
  (let [bais  (ByteArrayInputStream. bytes)
        dis   (DataInputStream. bais)]
    (Serializer/deserialize dis eof-val)))

(defn dos-serialize [#^DataOutputStream dos obj]
  (let [#^"[B" bytes (serialize obj)]
    (.write dos bytes)
    (.flush dos)))

(defn dis-deserialize [dis eof-val]
  (Serializer/deserialize dis eof-val))

(defn dis-deserialized-seq [dis]
  (let [eof-val (Object.)]
    (lazy-seq
      (let [elem (dis-deserialize dis eof-val)]
        (if-not (identical? elem eof-val)
          (cons elem (dis-deserialized-seq dis)))))))
