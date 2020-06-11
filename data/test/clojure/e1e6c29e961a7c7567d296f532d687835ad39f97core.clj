(ns noise.core
  (:require [overtone.live :as o]
            [overtone.inst.sampled-piano :refer [sampled-piano]]
            [clojure.core.logic.fd :as fd])
  (:use [clojure.core.logic])
  (:refer-clojure :exclude [==]))

(def cantus-firmus [:d4 :f4 :e4 :d4 :g4 :f4 :a4 :g4 :f4 :e4 :d4])
(pr cantus-firmus)
(defn play-one
  [metro beat instrument [pitch dur]]
  (let [end (+ beat dur)]
    (when pitch
      (let [id (o/at (metro beat) (instrument pitch))]
        (o/at (metro end) (o/ctl id :gate 0))))
    end))

(defn play
  ([metro inst score]
     (play metro (metro) inst score))
  ([metro beat instrument score]
     (let [cur-note (first score)]
       (when cur-note
         (let [next-beat (play-one metro beat instrument cur-note)]
           (o/apply-at (metro next-beat) play metro next-beat instrument
             (next score) []))))))

(play (o/metronome 80) sampled-piano (map vector (map o/note cantus-firmus) (repeat 1)))

(defn abs [n] (max n (- n)))

(defn delta [a b] (- (o/note b) (o/note a)))
(delta :b3 :d4)
(delta :d4 :b3)
(delta :b3 :d#4)

(defn interval
  [d]
  (let [d' (abs d)
        i (cond
            (#{1 2} d') 2
            (#{3 4} d') 3
            (#{5 6} d') 4
            (#{7 8} d') 5
            (#{9 10} d') 6
            (#{11 12} d') 7)]
    (if (pos? d) i (- i))))

(defn intervals
  [notes]
  (for [pair (partition 2 1 notes)]
    (interval (apply delta pair))))

(intervals cantus-firmus)


(def unison ==)



(+ 1 2)
(run* [q]
  (conde
    [(fd/+ 1 2 q)]
    [(fd/+ 1 3 q)]))

(defn interval
  [i]
  (let [inv (abs (- i 9))]
    [i (- 10 inv)]))
