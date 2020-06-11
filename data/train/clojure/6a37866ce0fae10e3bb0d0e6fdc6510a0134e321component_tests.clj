(ns franzy.embedded.component-tests
  (:require [midje.sweet :refer :all]
            [franzy.embedded.component :as broker-component]
            [franzy.embedded.core-test :as core-test]
            [franzy.embedded.protocols :refer :all]
            [franzy.embedded.extensions :refer :all]
            [com.stuartsierra.component :as component])
  (:import (org.apache.kafka.common.protocol SecurityProtocol)
           (franzy.embedded.component EmbeddedBroker)
           (kafka.server KafkaServer)
           (kafka.utils ZkUtils)))

(facts
  "A broker component can be created in multiple ways, depending on your needs."
  (fact
    "A broker component can be created with defaults, if they make sense for your use-case."
    (instance? EmbeddedBroker (broker-component/make-embedded-broker)) => true)
  (fact
    "A broker component can be created by passing it a broker config with a host name, port, broker id, and zookeeper connection string."
    (let [broker-config {:host.name         "127.0.0.1"
                         :port              9092
                         :broker.id         0
                         :zookeeper.connect "127.0.0.1:2181"}]

      (instance? EmbeddedBroker (broker-component/make-embedded-broker broker-config)) => true)))

(facts
  "Brokers have a distinct lifecycle"
  (fact
    "Kafka Broker Components implement the component lifecycle."
    (let [broker (core-test/make-test-broker-component)]
      (satisfies? component/Lifecycle broker) => true))
  (fact
    "Kafka Broker Components do not implement a KafkaBrokerLifecycle protocol."
    (let [broker (core-test/make-test-broker-component)]
      (satisfies? KafkaBrokerLifecycle broker) => false))
  (fact
    "A broker component is not started until calling start, which starts up the broker and component."
    (let [broker (core-test/make-test-broker-component)
          started-broker (component/start broker)]
      (->> started-broker
           (:server)
           (instance? KafkaServer)) => true
      (->> started-broker
           (component/stop)
           (:server)) => nil)))

(facts
  "Several helpful functions are available to manage a Kafka Server and test it."
  (fact
    "You can get a reference to ZkUtils instance to use with Franzy-Admin or to use directly."
    (let [broker (component/start (core-test/make-test-broker-component))]
      (instance? ZkUtils (zk-utils broker)) => true
      ;;Franzy-Admin handles the Scala conversions
      (println (.getAllTopics (zk-utils broker)))
      (component/stop broker)))
  (fact
    "ZkUtils will be nil until you start a Broker because there is no connection yet to Zookeeper."
    (let [broker (core-test/make-test-broker-component)]
      (zk-utils broker) => nil)))

(facts
  "An embedded broker allows some simple state management tools to be used to interrogate the broker"
  (fact
    "It is possible to check the bound port of a broker that is started per channel."
    (let [broker (component/start (core-test/make-test-broker-component))]
      (bound-port broker SecurityProtocol/PLAINTEXT) => (:port (core-test/make-broker-config))
      (component/stop broker))))
