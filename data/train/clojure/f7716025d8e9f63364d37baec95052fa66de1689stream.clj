(ns kilgore.stream
  (:require [kilgore.store :as store]))

(defprotocol IStream
  (events [_] [_ opts])
  (record-event! [_ event])
  (version [_]))

(defrecord Stream [store stream-id]
  IStream
  (events [_] (store/events store stream-id))
  (events [_ opts] (store/events store stream-id opts))
  (record-event! [_ event] (store/record-event! store stream-id event))
  (version [_] (store/version store stream-id)))

(defn acquire [store stream-id]
  (->Stream store stream-id))

(defn event-reducer [handle-event]
  (let [cache-atom (atom {})]
    (fn [stream]
      (-> cache-atom
          (swap! update-in [stream]
                 #(reduce (fn [state event]
                            (-> state
                                (update-in [:current] handle-event event)
                                (update-in [:version] (fnil inc 0))))
                          %
                          (events stream {:offset (get % :version 0)})))
          (get-in [stream :current])))))
