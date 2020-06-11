(ns clhorus.lib.bus.channel
  (:require [clhorus.lib.bus.protocol]
            [clojure.core.async :as async :refer [>! go alts! chan]])
  (:import (clhorus.lib.bus.protocol Bus)))

(defrecord BusChannel [atom-chan-handlers]
  Bus

  (publish [this message]
    (let [handler-id (class message)
          handler    (get @atom-chan-handlers handler-id)]
      (if (nil? handler)
        (println "No handler found for " handler-id)
        (go (>! handler message)))))

  (subscribe [this message-class handle]
    (let [handler-id message-class
          bus        (chan)]
      (->> bus
           (assoc @atom-chan-handlers handler-id)
           (reset! atom-chan-handlers))
      ; @fixme it should manage how ends the infinite loop
      (go (while true
            (let [[message channel] (alts! [bus])]
              (handle message))))
      handler-id))

  (unsubscribe [this id]
    (->> (dissoc @atom-chan-handlers id)
         (reset! atom-chan-handlers))))

(defn new-bus-channel []
  (map->BusChannel {:atom-chan-handlers (atom {})}))
