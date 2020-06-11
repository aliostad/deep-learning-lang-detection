(ns bottle.messaging.consumer.stream
  (:require [bottle.util :as util]
            [bottle.messaging.consumer :refer [consumer]]
            [bottle.messaging.handler :as handler]
            [bottle.messaging.stream-manager]
            [com.stuartsierra.component :as component]
            [manifold.stream :as stream]
            [taoensso.timbre :as log]
            [bottle.messaging.stream-manager :as stream-manager]))

(defrecord StreamConsumer [id handler stream-manager]
  component/Lifecycle
  (start [this]
    (log/debug (str "Starting consumer " id "."))
    (stream/consume
     (fn [message]
       (try
         (log/trace "Processing message.")
         (handler/handle-message handler message)
         (catch Exception e
           (log/error e (str "Exception thrown by message handler.")))))
     (stream-manager/stream stream-manager id))
    this)
  (stop [this]
    (log/debug (str "Stopping consumer " id "."))
    (dissoc this :stream-manager)))

(defmethod consumer :stream
  [{id :bottle.messaging/stream}]
  (component/using
   (map->StreamConsumer {:id id})
    [:stream-manager]))
