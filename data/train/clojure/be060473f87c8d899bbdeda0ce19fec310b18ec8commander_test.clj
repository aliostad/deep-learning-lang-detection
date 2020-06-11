(ns mars-rover.commander-test
  (:require [clojure.test :refer :all]
            [mars-rover.commander :refer :all]))

(def rover-init [2 5])

(deftest moving-forward-when-n
  (testing "should increment y"
    (is (= [2 6 :n] (dispatch-rover (conj rover-init :n ) "f")))))

(deftest moving-forward-when-s
  (testing "should decrement y"
    (is (= [2 4 :s] (dispatch-rover (conj rover-init :s) "f")))))

(deftest moving-forward-when-w
  (testing "should increment x"
    (is (= [3 5 :w] (dispatch-rover (conj rover-init :w) "f")))))

(deftest moving-forward-when-e
  (testing "should decrement x"
    (is (= [1 5 :e] (dispatch-rover (conj rover-init :e) "f")))))

(deftest reading-two-forward-commands
  (testing "should read two fs at a time"
    (is (= [2 7 :n] (dispatch-rover [2 5 :n] "ff")))))

(deftest reading-backwards-commands
  (testing "should read two bs at a time"
    (is (= [2 3 :n] (dispatch-rover [2 5 :n] "bb")))))

(deftest reading-left-commands
  (testing "should turn left"
    (is (= [2 5 :w] (dispatch-rover [2 5 :n] "l")))))

(deftest reading-right-commands
  (testing "should turn left"
    (is (= [2 5 :e] (dispatch-rover [2 5 :n] "r")))))
