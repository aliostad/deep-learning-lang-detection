(ns riemann-cond-dt.core-test
  (:require [riemann-cond-dt.core :refer :all]
            [riemann.time :refer :all]
            [riemann.time.controlled :refer :all]
            [riemann.test :refer [test-stream]]
            [clojure.test :refer :all]))

(deftest above-test
  (testing "do nothing"
    (test-stream (above 10 5) [] [])

    (test-stream (above 10 5) [{:time 0
                                :metric 9}
                               {:time 5
                                :metric 11}
                               {:time 6
                                :metric 11}] [])

    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 5
                                :metric 9}
                               {:time 11
                                :metric 12}] [])

    (test-stream (above 10 5) [{:time 0
                                :metric 9}
                               {:metric 11}
                               {:time 6
                                :metric 11}] [])

    (test-stream (above 10 5) [{:time 0
                                :metric 12}
                               {:time 5
                                :metric 12}
                               {:time 4
                                :metric 9}
                               {:time 8
                                :metric 11}] [])

    (test-stream (above 10 5) [{:time 0
                                :metric 12}
                               {:metric 12}
                               {:time 5
                                :metric 11}
                               {:time 4 ;; too old
                                :metric 12}
                               {:time 6
                                :metric 9}
                               {:time 16
                                :metric 12}
                               {:time 10
                                :metric 11}] []))

  (testing "fire alert"
    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 6
                                :metric 11}] [{:time 6
                                               :metric 11}])
    (test-stream (above 10 5) [{:time 0
                                :metric 2}
                               {:time 6
                                :metric 11}
                               {:time 12
                                :metric 11}] [{:time 12
                                               :metric 11}])
    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 7
                                :metric 4}
                               {:time 9
                                :metric 11}
                               {:time 15
                                :metric 12}] [{:time 15
                                               :metric 12}])
    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 7
                                :metric 4}
                               {:time 9 ;; event ok
                                :metric 11}
                               {:time 15 ;; fire event
                                :metric 12}
                               {:time 20 ;; fire event
                                :metric 12}
                               {:time 20 ;; fire event
                                :metric 12}
                               {:time 8 ;; too old
                                :metric 9}
                               {:time 10 ;; old but reset current-time to 10
                                :metric 9}
                               {:time 11 ;; event ok
                                :metric 12}
                               {:time 17 ;; fire event
                                :metric 12}] [{:time 15
                                               :metric 12}
                                              {:time 20
                                               :metric 12}
                                              {:time 20
                                               :metric 12}
                                              {:time 17
                                               :metric 12}])
    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 7
                                :metric 4}
                               ;; ignore old ok event
                               {:time 1
                                :metric 12}
                               ;; ignore old ok event
                               {:time 6
                                :metric 12}
                               {:time 9
                                :metric 11}
                               {:time 15
                                :metric 12}] [{:time 15
                                               :metric 12}])
    (test-stream (above 10 5) [{:time 0
                                :metric 11}
                               {:time 7
                                :metric 4}
                               ;; ignored
                               {:time 6
                                :metric 8}
                               {:time 7.1
                                :metric 11}
                               {:time 15
                                :metric 12}] [{:time 15
                                               :metric 12}])))

(deftest below-test
  (testing "do nothing"
    (test-stream (below 10 5) [] [])

    (test-stream (below 10 5) [{:time 0
                                :metric 11}
                               {:time 5
                                :metric 9}
                               {:time 6
                                :metric 9}] [])

    (test-stream (below 10 5) [{:time 0
                                :metric 9}
                               {:time 5
                                :metric 11}
                               {:time 11
                                :metric 7}] [])

    (test-stream (below 10 5) [{:time 0
                                :metric 11}
                               {:metric 9}
                               {:time 6
                                :metric 9}] []))
  (testing "fire alert"
    (test-stream (below 10 5) [{:time 0
                                :metric 9}
                               {:time 6
                                :metric 9}] [{:time 6
                                              :metric 9}])
    (test-stream (below 10 5) [{:time 0
                                :metric 9}
                               {:time 7
                                :metric 15}
                               {:time 9
                                :metric 9}
                               {:time 15
                                :metric 7}] [{:time 15
                                              :metric 7}])))

(deftest between-test
  (testing "do nothing"
    (test-stream (between 10 20 5) [] [])

    (test-stream (between 10 20 5) [{:time 0
                                     :metric 9}
                                    {:time 5
                                     :metric 11}
                                    {:time 6
                                     :metric 11}] [])

    (test-stream (between 10 20 5) [{:time 0
                                     :metric 11}
                                    {:time 1
                                     :metric 11}
                                    {:time 5
                                     :metric 21}
                                    {:time 11
                                     :metric 12}] [])

    (test-stream (between 10 20 5) [{:time 0
                                     :metric 9}
                                    {:metric 15}
                                    {:time 6
                                     :metric 15}] []))
  (testing "fire alert"
    (test-stream (between 10 20 5) [{:time 0
                                     :metric 15}
                                    {:time 6
                                     :metric 19}] [{:time 6
                                                    :metric 19}])
    (test-stream (between 10 20 5) [{:time 0
                                     :metric 11}
                                    {:time 7
                                     :metric 30}
                                    {:time 9
                                     :metric 15}
                                    {:time 15
                                     :metric 12}] [{:time 15
                                                    :metric 12}])))

(deftest outside-test
  (testing "do nothing"
    (test-stream (outside 10 20 5) [] [])

    (test-stream (outside 10 20 5) [{:time 0
                                     :metric 10}
                                    {:time 5
                                     :metric 20}
                                    {:time 6
                                     :metric 15}] [])

    (test-stream (outside 10 20 5) [{:time 0
                                     :metric 11}
                                    {:time 1
                                     :metric 11}
                                    {:time 5
                                     :metric 21}
                                    {:time 11
                                     :metric 12}] [])

    (test-stream (outside 10 20 5) [{:time 0
                                     :metric 9}
                                    {:metric 15}
                                    {:time 6
                                     :metric 15}] []))
  (testing "fire alert"
    (test-stream (outside 10 20 5) [{:time 0
                                     :metric 9}
                                    {:time 6
                                     :metric 21}] [{:time 6
                                                    :metric 21}])
    (test-stream (outside 10 20 5) [{:time 0
                                     :metric 9}
                                    {:time 7
                                     :metric 16}
                                    {:time 9
                                     :metric 1}
                                    {:time 15
                                     :metric 2}] [{:time 15
:metric 2}])))

(deftest critical-test
  (testing "do nothing"
    (test-stream (critical 5) [] [])

    (test-stream (critical 5) [{:time 0
                                :state "critical"}
                               {:time 5
                                :state "ok"}
                               {:time 6
                                :state "ok"}] [])

    (test-stream (critical 5) [{:time 0
                                :state "ok"}
                               {:time 1
                                :state "ok"}
                               {:time 5
                                :state "critical"}
                               {:time 11
                                :state "ok"}] [])

    (test-stream (critical 5) [{:time 0
                                :state "critical"}
                               {:state 15}
                               {:time 6
                                :state "ok"}] []))
  (testing "fire alert"
    (test-stream (critical 5) [{:time 0
                                :state "critical"}
                               {:time 6
                                :state "critical"}] [{:time 6
                                                      :state "critical"}])
    (test-stream (critical 5) [{:time 0
                                :state "critical"}
                               {:time 7
                                :state "ok"}
                               {:time 9
                                :state "critical"}
                               {:time 15
                                :state "critical"}] [{:time 15
                                                      :state "critical"}])))
