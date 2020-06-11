(ns music-machine.instruments
  (:use [clojure.string :only [lower-case]]
        overtone.live))

(definst detuned [freq 440 volume 1.0 duration 1.0]
  (let [src (mix (saw (* freq [0.9999 1])))
        env (env-gen (perc 0.05 duration) :action FREE)]
    (* src volume env)))

(definst bass [freq 440 volume 1.0 duration 1.0]
  (let [src (sin-osc (* (* 2 freq) [0.9999 1 0.5 0.5001]))
        env (env-gen (perc 0.05 duration) :action FREE)]
    (lpf (* src volume env) 150)))

(definst guitar [freq 440 volume 1.0 duration 1.0]
  (let [freq-mod (* (sin-osc 2.5) 3)
        src1 (sin-osc (* (* (+ freq freq-mod) 2) [0.9999 1 1.0001]))
        src2 (lf-tri freq)
        env (env-gen (perc 0.05 duration) :action FREE)]
    (* (+ src1 src2) volume env)))

(definst drums [volume 1.0 duration 1.0]
  (let [src (white-noise)
        env (env-gen (perc 0.0001 0.3) :action FREE)]
    (* src volume env)))

(def standard-instruments {:piano detuned
                           :bass bass
                           :guitar guitar})

(defn track-name->instrument-type [name]
  ;; TODO: more better
  (when name
    (cond (= name "Electric Guitar") :guitar
          :else (keyword (lower-case name)))))
