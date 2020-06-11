(ns bottle.messaging.producer.stream
  (:require [bottle.messaging.producer :refer [producer]]
            [com.stuartsierra.component :as component]
            [manifold.stream :as stream]
            [bottle.messaging.stream-manager :as stream-manager])
  (:import [bottle.messaging.producer Producer]))

(defrecord StreamProducer [id stream-manager]
  Producer
  (produce [this message]
    (let [stream (stream-manager/stream stream-manager id)]
      (stream/put! stream message))))

(defmethod producer :stream
  [{id :bottle.messaging/stream}]
  (component/using
   (map->StreamProducer {:id id})
    [:stream-manager]))
