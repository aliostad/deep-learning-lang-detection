(ns cons-beat.core
  (:require [overtone.api])
  (:use [clojure.pprint]
        [overtone.live]
        [overtone.inst.drum]))

(comment
  ; Reference for drums/exploring them
  (ns-instruments 'overtone.inst.drum)
  (pprint (:sdef kick))
)

; Drumset instrument map
(def drumset {
  :crash open-hat
  :closed-hat closed-hat
  :snare snare
  :kick kick})

; Bars, by drum
(def rock-basic {
  :crash      [1 0 0 0 0 0 0 0]
  :closed-hat [1 1 1 1 1 1 1 1]
  :snare      [0 0 1 1 0 0 1 0]
  :kick       [1 0 0 0 1 0 0 0]})
(def rock-4floor {
  :crash      [1 0 0 0 0 0 0 0]
  :closed-hat [1 1 1 1 1 1 1 1]
  :snare      [0 0 1 0 0 0 1 1]
  :kick       [1 0 1 0 1 0 1 0]})

(defn cons-bars
  "Create a score from chunks"
  [& bs]
  (reduce (fn [bars bar] 
            (merge-with concat bars bar))
          {} 
          bs))

(defn rep-bar
  "Repeat bars, think :| bar |:"
  ([reps bar]
    (apply cons-bars (repeat reps bar)))
  ([bar]
    (rep-bar 2 bar)))

; Get seperator time from bpm
(def bpm #(* 10 %))

(defn instseq
  "Play a sequence of notes for given instrument"
  [time notes sep instr]
  (let [note (first notes)]
    (when note
      (if (= note 1)
        (at time (instr))))
    (let [next-time (+ time sep)]
      (apply-at next-time 
                instseq 
                [next-time (rest notes) sep instr]))))

(defn drumseq
  "Coordinate a group of drum sequences"
  [seqs drumset bpm]
  (let [start (now)]
    (map #(instseq start (second %) bpm (get drumset (first %)))
          seqs)))

(comment
  ; Examples
  (cons-bars rock-a rock-b)
  (instseq (now) [1 0 1 0 1 0 1 1] (bpm 60) (get drumset :kick))
  (def abab (rep-bar 2 (cons-bars rock-4floor rock-basic)))
  (drumseq abab drumset (bpm 60))
)
(def abab (rep-bar 2 (cons-bars rock-4floor rock-basic)))
(drumseq abab drumset (bpm 60))
