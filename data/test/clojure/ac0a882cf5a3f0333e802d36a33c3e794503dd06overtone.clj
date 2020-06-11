(ns patrn.overtone
  "Functions to simplify the playback of event sequences with Overtone."
  (:require [clojure.pprint :as pprint] 
            [patrn.musical-event :as event]
            [patrn.core :as p])
  (:use [overtone.core]))

(defn inst-param-names
  "Gets sequence of an Overtone instrument parameter names."
  [instrument] (map (comp keyword :name) (:params instrument)))

(defn close-synth-gate
  "Closes synth's gate control at time t on metronome."
  [synth {:keys [length time-stamp metronome]}] 
  (at (metronome (+ time-stamp (or length 1))) 
      (ctl synth :gate 0)))

(defn play-derived-event
  "Plays a single event with Overtone instrument specified within it."
  [{:keys [instrument metronome time-stamp] :as event}]
  (assert instrument "Event :instrument key value must be specified.")
  (at (metronome time-stamp)
      (let [inst-params (inst-param-names instrument)
            used-params (select-keys event inst-params)
            synth       (apply instrument (flatten (seq used-params)))]
        (when (some #{:gate} inst-params)
          (close-synth-gate synth event))
        synth)))

(def default-metronome 
  "Default metronome to playback events on."
  (metronome 60))

(def base-event 
  "Provides default set of event value derivations for use with Overtone."
  (assoc event/default-event :metronome default-metronome))

(defn ensure-time-stamped
  "Ensures event has a time stamp. 
  If not present uses next beat on specified or default metronome."
  [{:keys [time-stamp metronome] :as event}] 
  (let [ts (or time-stamp (if metronome (metronome) (default-metronome)))]
    (assoc event :time-stamp ts)))

(def play-event
  "Helper method for playing overtone event maps."
  (comp play-derived-event
        event/derive-vals
        ensure-time-stamped
        #(merge base-event %)))

(defn time-stamp
  [events]
  (let [time-stamps (reductions #(+ %1 (:duration %2)) (default-metronome) events)]
    (map #(assoc %1 :time-stamp %2) events time-stamps)))

(defn schedule
  [[fst & more]]
  (apply-by (:time-stamp fst)
            (play-event fst)
            (when (seq more)
              (apply-by (:time-stamp (first more)) schedule [more]))))

(def play (comp schedule time-stamp))
