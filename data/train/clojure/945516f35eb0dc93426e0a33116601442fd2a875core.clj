(ns clojure-sound-dojo.core
  (:require [clojure-sound-dojo.player :as player :refer [play save]]
            [clojure-sound-dojo.viewer :as viewer :refer [show]]))

(defn sine [f] (fn [t] (Math/sin (* 2 Math/PI f t))))
;; To get started: (play (sine 440))

(defn square [f] (fn [t] (if (> 0 (Math/sin (* 2 Math/PI f t))) 1.0 -1.0)))

(defn sawtooth [f] (fn [t] (- (* 2 f (mod t (/ 1.0 f))) 1)))

(defn stereo [left right] (fn [t] [(left t) (right t)]))

(defn echo [f d a] (fn [t] (+ (* a (f (- t d))) (* (- 1 a) (f t)))))

(defn lerp [b e t] (+ b (* t (- e b))))

(def instrument-env (adsr 0.03 0.5 0.05 0.2 0.1 0.1))
(def instrument (envelope (sine 440) instrument-env))

(defn clamp [min max f] (fn [t] (let [output (f t)]
                                  (cond (> output max) max
                                        (< output min) min
                                        :else output))))

(defn mix [f1 f2] (fn [t] (+ (f1 t) (f2 t))))

(defn adsr [attack-duration attack-ampl decay-duration sustain-ampl sustain-duration release-duration]
  (fn [t] (cond (> 0 t) 0
                (< t attack-duration) (lerp 0 attack-ampl (/ t attack-duration))
                (< (- t attack-duration) decay-duration) (lerp attack-ampl sustain-ampl (/ (- t attack-duration) decay-duration))
                (< (- t (+ attack-duration decay-duration)) sustain-duration) sustain-ampl
                (< (- t (+ attack-duration decay-duration sustain-duration)) release-duration) (lerp sustain-ampl 0 (/ (- t (+ attack-duration decay-duration sustain-duration)) release-duration))
                :else 0.0)))

(defn envelope [s-fn e-fn] (fn [t] (* (s-fn t) (e-fn t))))

;; Example
(defn -main [& args]
  (let [one (sine 261)
        two (stereo (sine 261) (sine (* 261 2)))]
    (show [0 0.02] one)
    (play [0 1]    one)
    (play          two)
    (save "eg-two.wav" [0 2] two)))




;; --------------------------------------------------------------------------------------
;; (Or, if you really want to mess around with samples instead of nice elegant functions):
(comment
  (-> (player/sample [0 1] (sine 261) :rate 44100)
      (assoc :rate 88200) ; transform the map {:rate n :samples (...)}
      player/play-samples)
  )
