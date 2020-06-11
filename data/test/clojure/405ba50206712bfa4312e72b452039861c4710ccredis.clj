(ns qfarm-websocket.redis
  (:require [clojure.tools.logging :refer [debug info]]
            [manifold.stream :as s]
            [mount.core :refer [args defstate]]
            [taoensso.carmine :as car]))

(defn push-to-stream [out [op k v]]
  (when (= op "message")
    (debug "Message received" v)
    (s/put! out v)))

(defn create-events-stream [{:keys [:host :port :topic]}]
  (info "Connecting to Redis at" (str host ":" port))
  (let [events-stream (s/stream 128)
        listener (car/with-new-pubsub-listener {:host host
                                                :port port}
                   {topic (partial push-to-stream events-stream)}
                   (car/subscribe topic))]
    (s/on-closed events-stream (partial car/close-listener listener))
    events-stream))

(defstate events
  :start (create-events-stream {:host (:redis-host (args))
                                :port (:redis-port (args))
                                :topic (:redis-topic (args))})
  :stop (s/close! events))
