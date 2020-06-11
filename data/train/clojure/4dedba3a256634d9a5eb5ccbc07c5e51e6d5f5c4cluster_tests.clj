(ns franzy.admin.cluster-tests
  (:require [midje.sweet :refer :all]
            [franzy.admin.core-test :as core-test]
            [franzy.admin.cluster :refer :all]
            [schema.core :as s]
            [franzy.admin.schema :as fas]))

(with-open [zk-utils (core-test/make-zk-utils)]

  (facts
    "A Kafka cluster can be administered."
    (fact
      "All brokers in the cluster can be queried."
      ;;ex [{:id 0, :endpoints {:plaintext {:host "127.0.0.1", :port 9092, :protocol-type :plaintext}}} {:id 1001, :endpoints {:plaintext {:host "127.0.0.1", :port 9092, :protocol-type :plaintext}}}]
      (let [brokers (all-brokers zk-utils)
            broker (first brokers)]
        (nil? brokers) => false
        (coll? brokers) => true
        (map? broker) => true
        (s/check fas/Broker broker) => nil
        (s/check [fas/Broker] brokers) => nil))
    (fact
      "All broker IDs can be retrieved if you only need broker IDs and not extra metadata."
      ;;ex: [1001 1002]
      (let [broker-ids (broker-ids zk-utils)]
        (nil? broker-ids) => false
        (coll? broker-ids) => true
        broker-ids => (has every? integer?)))
    (fact
      "A specific broker's metadata can be queried."
      ;;ex: {:id 0, :endpoints {:plaintext {:host "10.0.0.4", :port 9092, :protocol-type :plaintext}}}
      (let [broker-ids (broker-ids zk-utils)
            _ (nil? broker-ids) => false
            broker-id (first broker-ids)
            _ (nil? broker-id) => false
            metadata (broker-metadata zk-utils broker-id)]
        (nil? metadata) => false
        (map? metadata) => true
        (s/check fas/Broker metadata) => nil))
    (fact
      "Endpoints per channel can be listed."
      ;;ex: [{:id 0, :host "127.0.0.1", :port 9092} {:id 1001, :host "127.0.0.1", :port 9092}]
      (let [endpoints (broker-endpoints-for-channel zk-utils :plaintext)]
        (coll? endpoints) => true
        (sequential? endpoints) => true
        (s/check [fas/BrokerEndPoint] endpoints) => nil))

    ;(fact
    ;  "A broker can be registered."
    ;  (let [id 1005
    ;        host "127.0.0.1"
    ;        port 9092
    ;        endpoints {:plaintext {:host          "127.0.0.1"
    ;                               :port          9092
    ;                               :protocol-type :plaintext}}
    ;        jmx-port -1]
    ;    (register-broker! zk-utils id host port endpoints jmx-port)))
    ))

(facts
  "It is possible to query Zookeeper to get more information about Kafka or if you want to use other Zookeeper tools to manage it."
  (fact
    "It is possible to get the broker ids path in zookeeper"
    ;;ex: /brokers/ids
    (let [path (broker-ids-path)]
      (string? path) => true))
  (fact
    "It is possible to get the brokers sequence id path."
    ;;ex: /brokers/seqid
    (let [path (broker-sequence-id-path)]
      (string? path) => true))
  (fact
    "It is possible to get the broker topics path."
    ;;ex: /brokers/topics
    (let [path (broker-topics-path)]
      (string? path) => true)))
