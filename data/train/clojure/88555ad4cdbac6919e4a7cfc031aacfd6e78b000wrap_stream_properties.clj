(ns rill.wheel.wrap-stream-properties
  (:require [rill.event-store :refer [EventStore retrieve-events-since append-events]]
            [rill.event-stream :refer [all-events-stream-id]]))


(defn valid-props?
  [p]
  (and (map? p)
       (sorted? p)))

(defrecord StreamPropertiesWrapper [delegated-event-store]
  EventStore
  (retrieve-events-since [this props cursor wait-for-seconds]
    (assert (or (= all-events-stream-id props)
                (valid-props? props))
            "Can only use sorted maps as props")
    (let [stream-id (if (= all-events-stream-id props)
                      all-events-stream-id
                      (pr-str props))
          events (retrieve-events-since delegated-event-store stream-id cursor wait-for-seconds)]
      (if (= props all-events-stream-id)
        ;; must fetch props for each event separately
        (map (fn [e]
               (let [id (read-string (:rill.message/stream-id e))]
                 (-> e
                     (merge id)
                     (assoc :rill.message/stream-id id))))
             events)
        ;; set these props on every event
        (map (fn [e] (-> e
                         (merge props)
                         (assoc :rill.message/stream-id props)))
             events))))
  (append-events [this props from-version events]
    (assert (valid-props? props)
            "Can only use sorted maps as props")
    (append-events delegated-event-store (pr-str props) from-version (map #(apply dissoc % (keys props)) events))))

(defn wrap-stream-properties
  [event-store]
  (map->StreamPropertiesWrapper {:delegated-event-store event-store}))
