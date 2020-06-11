(ns ring-core-cn.util.io-test
  (:require [clojure.test :refer :all]
            [clojure.java.io :as io]
            [ring-core-cn.util.io :refer :all])
  (:import [java.io IOException]))

(deftest test-piped-input-stream
  (let [stream (piped-input-stream #(spit % "Hello World"))]
    (is (= (slurp stream) "Hello World"))))

(deftest test-string-input-stream
  (let [stream (string-input-stream "Hello World")]
    (is (= (slurp stream) "Hello World"))))

(deftest test-close!
  (testing "non-streams"
    (is (nil? (close! "foo"))))
  (testing "streams"
    (let [stream (piped-input-stream #(spit % "Hello World"))]
      (close! stream)
      ;; 测试指定错误抛出
      (is (thrown? IOException (slurp stream)))
      ;; 测试流被关闭
      (is (nil? (close! stream))))))
