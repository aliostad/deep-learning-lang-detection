(ns futura.stream-tests
  (:require [clojure.core.async :refer [put! take! chan <! >! <!! close!] :as async]
            [clojure.test :refer :all]
            [clojure.java.io :as io]
            [clojure.pprint :refer [pprint]]
            [manifold.stream :as ms]
            [futura.stream :as stream]
            [futura.promise :as p])
  (:import org.reactivestreams.Publisher
           org.reactivestreams.Subscriber
           org.reactivestreams.Subscription))

(deftest publisher-composition
  (testing "Using simple map transducer."
    (let [p (->> (stream/publisher [1 2 3 4 5 6])
                 (stream/transform (map inc)))]
      (is (= [2 3 4 5 6 7] (into [] p)))))

  (testing "Using take + map transducer"
    (let [p (->> (stream/publisher [1 2 3 4])
                 (stream/transform (take 2))
                 (stream/transform (map inc)))]
      (is (= [2 3] (into [] p)))))

  (testing "Using take + map + partition-all transducer"
    (let [p (->> (stream/publisher [1 2 3 4 5 6])
                 (stream/transform (take 5))
                 (stream/transform (map inc))
                 (stream/transform (partition-all 2)))]
    (is (= [[2 3] [4 5] [6]] (into [] p)))))
)

(deftest publisher-constructors
  (testing "Publisher sourced with promise"
    (let [p (stream/publisher (p/promise 1))]
      (is (= [1] (into [] p)))))

  (testing "Publisher sourced with vector"
    (let [p (stream/publisher [1 2 3])]
      (is (= [1 2 3] (into [] p)))))

  (testing "Publisher sourced with core.async channel"
    (let [source (async/chan)
          p (stream/publisher source)]
      (async/go-loop [n 10]
        (if (pos? n)
          (do
            (async/>! source (inc n))
            (recur (dec n)))
          (async/close! source)))
      (let [v (into [] p)]
        (is (= [11 10 9 8 7 6 5 4 3 2] v)))))
)

(deftest push-stream
  (let [p (stream/publisher 2)]
    (stream/put! p 1)
    (stream/put! p 2)
    (with-open [s (stream/subscribe p)]
      (is (= @(stream/take! s) 1))
      (is (= @(stream/take! s) 2)))))

(deftest manifold-stream
  (let [mst (ms/stream)
        p (stream/publisher mst)]
    (async/go
      (ms/put! mst 1)
      (ms/put! mst 2)
      (ms/close! mst))
    (let [v (into [] p)]
      (is (= [1 2] v)))))
