(ns slack-slurper.listener-test
  (:require [clojure.test :refer :all]
            [slack-slurper.listener :refer :all]
            [manifold.stream :as s]))

(deftest test-listen-invokes-callback-when-msg-received
  (let [stream (s/stream)
        result (atom nil)
        cb (fn [m] (reset! result "done"))]
    (listen stream cb (atom true))
    (s/put! stream "hi")
    (Thread/sleep 100)
    (s/close! stream)
    (is (= "done" @result))))


(deftest test-switched-off
  (testing "never invokes callback if switch starts as off"
    (let [stream (s/stream)
          result (atom nil)
          cb (fn [m] (reset! result "done"))]
      (listen stream cb (atom false))
      (s/put! stream "hi")
      (Thread/sleep 100)
      (s/close! stream)
      (is (= nil @result)))))

(deftest test-nothing-invoked-until-msg
  (let [stream (s/stream)
          result (atom nil)
          cb (fn [m] (reset! result "done"))]
      (listen stream cb (atom true))
      (is (= nil @result))
      (s/put! stream "hi")
      (Thread/sleep 100)
      (is (= "done" @result))
      (s/close! stream)))
