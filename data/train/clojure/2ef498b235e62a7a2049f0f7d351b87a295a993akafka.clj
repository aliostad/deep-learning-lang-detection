(ns desdemona.tasks.kafka
  (:require [taoensso.timbre :refer [info]]
            [byte-streams :as bs]
            [cheshire.core :as json]
            [camel-snake-kebab.core :refer [->kebab-case-keyword]]))

(defn deserialize-message-json [bytes]
  (try
    (json/decode-stream (bs/to-reader bytes) ->kebab-case-keyword)
    (catch Exception e
      {:error e})))

(defn deserialize-message-raw [bytes]
  (try
    {:line (String. bytes "UTF-8")}
    (catch Exception e
      {:error e})))

(defn add-kafka-input
  "Instrument a job with Kafka lifecycles and catalog entries."
  [job task opts]
  (-> job
      (update :catalog conj
              (merge {:onyx/name task
                      :onyx/plugin :onyx.plugin.kafka/read-messages
                      :onyx/type :input
                      :onyx/medium :kafka
                      :kafka/fetch-size 307200
                      :kafka/chan-capacity 1000
                      :kafka/offset-reset :smallest
                      :kafka/empty-read-back-off 500
                      :kafka/commit-interval 500
                      :onyx/doc "Reads messages from a Kafka topic"}
                     opts))
      (update :lifecycles conj
              {:lifecycle/task task
               :lifecycle/calls :onyx.plugin.kafka/read-messages-calls})))
