(ns clj-slack-client.core
  (:gen-class)
  (:require
    [clj-slack-client
     [team-state :as state]
     [connectivity :as conn]
     [rtm-receive :as rx]]
    [clj-time.coerce :refer [to-long]]
    [manifold.stream :as stream]))


(defn disconnect
  []
  (conn/disconnect))


(defn connect
  ([api-token host-handle-event]
   (connect api-token host-handle-event {:log true}))
  ([api-token host-handle-event options]
   (let [rx-event-stream (stream/stream 8)
         pass-event-to-rx #(stream/put! rx-event-stream %)
         host-event-stream (stream/stream 8)
         pass-event-to-host #(stream/put! host-event-stream %)
         reconnect (fn [] (do (when (options :log)
                                (println "reconnecting..."))
                              (disconnect)
                              (connect api-token host-handle-event options)))]
     (stream/consume #(rx/handle-event % pass-event-to-host) rx-event-stream)
     (stream/consume host-handle-event host-event-stream)
     (conn/start-real-time api-token state/set-team-state pass-event-to-rx reconnect options))))


(defn time->ts
  "converts a joda DateTime into an approximate slack message timestamp"
  [time]
  (-> time
      (to-long)
      (/ 1000)
      (int)
      (str)))
