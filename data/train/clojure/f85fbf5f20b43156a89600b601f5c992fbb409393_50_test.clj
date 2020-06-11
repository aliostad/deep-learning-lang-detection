;; Exercise 3.50

(ns sicp-mailonline.exercises.3-50-test
  (:require [sicp-mailonline.exercises.3-50 :refer [stream-map]]
            [sicp-mailonline.examples.3-5-1 :as strm]
            [clojure.test :refer :all]))

(deftest exercise3-50
  (testing "no streams"
    (is (empty? (stream-map +))))

  (testing "single stream"
    (is (= -1
           (strm/stream-car
             (stream-map - (strm/stream-enumerate-interval 1 5)))))
    (is (= -5
           (strm/stream-ref
             (stream-map - (strm/stream-enumerate-interval 1 5))
             4))))

  (testing "multiple streams"
    (is (= 110
           (strm/stream-car 
             (stream-map +
                         (strm/stream-enumerate-interval 10 15)
                         (strm/stream-enumerate-interval 100 105)))))
    (is (= 120
           (strm/stream-ref
            (stream-map +
                        (strm/stream-enumerate-interval 10 15)
                        (strm/stream-enumerate-interval 100 105))
            5)))))
