(ns coderdojonyc.core)
(use 'overtone.live)
(use 'coderdojonyc.lib)

;; vector of [beat note] pairs. beats are absolute.
(def mario-theme [[0 :E4]
                  [1 :E4]
                  [3 :E4]
                  [5 :C4]
                  [6 :E4]
                  [8 :G4]
                  [12 :G3]
                  [16 :C5]
                  [19 :G4]
                  [22 :E4]
                  [25 :A4]
                  [27 :B4]
                  [29 :Bb4]
                  [30 :A4]
                  [32 :G4]
                  [33.333 :C5]
                  [34.666 :E5]
                  [36 :A5]
                  [38 :F5]
                  [39 :G5]
                  [41 :E5]
                  [43 :E5]
                  [44 :F5]
                  [45 :D5]])

;; this interface could be cleaned up
(defn play-instrument-at [m start-beat instrument beat note]
  (at (m (+ beat start-beat)) (saw-by-note note)))

(defn play-song [score m beat-num]
  (doseq [pair score]
    (let [[beat note] pair]
      (play-instrument-at m beat-num saw-by-note beat note))))

(definst noisey [freq 420 attack 0.004 sustain 0.1 release 0.04 vol 0.15]
  (* (env-gen (lin-env attack sustain release) 1 1 0 1 FREE)
     (white-noise)               ; also have (white-noise) and others...
     vol))

(definst noisey-p [freq 420 attack 0.004 sustain 0.1 release 0.04 vol 0.4]
  (* (env-gen (lin-env attack sustain release) 1 1 0 1 FREE)
     (pink-noise) ; also have (white-noise) and others...
     vol))

(def m (metronome (* 95 4)))

(defn -main []
    (let [start-beat (+ (m) 8)]
       (play-song mario-theme m start-beat)
       (looper m noisey-p (+ start-beat 4) 8 (+ start-beat 44))
       (looper m noisey start-beat 8 (+ start-beat 44))
    )
)
