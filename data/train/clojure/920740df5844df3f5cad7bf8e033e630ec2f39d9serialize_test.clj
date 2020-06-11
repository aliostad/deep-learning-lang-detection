(ns analyze-data.serialize-test
  (:require [clojure.test :refer [deftest is]]
            [clojure.string :as string]
            [analyze-data.serialize :as test-ns])
  (:import (java.io ByteArrayOutputStream ByteArrayInputStream)))

(deftest write-object!-test
  (let [out (ByteArrayOutputStream.)]
    (test-ns/write-object! out "hello")
    (is (not (string/blank? (.toString out)))
        "serializes object to stream")))

(deftest read-object-test
  (let [out (ByteArrayOutputStream.)]
    (test-ns/write-object! out "hello")
    (let [in (ByteArrayInputStream. (.toByteArray out))]
      (is (= "hello" (test-ns/read-object in))
          "reads serialized object from stream"))))
