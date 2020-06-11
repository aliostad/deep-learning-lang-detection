(ns rabbitmq-clj.api.policies-test
  "Tests related to policies endpoints."
  (:require [clojure.test :refer :all]
            [rabbitmq-clj.core :refer [dispatch]]))

(deftest policies
  (testing "Policy endpoints"
    (let [attrs {:ha-mode "all" :ha-sync-mode "automatic"}]
      (is (empty? (dispatch :policies :list)))
      (is (nil? (dispatch :policies :update "/" "ha-all" ".*" attrs)))
      (is (= attrs (:definition (dispatch :policies :list "/" "ha-all"))))
      (is (nil? (dispatch :policies :clear "/" "ha-all"))))))
