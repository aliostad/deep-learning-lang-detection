(ns domain.handler-test
  (:require [clojure.test :refer :all]
            [taoensso.timbre :as log]

            [clojure.spec :as spec]
            [clojure.spec.gen :as sgen]
            [clojure.spec.test :as stest]


            [domain.handler :as dh]
            ))

(stest/instrument 'domain.handler/consumer-command-handler)
(deftest test-consumer-command-handler
  (testing "basics - returns a recordmetadata with topic 'events'"
    (let [result @(dh/consumer-command-handler {:value {:eid "123" :cmd "auth" :args [{:id "kang" :password "1234"}]}})
          ]
      (log/debug ::ret (.topic result) )
      (is (= org.apache.kafka.clients.producer.RecordMetadata (type result)))
      (is (= "events" (.topic result)))
      ))

  (testing "handler with custom topic"
    (let [result @(dh/consumer-command-handler {:value {:eid "123" :cmd "auth" :args [{:id "kang" :password "1234"}]}} :topic "test-xxx")
          ]
      (log/debug ::ret (.topic result) )
      (is (= org.apache.kafka.clients.producer.RecordMetadata (type result)))
      (is (= "test-xxx" (.topic result)))
      ))

  )
