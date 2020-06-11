(ns test-arq.util
  (:require [beicon.core :as rx]))

;; Basic protocols for updating

;;; process-update :: Event -> Model -> Model
(defprotocol UpdateEvent
  (process-update [event model]))

(defn update? [e] (satisfies? UpdateEvent e))

;;; process-watch  :: Event -> Stream[Event]
(defprotocol WatchEvent
  (process-watch [event model]))

(defn watch? [e] (satisfies? WatchEvent e))

(defprotocol EffectEvent
  (process-effect [event model]))

(defn effect? [e] (satisfies? EffectEvent e))


;; Defines model stream
(defonce event-stream (rx/bus))

(defn publish! [event]
  (rx/push! event-stream event))

(defn signal [event]
  (fn [e] (publish! event)))

(defn noop [_])

;; This are the same versions but with corrected signatures and 'safe'
(defn- -process-update [model event]
  (try (process-update event model)
       (catch js/Object e (publish! e))))

(defn- -process-effect [[event model]]
  (try (process-effect event model)
       (catch js/Object e (publish! e))))

(defn- -process-watch [[event model]]
  (try (process-watch event model)
       (catch js/Object e (publish! e))))

;; Main model changes
(defn model-changes-stream [event-stream init-model]
  (let [update-stream (->> event-stream (rx/filter update?))
        watch-stream  (->> event-stream (rx/filter watch?))
        effect-stream (->> event-stream (rx/filter effect?))
        model-stream  (->> update-stream
                           (rx/scan -process-update init-model))]

    ;; Process effects: combine with the latest model to process the new effect
    (as-> effect-stream $
          (rx/with-latest-from vector model-stream $)
          (rx/subscribe $ -process-effect))

    ;; Process event sources: combine with the latest model and the result will be
    ;; pushed to the event-stream bus
    (as-> watch-stream $
          (rx/with-latest-from vector model-stream $)
          (rx/flat-map  $)
          (rx/subscribe $ publish!))

    model-stream))
