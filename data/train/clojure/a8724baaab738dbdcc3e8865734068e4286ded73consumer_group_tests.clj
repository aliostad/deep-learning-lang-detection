(ns franzy.admin.consumer-group-tests
  (:require [midje.sweet :refer :all]
            [schema.core :as s]
            [franzy.admin.schema :as fas]
            [franzy.admin.core-test :as core-test]
            [franzy.admin.consumer-groups :refer :all]
            [franzy.admin.topics :as topics])
  (:import (java.util UUID)))

;;note - you may not see results here if you aren't using a consumer that registers itself. Try a subscription consumer.
(with-open [zk-utils (core-test/make-zk-utils)]
  (let [topic (str (UUID/randomUUID))
        partitions 3
        topics [topic]
        group "culture-of-consumption"]
    ;(topics/create-topic! zk-utils topic partitions)
    ;(topics/create-topic! zk-utils topic-to-repartition partitions)
    (facts
      "Consumer groups can be administered."
      (fact
        "All consumer groups can be queried."
        (let [groups (consumer-groups zk-utils)]
          (coll? groups) => true))

      (fact
        "Consumer groups can be queried by topic."
        (let [groups (consumer-groups-by-topic zk-utils topic)]
          (coll? groups) => true))
      (fact
        "Consumer groups may be queried by group name and returned by topic, optionally excluding internal topics."
        (let [groups (consumers-groups-per-topic zk-utils group true)]
          (coll? groups) => true
          (map? groups) => true))
      (fact
        "Consumer groups can be checked if they are active, returning nil if the group doesn't exist."
        (let [active? (consumer-group-active? zk-utils "22-Helens")]
          active? => nil))
      (fact
        "Consumers in a consumer group can be listed, return nil if there are none."
        (let [consumers (consumers-in-group zk-utils group)]
          (when consumers
            (coll? consumers) => true))))
    ;;TODO: delete tests

    (facts
      "It is possible to query Zookeeper to get more information about Kafka consumer groups or if you want to use other Zookeeper tools to manage it."
      (fact
        "It is possible to query the path in Zookeeper for a consumer group name, topic, and partition."
        ;;ex: /consumers/culture-of-consumption/owners/hacking-is-a-dumb-term-for-programming-these-days/23
        (let [path (consumer-partition-owner-path zk-utils group topic 0)]
          (string? path)) => true)
      (fact
        "Returns the consumers path in Zookeeper."
        ;;ex: consumers
        (let [path (consumers-path)]
          (string? path) => true)
        ))))
