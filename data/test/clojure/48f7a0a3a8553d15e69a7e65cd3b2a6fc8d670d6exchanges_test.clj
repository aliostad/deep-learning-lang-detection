(ns rabbitmq-clj.api.exchanges-test
  "Tests related to exchange endpoints."
  (:require [clojure.test :refer :all]
            [rabbitmq-clj.core :refer [dispatch]]))

(deftest exchanges
  (testing "Exchange endpoints"
    (let [attrs {:auto_delete true}]
      (is (nil? (dispatch
                  :exchanges :declare "/" "myexchange" attrs)))
      (is (some #{"myexchange"} (map :name (dispatch :exchanges :list "/"))))
      (is (= "myexchange" (:name (dispatch :exchanges :list "/" "myexchange"))))
      (is (nil? (dispatch :exchanges :delete "/" "myexchange"))))))
