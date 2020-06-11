(ns cqrs-crmkern.core-test
  (:require [clojure.test :refer :all]
            [environ.core :refer [env]]
            [clj-uuid :as uuid]

            [clojure.spec :as spec]
            [clojure.spec.gen :as sgen]
            [clojure.spec.test :as stest]
            [cqrs-crmkern.core :refer :all]
            [cqrs-crmkern.failure :refer [failure?]]
))

(deftest test-dev-env
  (is (= "3000" (env :port))))
(deftest a-test
  (testing "command-api"
    (is (= 0 1))))

(deftest test-command-handler

  (stest/instrument 'cqrs-crmkern.core/command-handler)
  
  #_(macroexpand-check 'cqrs-crmkern.commands.auth/auth-by-id-and-password [{:id "kang" :password "1234"}]
                     )
  
  (testing "exsting command should be processed"
    (is (= (contains? (command-handler {:params
                                        {:cmd "auth"
                                         :args [{:id "kang" :password "1234"}]}})
                      :eid))))

  (testing "exsting command should be processed"
    (is (= (contains? (command-handler {:params
                                        {:cmd "auth"
                                         :args [{:id "854c1cab-7a4d-459f-8974-9ee5138684eb", :pasword "1111", :eid "fc1eabba-94bc-4292-975a-782ee4b3974f"}]}})
                      :eid))))
  

  (testing "non exsting command should fail"
      (is (failure? (command-handler {:params
                                     {:cmd "xxxauth"
                                      :args [{:id "kang" :password "1234"}]}}))))

  (testing "non conform command args should fail"
    (is (failure? (command-handler {:params
                                    {:cmd "auth"
                                     :args [{:id 111 :password "1234"}]}}))))

  (testing "non exsting command spec should be processed without syntax validation"
      (is (contains? (command-handler {:params
                                   {:cmd "no-spec"
                                    :args [{:id "kang" :password "1234"}]}})
                     :eid)))
  )

(deftest test-query-handler

  (stest/instrument 'cqrs-crmkern.core/query-handler)
  
  #_(macroexpand-check 'cqrs-crmkern.commands.auth/auth-by-id-and-password [{:id "kang" :password "1234"}]
                     )
  
  (testing "exsting command should be processed"
    (let [result (query-handler {:params
                                 {:db "ea2"
                                  :eid (uuid/v1)
                                  :col "orders"
                                  :query {}}})]
      (println ::test-query-handler result)
      (is (= (contains? result
              :eid)))))

  )
