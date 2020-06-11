(ns riemann-manifold.core-test
  (:require [clojure.test :refer :all]
            [manifold.stream :as s]
            [riemann.client :as r]
            [riemann-manifold.core :refer :all]))


(def c (r/tcp-client {:host "localhost"}))

(deftest stream-state-test
  (testing "a new stream"
    (is (= "open" (stream-state (s/stream)))))

  (testing "a drained stream"
    (let [s' (s/stream)]
      (s/close! s')
      (is (= "drained" (stream-state s')))))

  (testing "a closed stream"
    (let [s' (s/stream)]
      (s/put! s' :x)
      (s/close! s')
      (is (= "closed" (stream-state s')))))

  (testing "a source"
    (let [s' (s/source-only (s/stream))]
      (is (= "open" (stream-state s')))))

  )

(deftest stream-metrics-test
  (is (= (stream-metrics (s/stream))
         {:pending-takes 0
          :pending-puts 0
          :buffer-size 0
          :buffer-capacity 0})))


(defn query-service [service]
  @(r/query c (str "service = \""
                   service
                   "\"")))

(deftest consume-metrics-test
  (let [src (s/stream)]
    (consume-metrics c src)
    @(s/put! src {:service "consumer-test"
                  :ttl 10})
    (is (pos? (count (query-service "consumer-test"))))))


(deftest instrument-test
  (let [src (s/stream)]
    (s/put! src :x)

    (testing "a stream metric"
      (instrument src c "instrument-test" 1)
      (is (= 1 (:metric
                (first
                 (query-service "instrument-test pending-puts"))))))))

(deftest tap-test
  (let [a (s/stream)
        a' (tap a c "tap-test" #(hash-map :metric (inc %)) 1)]

    (s/put! a 10)

    (testing "the tapped stream has the same result"
        (is (= 10 @(s/take! a'))))

    (testing "the metric has the result of applying the fn"
        (is (= 11 (:metric
                   (first
                    (query-service "tap-test"))))))))
