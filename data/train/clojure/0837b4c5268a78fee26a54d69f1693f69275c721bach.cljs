(ns music-starter.bach
  (:require [cljs-bach.synthesis :as synth :refer
             [connect-> percussive adsr, adshr sine square sawtooth add gain
              high-pass low-pass white-noise triangle constant envelope
              destination current-time]]
            [leipzig.temperament :as t]
            [leipzig.melody :as m]))


;; everything from here to the next comment line is borrowed from
;; klangmeister, see https://github.com/ctford/klangmeister

(defn bell
  "An imitation bell, made by adding together harmonics."
  [{:keys [pitch]}]
    (let [harmonic (fn [n proportion]
                     (connect->
                       (sine (* n pitch))
                       (percussive 0.01 proportion)
                       (gain 0.05)))]
      (->> (map harmonic [1.0 2.0 3.0 4.1 5.2]
                         [1.0 0.6 0.4 0.3 0.2])
           (apply add))))

(defn high-hat
  "An imitation high-hat, made with white noise."
  [decay]
  (fn [_]
    (connect->
      white-noise
      (percussive 0.01 decay)
      (high-pass 3000)
      (low-pass 4500)
      (gain 0.1))))

(def open-hat (high-hat 0.4))
(def closed-hat (high-hat 0.05))

(defn tom [pitch decay]
  (fn [_]
    (connect->
      (add
        (sawtooth pitch)
        (sawtooth (connect-> (constant pitch) (envelope [0 1] [0.5 0.5]))))
      (low-pass (* 4 pitch))
      (percussive 0.005 decay)
      (gain 0.3))))

(def kick (tom 55 0.1))

(defn organ [note]
  (connect->
    (add (sine (* 0.5 (:pitch note))) (triangle (:pitch note)))
    (low-pass (* 4 (:pitch note)) (connect-> (sine 3) (gain 3)))
    (adsr 0.1 0 1 0.3)
    (gain 0.2)))

(defn marimba [{:keys [pitch]}]
  (connect->
    (add (sine pitch) (sine (inc pitch)) (sine (* 2 pitch)))
    (adshr 0.01 0.2 0.2 0.2 0.3)
    (gain 0.1)))

(defn wah [{:keys [pitch]}]
  (connect->
    (sawtooth pitch)
    (low-pass
      (connect->
        (constant (* 4 pitch))
        (adsr 0.1 0.2 0.4 0.3)) 5)
    (adsr 0.3 0.5 0.8 0.3)
    (gain 0.3)))


(defn play!
  "Take a sequence of notes and play them in an audiocontext. "
  [audiocontext notes]
  (doseq [{:keys [time duration instrument] :as note} notes]
    (let [at-time (+ time (synth/current-time audiocontext))
          synth-instance (-> note
                             (update :pitch t/equal)
                             (dissoc :time)
                             instrument)
          connected-instance (synth/connect synth-instance synth/destination)]
      (connected-instance audiocontext at-time duration))))


;; start of things not stolen directly from klangmeister ---------------

(defonce context (synth/audio-context))

(defn example-melody []
  (->> (m/phrase [1 1 1]
               [0 2 nil [0 2 4]])
       (m/all :instrument bell)))

;; Notes:
;;   - time and duration both seem to be in seconds
(defn example-play []
  (js/console.log "in example-play")
  (let [inst wah]
    (play! context [{:pitch 60 :time (* 0 0.25) :instrument inst :duration 0.25}
                    {:pitch 63 :time (* 1 0.25) :instrument inst :duration 0.25}
                    {:pitch 65 :time (* 2 0.25) :instrument inst :duration 0.25}
                    {:pitch 63 :time (* 3 0.25) :instrument inst :duration 0.25}
                    {:pitch 60 :time (* 4 0.25) :instrument inst :duration 0.25}
                    {:pitch 66 :time (* 5 0.25) :instrument inst :duration 0.25}
                    {:pitch 67 :time (* 6 0.25) :instrument inst :duration 0.25}
                    ])))
