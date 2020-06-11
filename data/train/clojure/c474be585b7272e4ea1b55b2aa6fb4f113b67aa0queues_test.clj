(ns rabbitmq-clj.api.queues-test
  "Tests related to virtualhost endpoints."
  (:require [clojure.test :refer :all]
            [rabbitmq-clj.core :refer [dispatch]]))

(deftest queues
  (testing "Queues endpoints"
    (let [attrs {:durable false}]
      (is (empty? (dispatch :queues :list "/")))
      (is (nil? (dispatch :queues :declare "/" "myqueue" attrs)))
      (is (some #{"myqueue"} (map :name (dispatch :queues :list "/"))))
      (is (= "myqueue" (:name (dispatch :queues :list "/" "myqueue"))))
      (is (some #{"myqueue"} (map :routing_key
                                  (dispatch :queues :bindings "/" "myqueue"))))
      (is (nil? (dispatch :queues :delete "/" "myqueue"))))))
