(ns clj-suomi.utils.zip-test
  (:require [clojure.test :refer :all]
            [clj-suomi.utils.zip :refer :all]
            [clojure.java.io :as io]))

(defn test-stream
  ([] (test-stream "test.zip"))
  ([name] (decode-stream (io/input-stream (io/resource name)))))

(deftest find-entry-test
  (is (thrown-with-msg? IllegalStateException #"Entry not found"
                        (find-entry (decode-stream (io/input-stream (io/resource "test.zip"))) (constantly false))))
  (is (find-entry (test-stream) #(= "a" (:name %)))))

(deftest get-entry-test
  (is (get-entry (test-stream) "a"))
  (is (= "abcde\n" (slurp (get-entry (test-stream) "a")))))

(deftest first-entry-test
  (is (= "abcde\n" (slurp (first-entry (test-stream)))))
  (is (thrown-with-msg? IllegalStateException #"Entry not found"
                        (first-entry (test-stream "empty.zip")))))
