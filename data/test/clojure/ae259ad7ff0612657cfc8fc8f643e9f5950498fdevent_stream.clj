(ns clojure-lwjgl.frp.event-stream
  (:require (clojure-lwjgl [event-queue :as event-queue])))

(defrecord EventStream [sources sinks function])

(defn add-sink [event-stream sink]
  (swap! (:sinks event-stream)
         #(conj % sink)))

(defn create
  ([] (EventStream. (atom [])
                    (atom [])
                    (fn [event] event))))

(defn map [source function]
  (let [event-stream  (EventStream. (atom [source])
                                    (atom [])
                                    function)]
    (add-sink source event-stream)
    event-stream))

(defn send-event [event-stream event]
  (let [processed-event ((:function event-stream) event)]
    (when processed-event
      (doseq [sink @(:sinks event-stream)]
        (send-event sink processed-event)))))

(defn handle-key-pressed-event [gui key-pressed-event]
  (send-event (:key-pressed-event-stream gui)
              key-pressed-event)
  gui)


(defn filter [source predicate]
  (create source
          (fn [event] (if (predicate event)
                        event
                        nil))))

(defn initialize [gui]
  (-> gui
      (event-queue/add-event-handlers [:key-pressed] handle-key-pressed-event)
      (assoc :key-pressed-event-stream (create))))