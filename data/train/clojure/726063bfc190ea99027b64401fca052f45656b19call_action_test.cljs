(ns ivr.models.call-action-test
  (:require [clojure.test :as test :refer-macros [async deftest is run-tests testing use-fixtures]]
            [cljs.spec.test.alpha :as stest]
            [ivr.models.call :as call]
            [ivr.models.call-action :as call-action]))

(use-fixtures :once
  {:before (fn [] (stest/instrument 'ivr.models.call-action))
   :after (fn [] (stest/unstrument 'ivr.models.call-action))})

(deftest call-action-model-test

  (testing "call->ticket"
    (let [call (-> (call/info->call {:id "call-id"
                                     :account-id "account-id"
                                     :application-id "application-id"
                                     :from "from-sda"
                                     :to "to-sda"
                                     :script-id "script-id"
                                     :time "call-time"})
                   (assoc :action-ongoing {:action {:action :ongoing}
                                           :start-time 42}))]
      (is (= {:producer "IVR"
              :subject "ACTION"
              :accountid "account-id"
              :applicationid "application-id"
              :callid "call-id"
              :callTime "call-time"
              :scriptid "script-id"
              :from "from-sda"
              :to "to-sda"
              :action {:action :ongoing}
              :time 71
              :duration 29}
             (call-action/call->ticket call 71))))))
