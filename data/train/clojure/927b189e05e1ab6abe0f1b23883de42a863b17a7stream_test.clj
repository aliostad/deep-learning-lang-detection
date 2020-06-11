(ns kilgore.stream-test
  (:require [clojure.test :refer [deftest is testing]]
            [kilgore.store :as store]
            [kilgore.stream :as stream]))

(deftest event-reducer
  (let [store-atom (atom nil)
        store (store/acquire {:store-atom store-atom})
        stream (stream/acquire store "test")
        current (stream/event-reducer (fnil conj []))]
    (is (= (map :test (current stream)) []))
    (stream/record-event! stream {:test 1})
    (is (= (map :test (current stream)) [1]))
    (stream/record-event! stream {:test 2})
    (stream/record-event! stream {:test 3})
    (is (= (map :test (current stream)) [1 2 3]))))
