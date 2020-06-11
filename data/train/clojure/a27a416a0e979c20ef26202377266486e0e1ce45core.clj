(ns bhiravi.core
  (:use [clojure.java.io]
        [clojure.string]
        [overtone.live]
        [overtone.inst.sampled-piano]))


(def metro (metronome 120))

(def subject [[:c4 1] [:c#4 1] [:f4 2] [:e4 1] [:c#4 1] [:c4 1] [:c#4 1] [:e4 1] [:c#4 1] [:c4 4]
              [:c#4 1] [:f4 1] [:g4 1] [:g#4 1] [:f4 1] [:g4 2]
              [:g#4 1] [:g4 2] [:f4 1] [:e4 1] [:c#4 1] [:c4 4]
              [:c4 1] [:c#4 1] [:f4 2] [:e4 1] [:c#4 1] [:c4 1] [:c#4 1] [:e4 1] [:c#4 1] [:c4 4]]
  )


(defn play-one
  [metronome beat instrument [pitch dur]]
  (let [end (+ beat dur)]
    (if pitch
      (let [id (at (metronome beat) (instrument (note pitch)))]
        (at (metronome end) (ctl id :gate 0))))
    end))

(defn play
  ([metronome inst score]
   (play metronome (metronome) inst score))
  ([metronome beat instrument score]
   (let [cur-note (first score)]
     (when cur-note
       (let [next-beat (play-one metronome beat instrument cur-note)]
         (apply-at (metronome next-beat) play metronome next-beat instrument
                   (next score) []))))))


(def thi (sample (freesound-path 173283)))
(def thom (sample (freesound-path 173282)))
(def nam (sample (freesound-path 173281)))
(def ta (sample (freesound-path 173280)))
(def tha (sample (freesound-path 173279)))
(def tham (sample (freesound-path 173278)))
(def bheem (sample (freesound-path 173277)))
(def cha (sample (freesound-path 173276)))
(def dheem (sample (freesound-path 173275)))
(def dhin (sample (freesound-path 173274)))


(defn metro-beats [m beat-num]
  (at (m (+ 0 beat-num)) (tha))
  (at (m (+ 1 beat-num)) (thi))
  (at (m (+ 2 beat-num)) (thom))
  (at (m (+ 3 beat-num)) (nam))
  (apply-at (m (+ 4 beat-num)) metro-beats m (+ 4 beat-num) [])
  )

(metro-beats metro (metro))
(play metro sampled-piano subject)
