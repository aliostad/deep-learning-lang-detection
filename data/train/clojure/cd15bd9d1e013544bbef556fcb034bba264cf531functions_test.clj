(ns onyx.plugin.functions-test
  (:require [clojure.test :refer [deftest is testing]]
            [onyx.plugin.functions :as f]))


(deftest test-cases-for-stream-transducer
  (testing "Given an insert payload resembling a dynamodb stream"
    (is (= (f/transform-stream-item [:insert {:name "John"}]) {:event-type :insert :new {:name "John"}}))
    (is (= (f/transform-stream-item [:modify {:name "John"} {:name "John" :age 31}])
          {:event-type :modify :old {:name "John"} :new {:name "John" :age 31}}))
    (is (= (f/transform-stream-item [:delete {:name "John"}]) {:event-type :delete :deleted {:name "John"}}))))

