;; Exercise 3.64

(ns sicp-mailonline.exercises.3-64-test
  (:require [sicp-mailonline.examples.3-5-1 :as strm]
            [sicp-mailonline.exercises.3-64 :refer [within-tolerance? stream-limit]]
            [clojure.test :refer :all]))

(defn- average [a b]
  (/ (+ a b)
     2))

(defn- sqrt-improve [guess x]
  (average guess
           (/ x guess)))

(defn- sqrt-stream [x]
  ;; a horrible thing to do in Clojure as guesses will be a ref at namespace level
  (def ^:private guesses (strm/cons-stream 1.0
                                           (strm/stream-map (fn [guess] (sqrt-improve guess x))
                                                            guesses)))
  guesses)

(defn- approximately? [x y]
  (within-tolerance? x y 0.00001))

(deftest exercise3-64
  (testing "square roots"
    (is (= 1.5
           (stream-limit (sqrt-stream 2) 1)))
    
    (is (approximately? 1.4166666666
                        (stream-limit (sqrt-stream 2) 0.5)))

    (is (approximately? 1.4142156862
                        (stream-limit (sqrt-stream 2) 0.002)))

    (is (approximately? 1.4142135623
                        (stream-limit (sqrt-stream 2) 0.000002)))))
