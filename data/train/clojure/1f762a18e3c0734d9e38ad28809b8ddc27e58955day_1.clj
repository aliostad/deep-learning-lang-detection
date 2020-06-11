(ns novembart.day-1
  (:use overtone.live))

(def note-frequencies
  {:c4 261.63
   :d4 293.66
   :e4 329.63
   :f4 349.23
   :g4 392.00
   :a4 440.00
   :b4 493.83})

(defn notes-generator
  []
  (let [notes (keys note-frequencies)]
    (cons
     (rand-nth notes)
     (lazy-seq (notes-generator)))))

(definst saw-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4] 
  (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE)
     (saw freq)
     vol))

(defn play-song [notes instrument]    
  (let [time (now)
        times (range 0 (count notes))]
        (map #(at (+ time (* %2 500)) (instrument (%1 note-frequencies))) notes times)  
        ))

(defn day-1-song
  []
  (let [notes (take 120 (notes-generator))]
    (play-song notes saw-wave)
    )
  )



(day-1-song)

