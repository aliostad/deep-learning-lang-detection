(ns arion.partitioner
  (:require [arion.api.broadcast :refer [queue-name]]
            [arion.protocols :as p]
            [com.stuartsierra.component :as component]
            [manifold
             [deferred :as d]
             [stream :as s]]
            [taoensso.timbre :refer [info warn]]))

(defn take! [queue queue-name]
  (try (p/take! queue queue-name)
       (catch Exception e
         (warn "unable to take message from queue:" (.getMessage e)))))

(defn process-payload [payload producer partition-stream streams]
  (d/let-flow' [{:keys [topic key]} @payload
                partition (p/key->partition producer topic key)
                stream-key [topic partition]]

    (if-let [stream (get streams stream-key)]
      (d/chain' (s/put! stream payload)
        #(when % streams))

      (let [new-stream (s/stream* {:buffer-size 64})]
        (s/on-drained partition-stream #(s/close! new-stream))
        (d/chain' (s/put! new-stream payload)
          (fn [_] (s/put! partition-stream
                          {:topic     topic
                           :partition partition
                           :stream    new-stream}))
          #(when % (assoc streams stream-key new-stream)))))))

(defn process-queue [partition-stream queue producer]
  (d/loop [streams {}]
    (if-let [payload (take! queue queue-name)]
      (-> (d/chain' (process-payload payload producer partition-stream streams)
            #(when % (d/recur %)))

          (d/catch' Exception
            (fn [e]
              (warn "unable to process payload" (.getMessage e))
              (d/recur streams))))

      (d/recur streams))))

(defn partition-queue [queue producer]
  (let [partition-stream (s/stream)]
    (d/future (process-queue partition-stream queue producer))
    partition-stream))

(defrecord Partitioner [metrics producer queue partition-stream]
  component/Lifecycle
  (start [component]
    (info "starting partitioner")
    (let [partition-stream (partition-queue queue producer)]
      (assoc component :partition-stream partition-stream)))

  (stop [component]
    (info "stopping partitioner")
    (s/close! partition-stream)
    (assoc component :closing nil :partition-stream nil))

  p/Partition
  (partitions [_] partition-stream))

(defn new-partitioner []
  (Partitioner. nil nil nil nil))
