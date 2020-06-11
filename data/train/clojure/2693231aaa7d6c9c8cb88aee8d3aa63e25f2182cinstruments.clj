(ns org.musicbox.instruments
  (:gen-class)
  (:import [java.util Random])
  (:use [org.musicbox.composer]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Composer Tools
	 
(defn random-seq 
  [length-pool element-pool]
  (let [rnd (fn [coll] (nth coll (rand-int (count coll))))]
    (take (rnd length-pool) (iterate (fn [_] (rnd element-pool)) (rnd element-pool)))))

(defn gen-pipe
  "Build a semi-random grammar"
  [depth children]
  [{:theme (random-seq (range 4 6) (range 1 4))
    :rhyme  (random-seq (range 2 4) (range 1 4))
    :harmony (random-seq (range 2 5) (take 12 pitch-table))
    :emphasis (random-seq (range 2 4) (range 4 6))
    :instrument false
    :children (if (> depth 0)
		(gen-pipe (dec depth) children)
		children)}])

(defn gen-mask
  [density children]
  [{:theme (random-seq [1] (range 1 4))
    :rhyme []
    :harmony (random-seq (range 2 4) (cons "R" (take density (repeat "A0"))))
    :emphasis []
    :instrument false
    :children children}])

(defn gen-voice
  "Gen a random voice, or partially random"
  [instrument octave children]
  [{:theme (random-seq (range 2 4) (range 1 6))
    :rhyme (random-seq (range 2 4) (range 1 5))
    :harmony (nth [["F#3" "E3" "E3" "F#3"] 
                   ["E3" "F#3" "E3" "F#3"] 
                   ["E3" "Eb3" "F#3" "E3" "G#3"] 
                   ["Eb3" "F#3" "E3" "G#3" "F#3"] 
                   ["F#3" "E3" "G#3" "F#3" "G#3"] 
                   ["E3" "B2" "F#3" "E3"] 
                   ["F#3" "E3" "G#3" "F#3"] 
                   ["E3" "G#3" "F#3" "G#3"] 
                   ["Eb3" "F#3" "E3" "G#3"] 
                   ["E3" "Eb3" "F#3" "E3"]]
                  (rand-int 8))
    :emphasis (random-seq (range 2 4) (range 3 5))
    :instrument instrument
    :children children}])

(defn gen-bridge
  [children]
  [{:theme (random-seq [1] (range 1 5))
    :rhyme []
    :harmony ["A5"]
    :emphasis []
    :instrument false
    :children children}])

(defn gen-drumline
  [children]
  [{:theme (random-seq (range 2 4) (range 1 4))
    :rhyme (random-seq (range 2 4) (range 1 4))
    :harmony (random-seq (range 2 4) ["[Snare]"])
    :emphasis (random-seq (range 2 4) (range 5 6))
    :instrument true
    :children children}])

(defn gen-drums
  []
  (gen-bridge (gen-mask 2 (gen-drumline []))))

(defn gen-piano
  []
  (gen-bridge (concat (gen-mask 2 (gen-voice "Synth_Bass_2" 6 (concat (gen-mask 3 (gen-voice "Synth_Bass_2" 7 []))
								      (gen-mask 3 (gen-mask 2 (gen-voice "Synth_Bass_2" 7 []))))))
		      (gen-mask 2 (gen-pipe 0 (gen-mask 2 (gen-voice "Synth_Bass_2" 5 [])))))))
 
(defn gen-song
  []
  (let [common-voice (first (gen-voice "Synth_Bass_2" 4 []))]
    (concat (gen-mask 3 (vector (assoc common-voice
                                            :children (concat (gen-mask 2 (gen-voice "Synth_Bass_2" 5 []))
                                                              (gen-mask 2 (gen-mask 2 (gen-voice "Synth_Bass_2" 3 []))))
                                            :instrument "Synth_Bass_2")))
            (gen-mask 4 (vector (assoc common-voice
                                            :children (gen-voice "Synth_Bass_2" 4 [])
                                            :instrument false))))))

