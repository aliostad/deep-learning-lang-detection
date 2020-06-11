(ns daw.events
  (:require [re-frame.core :as re-frame]
            [mozart.audio :as audio]
            [mozart.synth :as synth]))

(re-frame/reg-event-db
  :initialize-db
  (fn  [_ _]
    (let [ctx (audio/create-context!)
          env1 (audio/envelope {:a 0 :d 0 :s 1 :r 1})
          env2 (audio/envelope {:a 4 :d 0 :s 1 :r 0.1})
          osc1 (synth/oscillator "sine")
          osc2 (synth/oscillator "square")
          synth (-> (synth/instrument ctx)
                  (synth/add-osc osc1)
                  (synth/add-osc osc2)
                  (synth/add-env env1)
                  (synth/add-env env2))
          synth (-> synth
                  (synth/plug (first (:envelopes synth)) (first (:vcos synth)))
                  (synth/plug (second (:envelopes synth)) (second (:vcos synth))))]
      {:ctx ctx
       :synth synth
       :audio-graph (audio/connect {} synth (audio/destination ctx))})))

(re-frame/reg-event-db
  :note-on
  (fn [db [_ note]]
    (update db :synth synth/note-on note)))

(re-frame/reg-event-db
  :note-off
  (fn [db [_ note]]
    (update db :synth synth/note-off note)))

(re-frame/reg-event-db
  :set-wave-type
  (fn [db [_ type]]
    (assoc-in db [:synth :wave-type] type)))

(re-frame/reg-event-db
  :change-envelope
  (fn [db [_ k v]]
    (assoc-in db [:synth :env k] v)))
