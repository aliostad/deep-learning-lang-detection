(ns pit-plugin-test
  (:require [cljs.test :refer-macros [deftest is testing run-tests]]
            [clojure.pprint :refer [pprint]]
            [pit-plugin.actions :refer [actions-list remove-action remove-action!] :refer-macros [defaction defaction! dispatch!]]))

;; Simple action
(defaction inc-or-assoc
  "Action for test 1"
  ([m]
   (update m :test #(if % (inc %) 1)))
  ([m value]
   (assoc m :test value)))
(deftest simple-call-test
  (testing "Call without params"
    (let [state (atom {})]
      (dispatch! state
                 :inc-or-assoc
                 :inc-or-assoc)
      (is (= {:test 2}
             @state))))
  (testing "Call with a param"
    (let [state (atom {})]
      (dispatch! state [:inc-or-assoc 42])
      (is (= {:test 42}
             @state)))))

;; Remove action
(deftest actions-list-test
  (testing "Empty before adding"
    (is (= (:fake-action @actions-list) nil))
    (defaction fake-action [m] m))
  (testing "Contains information after defaction"
    (is (not= (:fake-action @actions-list) nil)))
  (remove-action :fake-action)
  (testing "Empty after remove-action"
    (is (= (:fake-action @actions-list) nil))))

;; Reaction
(defaction! add-info
  ([state]
   (reaction state "test-info"))
  ([state info]
   (swap! state assoc :info info)))
(deftest xxx
  (let [state (atom {})]
    (testing "Defaction!"
      (dispatch! state [! :add-info])
      (is (= {:info "test-info"} @state)))
    (testing "Reaction"
      (dispatch! state [! :add-info "My info"])
      (is (= {:info "My info"} @state)))))

;; Dispatch! on a map
(deftest dispatch!-map
  (testing "Simple action on a map"
    (let [m (dispatch! {}
                       :inc-or-assoc)]
      (is (= {:test 1} m))))
  (testing "Composite action on a map"
    (let [m (dispatch! {}
                       [:inc-or-assoc 41]
                       :inc-or-assoc)]
      (is (= {:test 42} m)))))

;; Dispatch! a "nil" action
(deftest dispatch!-nil
  (testing "Nil action on a map"
    (let [m (dispatch! {}
                       :inc-or-assoc
                       (when false :inc-or-assoc)
                       (when false [:inc-or-assoc])
                       :inc-or-assoc)]
      (is (= {:test 2} m))))
  (testing "Nil action on an atom"
    (let [state (atom {})]
      (dispatch! state
                 :inc-or-assoc
                 (when false :inc-or-assoc)
                 (when false [:inc-or-assoc])
                 :inc-or-assoc)
      (is (= {:test 2}
             @state)))))
