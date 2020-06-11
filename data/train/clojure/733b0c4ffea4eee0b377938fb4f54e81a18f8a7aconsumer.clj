(ns manifold-kafka.consumer
  (:require [clj-kafka.consumer.zk :as zk]
            [clj-kafka.core :refer [to-clojure]]
            [manifold.stream :as s]))

(defn input-stream
  "takes a kafka consumer config map and a topic and returns a manifold stream which represents the topic.
  When the stream is closed, the Kafka Consumer will be shut down.
  A message is only taken from kafka and put on the stream when the stream contains no messages."
  [consumer-config topic]
  (let [output (s/stream)
        consumer (zk/consumer consumer-config)]
    (s/on-closed output (fn [] (zk/shutdown consumer)))
    (future
      (doseq [msg (zk/messages consumer topic)]
        @(s/put! output msg)))
    output))
