(ns digitalcomposer.generator.song
 (:require [digitalcomposer.generator.neuralnet :as neuralnet])
 )

(defn nextStep
 "Generates the next step of a song"
 [bpm songKey gene steps insp]
   (int (* 30 (first (neuralnet/propagateNetwork 
         (concat 
                   (into [] (take-last neuralnet/historyLen
                             (concat 
                              (take (- neuralnet/historyLen (count steps)) 
                               (repeat 0))
                              steps)))
                   insp)
         (:hidden gene) (:out gene)))))
)

;; We need to figure out a way to end the song within a consistent range,
;; if songs are too short they aren't interesting and if they are too long
;; users won't listen to the whole song
;; For now terminate when we hit the tonic and have generated > 10 notes
(defn makeSteps
  "Generates the notes in a song"
  [bpm songKey gene]
  (loop [insp (take neuralnet/inspLen (repeatedly #(rand 1)))
         steps []]
        (if (or (and (= 0 (last steps)) (> (count steps) 10)) (> (count steps) 40))
            steps
            (recur insp (conj steps (nextStep bpm songKey gene steps insp)))
        )
  )
;;  [1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0]
)

;; Song format: Melody only (for now)
;; {
;;   token : (unique song id),
;;   bpm : 128,
;;   instrument : [1, .6, .2, .05] (harmonic amplitudes)
;;   songKey : {base: 0-11 (starting at C), notes: [0, 2, 4, 5, 7, 9, 11] (notes in scale)},
;;   steps : [], // where each step is a rest (0) or a # 1 - 21 (7 note scales, 3 octaves)
;; }
(defn getSong
  "Generates a song"
  []
    (let [token 0 bpm 128 instrument [1 0.2 0 0.1 0.3 0.1] 
          songKey {:base 0 :notes [0 2 4 5 7 9 11]}]
      {:token token :bpm bpm :instrument instrument :songKey songKey
       :steps (makeSteps bpm songKey (neuralnet/makeGene))}
    )
)
