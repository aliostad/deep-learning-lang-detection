(ns analyze-data.serialize
  (:require [clojure.java.io :as io])
  (:import (java.io ObjectInputStream ObjectOutputStream)))

(defn write-object!
  "Write a java.io.Serializable object as output to f."
  [f object]
  (with-open [out (-> f
                      io/output-stream
                      ObjectOutputStream.)]
    (.writeObject out object)))

(defn read-object
  "Read a single object written with write-object from f."
  [f]
  (with-open [in (-> f
                     io/input-stream
                     ObjectInputStream.)]
    (.readObject in)))
