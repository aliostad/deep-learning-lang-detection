(ns td-bot.metrics-test
  (:require [td-bot.metrics :as metrics]
            [clojure.test :refer :all]))

(defn test-fixture [test-runner]
  (let [captured-instrument? (deref metrics/instrument?)
        captured-metrics (deref metrics/metrics)]
    (reset! metrics/instrument? true)
    (reset! metrics/metrics {})
    (test-runner)
    (reset! metrics/instrument? captured-instrument?)
    (reset! metrics/metrics captured-metrics)))

(use-fixtures :once test-fixture)

(deftest timed-operations
  (let [result1 (metrics/timed :test-op (do (Thread/sleep 100) (inc 42)))
        result2 (metrics/timed :test-op (do (Thread/sleep 20) :foo))]
    (testing "We evaluate the body of a timed operation and return the result"
      (is (= '(43 :foo) (list result1 result2))))
    (testing "And we also append timing information to the metrics, front-to-back"
      (is (= 2 (count (:test-op (:timers (deref metrics/metrics))))))
      (is (<= 100 (second (:test-op (:timers (deref metrics/metrics))))))
      (is (<= 20 (first (:test-op (:timers (deref metrics/metrics)))))))))
