(ns lemongrab.core-test
  (:require [clojure.java.io :as io]
            [clojure.test :refer :all]
            [lemongrab.core :refer :all]
            [midje.sweet :refer :all])
  (:import [com.esotericsoftware.kryo KryoException]
           [java.io ByteArrayOutputStream]))

(facts "roundtrip for"
  (fact "nil"
    (deserialize (serialize nil)) => nil)
  (fact "integer"
    (deserialize (serialize 42)) => 42)
  (fact "double"
    (deserialize (serialize 3.5)) => 3.5)
  (fact "string"
    (deserialize (serialize "foo")) => "foo")
  (fact "unqualified keyword"
    (deserialize (serialize :foo)) => :foo)
  (fact "qualified keyword"
    (deserialize (serialize ::foo)) => ::foo)
  (fact "map"
    (let [payload {:foo 42 "bar" 3.5 :baz [1 "two"]}]
      (deserialize (serialize payload)) => payload))
  (fact "vector"
    (let [payload ["foo" 42 3.5 {:foo 23}]]
      (deserialize (serialize payload)) => payload)))

(facts "stream output"
  (fact "one object"
    (let [s (ByteArrayOutputStream.)]
      (serialize s :foo)
      (seq (.toByteArray s)))
    => (seq (serialize :foo)))
  (fact "one object"
    (deserialize (let [s (ByteArrayOutputStream.)]
                   (serialize s :foo)
                   (.toByteArray s)))
    => :foo)
  (fact "two objects"
    (let [s (ByteArrayOutputStream.)]
      (serialize s :foo)
      (serialize s :bar)
      (seq (.toByteArray s)))
    => (concat (serialize :foo) (serialize :bar))))

(facts "stream input"
  (fact "one object"
    (let [b (serialize :foo)
          s (io/input-stream b)]
      (with-open [oi (open-stream s)]
        (read-object oi))) => :foo)
  (fact "two objects"
    (let [b (byte-array (concat (serialize :foo)
                                (serialize :bar)))
          s (io/input-stream b)]
      (with-open [oi (open-stream s)]
        [(read-object oi)
         (read-object oi)]))
    => [:foo :bar])
  (fact "one too many objects"
    (let [b (serialize :foo)
          s (io/input-stream b)]
      (with-open [oi (open-stream s)]
        [(read-object oi)
         (read-object oi)]))
    => (throws KryoException))
  (fact "closes the input stream"
    (let [b (serialize :foo)
          s (io/input-stream b)]
      (.close (open-stream s))
      (slurp s) => (throws java.io.IOException))))
