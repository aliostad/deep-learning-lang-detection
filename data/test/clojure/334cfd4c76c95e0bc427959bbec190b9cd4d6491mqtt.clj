(ns us.edwardstx.hvac.mqtt
  (:require [us.edwardstx.conf.client :refer [get-conf]]
            [manifold.stream :as s]
            [byte-streams :as bs]
            [hare.core :as hare]))

(defn parse-value [m & ks]
  (assoc-in m ks (read-string (get-in m ks))))

(defn conf []
  (->
           "hvac_daemon"
           get-conf
           :hare
           (parse-value :rabbit :port)
           (parse-value :rabbit :ssl)
           (assoc :reply-queue-name "hvac.reply")))

(defn conn [c] (hare.core/connect c))

(defn stream-handler
  [stream]
   (fn [ch meta payload]
     (s/put! stream (bs/to-string payload))))

(defn subscribe [c topic]
  (let [stream (s/stream)]
    (hare.core/subscribe-to c topic
                            (stream-handler stream))
    stream))


