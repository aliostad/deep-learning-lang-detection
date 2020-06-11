(ns event-processing.tasks.kafka
    (:require [taoensso.timbre :refer [info]]
              [cheshire.core :as json]))

(defn deserialize-message-json [bytes]
  (try
    (json/parse-string (String. bytes "UTF-8"))
    (catch Exception e
      {:error e})))

(defn deserialize-message-edn [bytes]
  (try
    (read-string (String. bytes "UTF-8"))
    (catch Exception e
      {:error e})))

(defn serialize-message-json [segment]
  (.getBytes (json/generate-string segment)))

(defn serialize-message-edn [segment]
  (.getBytes segment))

(defn add-kafka-input
  "Instrument a job with Kafka lifecycles and catalog entries."
  [job task opts]
  (-> job
      (update :catalog conj (merge {:onyx/name task
                                    :onyx/plugin :onyx.plugin.kafka/read-messages
                                    :onyx/type :input
                                    :onyx/medium :kafka
                                    ;:kafka/topic "topic"
                                    ;:kafka/group-id "group-id"
                                    :kafka/fetch-size 307200
                                    :kafka/chan-capacity 1000
                                    ;:kafka/zookeeper "zookeeper-addr"
                                    :kafka/offset-reset :smallest
                                    ;:kafka/force-reset? true
                                    :kafka/empty-read-back-off 500
                                    :kafka/commit-interval 500
                                    ;:kafka/deserializer-fn ::deserialize-message-json
                                    ;:onyx/batch-size 100
                                    :onyx/doc "Reads messages from a Kafka topic"}
                                   opts))
      (update :lifecycles conj {:lifecycle/task task
                                :lifecycle/calls :onyx.plugin.kafka/read-messages-calls})))

(defn add-kafka-output
  "Instrument a job with Kafka lifecycles and catalog entries."
  [job task opts]
  (-> job
      (update :catalog conj (merge {:onyx/name task
                                    :onyx/plugin :onyx.plugin.kafka/write-messages
                                    :onyx/type :output
                                    :onyx/medium :kafka
                                    ;:onyx/batch-size batch-size
                                    ;:kafka/topic topic
                                    ;:kafka/zookeeper zookeeper-addr
                                    ;:kafka/serializer-fn (expand-serializer-fn serializer-fn)
                                    :kafka/request-size 307200
                                    :onyx/doc "Writes messages to a Kafka topic"}
                                   opts))
      (update :lifecycles conj {:lifecycle/task task
                                :lifecycle/calls :onyx.plugin.kafka/write-messages-calls})))
