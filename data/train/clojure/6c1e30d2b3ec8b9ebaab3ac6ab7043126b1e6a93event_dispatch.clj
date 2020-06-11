(ns realtime.event-dispatch
  (:require [realtime.subscriptions :refer [send! send-sub!]]
            [taoensso.timbre :as timbre]))

(defmulti dispatch!
  (fn [_ _ {:keys [event]}]
    event))

(defmethod dispatch! :routes/subscribe!
  [{:keys [client-store last-message]}
   {:keys [client-id channel] :as subscription}
   {{:keys [routes-sub]} :data :as event}]
  (timbre/info "client subscribing" {:client-id client-id})
  (swap! client-store update-in
         [client-id]
         (fn [old] (assoc old :routes-sub routes-sub))) ;; sub currently ignored
  (send-sub! subscription @last-message))

(defmethod dispatch! :default
  [_ {:keys [channel]} message]
  (send! channel :unknown/event message))
