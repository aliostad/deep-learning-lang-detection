(ns spectodo.counter-test
  (:require [cljs.test :refer-macros [deftest is testing use-fixtures]]
            [scrum.core :as scrum]
            [spectodo.counter.control :as counter]))

(def state (atom {}))

(def r
  (scrum/reconciler
   {:state state
    :controllers
    {:counter counter/control}}))

(defn setup []
  (scrum/dispatch-sync! r :counter :init))

(deftest counter-state
  (testing "Should initialize state value with 0"
    (scrum/dispatch-sync! r :counter :init)
    (is (zero? (:counter @state))))
  (testing "Should increment state value"
    (scrum/dispatch-sync! r :counter :inc)
    (is (= (:counter @state) 1)))
  (testing "Should decrement state value"
    (scrum/dispatch-sync! r :counter :dec)
    (is (= (:counter @state) 0)))
  (testing "Should increment state value by 10"
    (scrum/dispatch-sync! r :counter :inc-by 10)
    (is (= (:counter @state) 10)))
  (testing "Should decrement state value by 10"
    (scrum/dispatch-sync! r :counter :dec-by 10)
    (is (= (:counter @state) 0))))
