(ns compojure.player.random
  (:require [alda.lisp :refer :all])
  (:require [alda.now  :as now])
  (:require [compojure.music.constants :as constants])
  (:require [compojure.random.random :as random])
  (:require [clojure.tools.logging :as log]))

(defn randomNoteLength [] (rand-nth constants/noteLengths))

(defn randomOctave [] (rand-nth [(:octave :up) (:octave :down)]))

(defn randomInstrument [] 
  (def instrument (rand-nth constants/instruments))
  (log/info (str "Using instrument " instrument))
  instrument
)

(defn randomKeySignature [] 
  (def keySignature  (if (random/fiftyFifty)
                        (key-signature 
                        [(rand-nth constants/keySignatures) 
                        (rand-nth [:flat :sharp])
                        (rand-nth [:minor :major])])
                        
                        (key-signature 
                        [(rand-nth constants/keySignatures) 
                        (rand-nth [:minor :major])])
                    ))
  (log/info (str "Using key signature " keySignature))
  keySignature
)

(defn randomPan [] (if (random/fiftyFifty) (panning (rand 100))))

(defn randomPan [] (if (random/fiftyFifty) (volume (+ (rand 50) 50))))

(defn playRandomSequence [notes & [tonal]]
  (log/info "Starting voice")
  (def currentTempo (rand 240))
  (log/info (str "Using tempo " currentTempo))
  (tempo! currentTempo) 
 
  (def lengthSubset (take (rand 3) (repeatedly #(randomNoteLength))))

  (defn randomChosenNote [] 
    (if (< 7 (rand 10)) (randomNoteLength) (rand-nth lengthSubset)))

  (defn randomNote [] (rand-nth notes))
  (defn randomPlayedNote [] (note (randomNote) (duration (note-length (randomChosenNote)))))

  (defn randomEvent [] (if (random/fiftyFifty) (randomPlayedNote) (randomOctave)))

  (now/play!
    (part (randomInstrument) 
    (if tonal (randomKeySignature))
          (randomPan)
          (take (rand 500) (repeatedly #(randomEvent)))
)))

(defn addExtraVoice [f notes & [tonal]]
  (loop []
  (Thread/sleep (* 1000 (rand 200)))
  (if (random/fiftyFifty) (f notes tonal)) (recur))
)
