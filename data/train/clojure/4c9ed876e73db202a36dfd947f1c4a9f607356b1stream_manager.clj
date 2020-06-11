(ns bottle.messaging.stream-manager
  (:require [com.stuartsierra.component :as component]
            [manifold.stream :as stream]
            [taoensso.timbre :as log]))

(defprotocol StreamManager
  (stream [this id]))

(defrecord ManifoldStreamManager [ids streams]
  StreamManager
  (stream [this id]
    (or (get streams id)
        (throw (ex-info (str "Stream " id " not found.") {:ids ids
                                                          :streams streams}))))
  component/Lifecycle
  (start [this]
    (let [ids (or ids [])]
      (if-not (empty? ids)
        (log/info "No streams to start!")
        (log/info (str "Starting streams: " ids)))
      (assoc this :streams (into {} (map #(vector % (stream/stream)) ids)))))
  (stop [this]
    (doseq [[id stream] streams] (stream/close! stream))
    (dissoc this streams)))

(defn stream-manager
  [{streams :bottle/streams}]
  (map->ManifoldStreamManager {:ids streams}))
