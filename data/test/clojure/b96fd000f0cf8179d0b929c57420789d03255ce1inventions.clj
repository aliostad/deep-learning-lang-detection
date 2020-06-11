(ns sounds.inventions
  (:use [overtone.live])
  (:require [sounds.bwv772 :as cmaj]))

(def v1-theme1 [[nil 1/4] [:c4 1/4] [:d4 1/4] [:e4 1/4] [:f4 1/4] [:d4 1/4] [:e4 1/4] [:c4 1/4]])
(def v1-cpt1   [[:g4 1/2] [:c5 1/2] [:b4 1/2] [:c5 1/2]])
(def v1-theme2 [[:d5 1/4] [:g4 1/4] [:a4 1/4] [:b4 1/4] [:c5 1/4] [:a4 1/4] [:b4 1/4] [:g4 1/4]])
(def v1-cpt2   [[:d5 1/2] [:g5 1/2] [:f5 1/2] [:g5 1/2]])
(def v1-theme3 [[:e5 1/4] [:a5 1/4] [:g5 1/4] [:f5 1/4] [:e5 1/4] [:g5 1/4] [:f5 1/4] [:a5 1/4]
                [:g5 1/4] [:f5 1/4] [:e5 1/4] [:d5 1/4] [:c5 1/4] [:e5 1/4] [:d5 1/4] [:f5 1/4]
                [:e5 1/4] [:d5 1/4] [:c5 1/4] [:b4 1/4] [:a4 1/4] [:c5 1/4] [:b4 1/4] [:d5 1/4]
                [:c5 1/4] [:b4 1/4] [:a4 1/4] [:g4 1/4] [:f#4 1/4] [:a4 1/4] [:g4 1/4] [:b4 1/4]])
(def v1-cpt3   [[:a4 1/2] [:d4 1/2] [:c5 3/4] [:d5 1/4]])
(def v1-theme4 [[:b4 1/4] [:a4 1/4] [:g4 1/4] [:f#4 1/4] [:e4 1/4] [:g4 1/4] [:f#4 1/4] [:a4 1/4]
                [:g4 1/4] [:b4 1/4] [:a4 1/4] [:c5 1/4] [:b4 1/4] [:d5 1/4] [:c5 1/4] [:e5 1/4]
                [:d5 1/4] [:b4 1/8] [:c5 1/8] [:d5 1/4] [:g5 1/4] [:b4 1/2] [:a4 1/4] [:g4 1/4]])
(def v1-cpt4   [[:g4 1/2] [nil 3/2]])
(def v1-theme5 [[nil 1/4] [:g4 1/4] [:a4 1/4] [:b4 1/4] [:c5 1/4] [:a4 1/4] [:b4 1/4] [:g4 1/4]
                [:f#4 1/2] [nil 3/2]])
(def v1-theme6 [[nil 1/4] [:a4 1/4] [:b4 1/4] [:c5 1/4] [:d5 1/4] [:b4 1/4] [:c5 1/4] [:a4 1/4]
                [:b4 1/2] [nil 3/2]])
(def v1-theme7 [[nil 1/4] [:d5 1/4] [:c5 1/4] [:b4 1/4] [:a4 1/4] [:c5 1/4] [:b4 1/4] [:d5 1/4]
                [:c5 1/2] [nil 3/2]])
(def v1-theme8 [[nil 1/4] [:e5 1/4] [:d5 1/4] [:c5 1/4] [:b4 1/4] [:d5 1/4] [:c#5 1/4] [:e5 1/4]])
(def v1-cpt8   [[:d5 1/2] [:c#5 1/2] [:d5 1/2] [:e5 1/2] [:f5 1/2] [:a4 1/2] [:b4 1/2] [:c5 1/2]
                [:d5 1/2] [:f#4 1/2] [:g#4 1/2] [:a4 1/2] [:b4 1/2] [:c5 1/2] [:d5 1]])
(def v1-theme9 [[:d5 1/4] [:e4 1/4] [:f#4 1/4] [:g#4 1/4] [:a4 1/4] [:f#4 1/4] [:g#4 1/4] [:e4 1/4]
                [:e5 1/4] [:c5 1/4] [:d5 1/4] [:e5 1/4] [:d5 1/4] [:c5 1/4] [:b4 1/4] [:d5 1/4]
                [:c5 1/4] [:a5 1/4] [:g#5 1/4] [:b5 1/4] [:a5 1/4] [:e5 1/4] [:f5 1/4] [:d5 1/4]
                [:g#4 1/4] [:f5 1/4] [:e5 1/4] [:d5 1/4] [:c5 1/2] [:b4 1/4] [:a4 1/4]])
(def v1-theme10 [[:a4 1/4] [:a5 1/4] [:g5 1/4] [:f5 1/4] [:e5 1/4] [:g5 1/4] [:f5 1/4] [:a5 1/4] [:g5 2]])
(def v1-theme11 [[:g5 1/4] [:e5 1/4] [:f5 1/4] [:g5 1/4] [:a5 1/4] [:f5 1/4] [:g5 1/4] [:e5 1/4] [:f5 2]])
(def v1-theme12 [[:f5 1/4] [:g5 1/4] [:f5 1/4] [:e5 1/4] [:d5 1/4] [:f5 1/4] [:e5 1/4] [:g5 1/4] [:f5 2]])
(def v1-theme13 [[:f5 1/4] [:d5 1/4] [:e5 1/4] [:f5 1/4] [:g5 1/4] [:e5 1/4] [:f5 1/4] [:d5 1/4] [:e5 2]])
(def v1-theme14 [[:e5 1/4] [:c5 1/4] [:d5 1/4] [:e5 1/4] [:f5 1/4] [:d5 1/4] [:e5 1/4] [:c5 1/4]
                 [:d5 1/4] [:e5 1/4] [:f5 1/4] [:g5 1/4] [:a5 1/4] [:f5 1/4] [:g5 1/4] [:e5 1/4]
                 [:f5 1/4] [:g5 1/4] [:a5 1/4] [:b5 1/4] [:c6 1/4] [:a5 1/4] [:b5 1/4] [:g5 1/4]])
(def v1-cpt14   [[:c6 1/2] [:g5 1/2] [:e5 1/2] [:d5 1/4] [:c5 1/4]])
(def v1-theme15 [[:c5 1/4] [:bb4 1/4] [:a4 1/4] [:g4 1/4] [:f4 1/4] [:a4 1/4] [:g4 1/4] [:bb4 1/4]
                 [:a4 1/4] [:b4 1/4] [:c5 1/4] [:e4 1/4] [:d4 1/4] [:c5 1/4] [:f4 1/4] [:b4 1/4]])



(def v2-delay  [[nil 2]])
(def v2-theme1 [[nil 1/4] [:c3 1/4] [:d3 1/4] [:e3 1/4] [:f3 1/4] [:d3 1/4] [:e3 1/4] [:c3 1/4]])
(def v2-cpt1   [[:g3 1/2] [:g2 1/2] [nil 1]])
(def v2-theme2 [[nil 1/4] [:g3 1/4] [:a3 1/4] [:b3 1/4] [:c4 1/4] [:a3 1/4] [:b3 1/4] [:g3 1/4]])
(def v2-cpt2   [[:c4 1/2] [:b3 1/2] [:c4 1/2] [:d4 1/2] [:e4 1/2] [:g3 1/2] [:a3 1/2] [:b3 1/2]
                [:c4 1/2] [:e3 1/2] [:f#3 1/2] [:g3 1/2] [:a3 1/2] [:b3 1/2] [:c4 1]])
(def v2-theme3 [[:c4 1/4] [:d3 1/4] [:e3 1/4] [:f#3 1/4] [:g3 1/4] [:e3 1/4] [:f#3 1/4] [:d3 1/4]])
(def v2-cpt3   [[:g3 1/2] [:b2 1/2] [:c3 1/2] [:d3 1/2] 
                [:e3 1/2] [:f#3 1/2] [:g3 1/2] [:e3 1/2] [:b2 3/4] [:c3 1/4] [:d3 1/2] [:d2 1/2]])
(def v2-theme4 [[nil 1/4] [:g2 1/4] [:a2 1/4] [:b2 1/4] [:c3 1/4] [:a2 1/4] [:b2 1/4] [:g2 1/4]])
(def v2-cpt4   [[:d3 1/2] [:g3 1/2] [:f#3 1/2] [:g3 1/2]])
(def v2-theme5 [[:a3 1/4] [:d3 1/4] [:e3 1/4] [:f#3 1/4] [:g3 1/4] [:e3 1/4] [:f#3 1/4] [:d3 1/4]])
(def v2-cpt5   [[:a3 1/2] [:d4 1/2] [:c4 1/2] [:d4 1/2]])
(def v2-theme6 [[:g3 1/4] [:g4 1/4] [:f4 1/4] [:e4 1/4] [:d4 1/4] [:f4 1/4] [:e4 1/4] [:g4 1/4]])
(def v2-cpt6   [[:f4 1/2] [:e4 1/2] [:f4 1/2] [:d4 1/2]])
(def v2-theme7 [[:e4 1/4] [:a4 1/4] [:g4 1/4] [:f4 1/4] [:e4 1/4] [:g4 1/4] [:f4 1/4] [:a4 1/4]])
(def v2-cpt7   [[:g4 1/2] [:f4 1/2] [:g4 1/2] [:e4 1/2]])
(def v2-theme8 [[:f4 1/4] [:bb4 1/4] [:a4 1/4] [:g4 1/4] [:f4 1/4] [:a4 1/4] [:g4 1/4] [:bb4 1/4]
                [:a4 1/4] [:g4 1/4] [:f4 1/4] [:e4 1/4] [:d4 1/4] [:f4 1/4] [:e4 1/4] [:g4 1/4]
                [:f4 1/4] [:e4 1/4] [:d4 1/4] [:c4 1/4] [:b3 1/4] [:d4 1/4] [:c4 1/4] [:e4 1/4]
                [:d4 1/4] [:c4 1/4] [:b3 1/4] [:a3 1/4] [:g#3 1/4] [:b3 1/4] [:a3 1/4] [:c4 1/4]])
(def v2-cpt8   [[:b3 1/2] [:e3 1/2] [:d4 3/4] [:e4 1/4] [:c4 1/4] [:b3 1/4] [:a3 1/4] [:g3 1/4]
                [:f#3 1/4] [:a3 1/4] [:g#3 1/4] [:b3 1/4] [:a3 1/4] [:c4 1/4] [:b3 1/4] [:d4 1/4]
                [:c4 1/4] [:e4 1/4] [:d4 1/4] [:f4 1/4] [:e4 1/2] [:a3 1/2] [:e4 1/2] [:e3 1/2]
                [:a3 1/2] [:a2 1/2] [nil 1]])
(def v2-theme9 [[nil 1/4] [:e4 1/4] [:d4 1/4] [:c4 1/4] [:b3 1/4] [:d4 1/4] [:c4 1/4] [:e4 1/4] [:d4 2]])
(def v2-theme10 [[:d4 1/4] [:a3 1/4] [:b3 1/4] [:c4 1/4] [:d4 1/4] [:b3 1/4] [:c4 1/4] [:a3 1/4] [:b3 2]])
(def v2-theme11 [[:b3 1/4] [:d4 1/4] [:c4 1/4] [:b3 1/4] [:a3 1/4] [:c4 1/4] [:b3 1/4] [:d4 1/4] [:c4 2]])
(def v2-theme12 [[:c4 1/4] [:g3 1/4] [:a3 1/4] [:bb3 1/4] [:c4 1/4] [:a3 1/4] [:bb3 1/4] [:g3 1/4]])
(def v2-cpt12   [[:a3 1/2] [:bb3 1/2] [:a3 1/2] [:g3 1/2] [:f3 1/2] [:d4 1/2] [:c4 1/2] [:bb3 1/2]
                 [:a3 1/2] [:f4 1/2] [:e4 1/2] [:d4 1/2]])
(def v2-theme13 [[:e4 1/4] [:d3 1/4] [:e3 1/4] [:f3 1/4] [:g3 1/4] [:e3 1/4] [:f3 1/4] [:d3 1/4]])
(def v2-cpt13   [[:e3 1/2] [:c3 1/2] [:d3 1/2] [:e3 1/2] [:f3 1/4] [:d3 1/4] [:e3 1/4] [:f3 1/4] [:g3 1/2] [:g2 1/2]])

n
(def voice1 (concat v1-theme1 v1-cpt1 v1-theme2 v1-cpt2 v1-theme3 v1-cpt3 v1-theme4 v1-cpt4 v1-theme5 v1-theme6 v1-theme7 v1-theme8 v1-cpt8 v1-theme9 v1-theme10 v1-theme11 v1-theme12 v1-theme13 v1-theme14 v1-cpt14 v1-theme15))
(def voice2 (concat v2-delay v2-theme1 v2-cpt1 v2-theme2 v2-cpt2 v2-theme3 v2-cpt3 v2-theme4 v2-cpt4 v2-theme5 v2-cpt5 v2-theme6 v2-cpt6 v2-theme7 v2-cpt7 v2-theme8 v2-cpt8 v2-theme9 v2-theme10 v2-theme11 v2-theme12 v2-cpt12 v2-theme13 v2-cpt13))


;; nil works as rest

;; need to abstract out midi vs freq in sequencing

(defn note->hz 
  [pitch]
  (midi->hz (note pitch)))

(defn play-one-midi
  [metronome beat instrument [pitch dur]]
  (let [end (+ beat dur)]
    (if pitch
      (let [id (at (metronome beat) (instrument (note pitch)))]
        (at (metronome end) (ctl id :gate 0))))
    end))

(defn play-midi
  ([metronome inst score]
     (play metronome (metronome) inst score))
  ([metronome beat instrument score]
     (let [cur-note (first score)]
       (when cur-note
         (let [next-beat (play-one-midi metronome beat instrument cur-note)]
           (apply-at (metronome next-beat) play-midi metronome next-beat instrument
                     (next score) []))))))

(defn play-one-freq
  [metronome beat instrument [pitch dur]]
  (let [end (+ beat dur)]
    (if pitch
      (let [id (at (metronome beat) (instrument (note->hz pitch)))]
        (at (metronome end) (ctl id :gate 0))))
    end))

(defn play-freq
  ([metronome inst score]
     (play-freq metronome (metronome) inst score))
  ([metronome beat instrument score]
     (let [cur-note (first score)]
       (when cur-note
         (let [next-beat (play-one-freq metronome beat instrument cur-note)]
           (apply-at (metronome next-beat) play-freq metronome next-beat instrument
                     (next score) []))))))


(defn play-voices
  [playfn metronome instrument voice1 voice2]
  (playfn metronome instrument voice1)
  (playfn metronome instrument voice2))
