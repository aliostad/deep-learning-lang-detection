(ns tonality.organ
  (:use overtone.core)
  (:require [tonality.tonality :as tonality]
            [tonality.keyboard :as keyboard]
            [tonality.sound :as sound]))

(defn control-parameters
  [program keyboard]
  (reduce
   (fn [parameters [channel level]]
     (if-let [[label growth] (get program channel)]
       (assoc parameters label (growth level))
       parameters))
   {} (:controls keyboard)))

(defn generate-tone
  [program tonality instrument note velocity keyboard]
  (let [tone (tonality note)
        amp (* velocity keyboard/midi-normal)
        control (control-parameters program keyboard)
        parameters (merge-with * {:freq tone :amp amp} control)]
    (println "CONTROL" control)
    (println "PROGRAM" program)
    (println "PARAMETERS" parameters)
    (apply instrument (mapcat identity parameters))))

(defn stop-tone
  [synth]
  (ctl synth :gate 0))

(defn exp-scale
  [min max]
  (let [log-min (Math/log min)
        log-max (Math/log max)
        width (/ (- log-max log-min) 127)]
    (fn [level]
      (let [scaled (+ log-min (* level width))]
        (Math/exp scaled)))))

(defn lin-scale
  [min max]
  (let [width (/ (- max min) 127)]
    (fn [level]
      (+ min (* width level)))))

(defn organ-on
  [this keyboard note velocity]
  (let [synth (generate-tone 
               (:program this) 
               (:tonality this) 
               (:instrument this) 
               note velocity keyboard)]
    (assoc-in this [:playing note] synth)))

(defn organ-off
  [this keyboard note]
  (stop-tone (get (:playing this) note))
  (update-in this [:playing] #(dissoc % note)))

(defn organ-control
  [this keyboard channel level]
  (try
    (if-let [[signal growth] (get (:program this) channel)]
      (let [scale (growth level)]
        (println "SIGNAL" signal level scale channel)
        (ctl (:instrument this) signal scale)
        this))
    (catch Exception e (.printStackTrace e))))

(defrecord TonalityOrgan [tonality instrument program playing]
  keyboard/KeyboardResponse
  (on [this keyboard note velocity]
    (organ-on this keyboard note velocity))
  (off [this keyboard note]
    (organ-off this keyboard note))
  (control [this keyboard channel level]
    (organ-control this keyboard channel level))
  (wheel [this keyboard base detail] this))

(def radium-controls
  [1 7
   82 83 28 29 16 80 18 19
   74 71 81 91 2 10 5 21])

(def emu-controls
  [])

(def organ
  (atom
   (TonalityOrgan.
    tonality/nineteen sound/j8
    {7 [:amp (lin-scale 0 1.0)]}
    {})))

(def pad-organ
  (TonalityOrgan.
   tonality/nineteen sound/j8
   {7 [:amp (lin-scale 0 1.0)]
    1 [:amt (lin-scale 0 1.0)]
    82 [:a (lin-scale 0 3.0)]
    83 [:d (lin-scale 0 3.0)]
    28 [:s (lin-scale 0 3.0)]
    29 [:r (lin-scale 0 3.0)]
    2 [:t (lin-scale 0 20.0)]
    }
   {}))

(def b3-organ
  (TonalityOrgan.
   tonality/nineteen sound/b3
   {7 [:amp (lin-scale 0 1.0)]
    82 [:a (lin-scale 0 3.0)]
    83 [:d (lin-scale 0 3.0)]
    28 [:s (lin-scale 0 3.0)]
    29 [:r (lin-scale 0 3.0)]
    }
   {}))

(def formantax-organ
  (TonalityOrgan.
   tonality/nineteen sound/formantax
   {2 [:amp (lin-scale 0 1.0)]
    27 [:window (exp-scale 0.01 20.0)]
    28 [:formant (exp-scale 0.01 1000.0)]
    83 [:mass (exp-scale (/ 512.0) 1.0)]}
   {}))

(defn keyboard-organ
  []
  (atom []))

