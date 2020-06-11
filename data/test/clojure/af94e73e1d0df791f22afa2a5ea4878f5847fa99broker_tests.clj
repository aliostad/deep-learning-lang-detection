(ns franzy.embedded.broker-tests
  (:require [midje.sweet :refer :all]
            [franzy.embedded.broker :as broker]
            [franzy.embedded.protocols :refer :all]
            [franzy.embedded.core-test :as core-test])
  (:import (franzy.embedded.broker EmbeddedKafkaBroker StartableEmbeddedKafkaBroker)
           (kafka.utils ZkUtils)
           (org.apache.kafka.common.protocol SecurityProtocol)))

(facts
  "A broker can be created in multiple ways, depending on your needs."
  (fact
    "A broker can be created with defaults, if they make sense for your use-case."
    (instance? EmbeddedKafkaBroker (broker/make-broker)) => true)
  (fact
    "A broker can be created by passing it a broker config with a host name, port, broker id, and zookeeper connection string."
    (let [broker-config {:host.name         "127.0.0.1"
                         :port              9092
                         :broker.id         0
                         :zookeeper.connect "127.0.0.1:2181"}]

      (instance? EmbeddedKafkaBroker (broker/make-broker broker-config)) => true)))

(facts
  "Brokers have a distinct lifecycle"
  (fact
    "Kafka Brokers implement a lifecycle protocol."
    (let [broker (core-test/make-test-broker)]
      (satisfies? KafkaBrokerLifecycle broker) => true))
  (fact
    "A broker is not started until calling startup."
    (let [broker (core-test/make-test-broker)]
      (startup broker) =not=> (throws Exception)
      (attempt-shutdown broker) =not=> (throws Exception)))
  (fact
    "A broker can be created and automatically closed when work is finished by using with-open because it implements Closeable."
    (with-open [_ (core-test/make-test-broker)]))
  (fact
    "A broker can be explicitly closed with `.close`."
    (let [broker (core-test/make-test-broker)]
      (.close broker)))
  (fact
    "A broker can be shutdown by calling shutdown, but you must call await shutdown to block until it shuts down.
    Calling close or attempt-shutdown will automatically do this."
    (let [broker (core-test/make-test-broker)]
      (startup broker)
      (shutdown broker)
      (await-shutdown broker)))
  (fact
    "All the lifecycles apply to a StartableEmbeddedBroker as well."
    (let [startable-broker (core-test/make-test-startable-broker)]
      (instance? StartableEmbeddedKafkaBroker startable-broker) => true
      (satisfies? KafkaBrokerLifecycle startable-broker) => true
      (startup startable-broker)
      (shutdown startable-broker)
      (await-shutdown startable-broker))))

(facts
  "Several helpful functions are available to manage a Kafka Server and test it."
  (fact
    "You can get a reference to ZkUtils instance to use with Franzy-Admin or to use directly."
    (with-open [broker (core-test/make-test-broker)]
      (startup broker)
      (instance? ZkUtils (zk-utils broker)) => true
      ;;Franzy-Admin handles the Scala conversions
      (println (.getAllTopics (zk-utils broker)))))
  (fact
    "ZkUtils will be nil until you start a Broker because there is no connection yet to Zookeeper."
    (let [broker (core-test/make-test-broker)]
      (zk-utils broker) => nil)))

(facts
  "An embedded broker allows some simple state management tools to be used to interrogate the broker"
  (fact
    "It is possible to check the bound port of a broker that is started per channel."
    (with-open [broker (core-test/make-test-broker)]
      (startup broker)
      (bound-port broker SecurityProtocol/PLAINTEXT) => (:port (core-test/make-broker-config))))
  (fact
    "One way of testing whether a broker is working or started is to check its bound port. It will be an exception if not started."
    (let [broker (core-test/make-test-broker)]
      (bound-port broker SecurityProtocol/PLAINTEXT) => (throws NullPointerException))))
