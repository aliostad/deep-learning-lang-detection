(ns asdf.metronomes)
(use 'overtone.live)

(use 'overtone.inst.drum)
(kick)
(defn looper  [nome sound]
  (let  [beat  (nome)]
    (at  (nome beat)  (sound))
    (apply-by  (nome  (inc beat)) looper nome sound  [])))
;; (looper (metronome 80) kick2)
;; (looper (metronome 100) kick3)
;; (looper (metronome 500) kick4)

(use 'overtone.inst.sampled-piano)

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
(def subject [[:d4 3] [:d4 2] [nil 3] [:a4 4] [:a4 3]])

(definst sin-wave [freq 440 attack 0.01 sustain 0.5 release 0.1 vol 0.7]
  (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE)
     (sin-osc freq)
     vol))

(defn play-chord
  ([a-chord]
    (play-chord a-chord 0.5))
  ([a-chord length]
    (doseq [note a-chord] (sampled-piano :note note :sustain length))))

(defonce metro (metronome 120))
(defn chord-progression-beat [m beat-num]
  (at (m (+ 0 beat-num)) (play-chord (chord :C4 :major) 0.7))
  (at (m (+ 2 beat-num)) (play-chord (chord :G3 :major)))
  (at (m (+ 5 beat-num)) (play-chord (chord :G3 :major)))
  (at (m (+ 6 beat-num)) (play-chord (chord :F3 :major)))
  (at (m (+ 7 beat-num)) (play-chord (chord :A3 :minor)))
  (at (m (+ 8 beat-num)) (play-chord (chord :A3 :minor) 1))
  (at (m (+ 10 beat-num)) (play-chord (chord :F3 :major) 1.5))
  (apply-at (m (+ 13 beat-num)) chord-progression-beat m (+ 13 beat-num) [])
)

(stop)
(chord-progression-beat metro (metro))
(take 10 (iterate (fn [x] (metro)) 1))

(sampled-piano (note :C3))
(sampled-piano (note :G#2))

(def scale-degrees [:vi :vii :i+ :_ :vii :_ :i+ :vii :vi :_ :vii :_])
(def pitches (degrees->pitches scale-degrees :dorian :C4))

(defn play [time notes sep]
  (let [note (first notes)]
    (when note
      (at time (saw (midi->hz note))))
    (let [next-time (+ time sep)]
      (apply-at next-time play [next-time (rest notes) sep]))))
(play (now) [200 400 600] 20)
(stop)

;; Pack the piano in an envelope
