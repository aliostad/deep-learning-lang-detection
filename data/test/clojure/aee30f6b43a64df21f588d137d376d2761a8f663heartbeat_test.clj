(ns slack-slurper.heartbeat-test
  (:require [clojure.test :refer :all]
            [manifold.stream :as s]
            [cheshire.core :as json]
            [slack-slurper.heartbeat :refer :all]))

(deftest test-heartbeats
  (testing "puts generated msg onto stream"
    (let [g (fn [] "hi")
          stream (s/stream)]
      (heartbeat stream g (atom true) 10)
      (Thread/sleep 100)
      (is (= "hi" @(s/take! stream)))
      (s/close! stream))))


(deftest test-gen-message
  (is (= #{"id" "type"}
         (into #{}
               (keys (json/parse-string (message))))))
  (is (= "ping"
         ((json/parse-string (message)) "type"))))
