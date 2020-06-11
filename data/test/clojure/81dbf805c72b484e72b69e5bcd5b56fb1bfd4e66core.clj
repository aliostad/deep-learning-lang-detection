(ns csk.core
    (:require [csk.serializer :as csr]
              [clojure.java.io :as jio])
    (:import
      (com.esotericsoftware.kryo Kryo Serializer)
      (com.esotericsoftware.kryo.io Output Input)
      ))

(defn register-serializers
  "Register a seq of Class to Kryo Serializer with a Kryo registry."
  [^Kryo kryo serializers]
  (doseq [[^Class klass ^Serializer serializer] (partition 2 serializers)]
         (.register kryo klass serializer))
  kryo)

(defn kryo
  ([]
   (kryo (Kryo.)))
  ([^Kryo k]
   (register-serializers k csr/csk-default-serializers)))

(defn write-to
  ([output-stream-able data]
   (write-to (kryo) output-stream-able data))
  ([^Kryo k output-stream-able data]
   (let [os (jio/output-stream output-stream-able)
         op (Output. os)
         ]
     (with-open [o op]
       (.writeClassAndObject k o data)))))

(defn read-from
  ([input-stream-able]
   (read-from (kryo) input-stream-able))
  ([^Kryo k input-stream-able]
   (let [is (jio/input-stream input-stream-able)
         ip (Input. is)
         ]
     (with-open [i ip]
       (.readClassAndObject k i)))))
