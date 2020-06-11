(ns clojurewerkz.streampunk.stream-lib.top-k-test
  (:require [clojure.test :refer :all]
            [clojurewerkz.streampunk.stream-lib.top-k :as topk]))

(deftest test-top-k-with-stream-summary
  (let [tk (topk/stream-summary 3)]
    (doseq [s ["X" "X" "Y" "Z" "A" "B" "C" "X" "X" "A" "C" "A" "A"]]
      (topk/offer tk s))
    (let [top (vec (topk/top-k-as-maps tk 3))]
      (is (= [{:item "A" :count 5 :error 2}
              {:item "X" :count 4 :error 2}
              {:item "C" :count 4 :error 2}]
             top)))))
