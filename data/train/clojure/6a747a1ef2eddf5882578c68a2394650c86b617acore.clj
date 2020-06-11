(ns tones.core)
(use 'overtone.live)
(use 'overtone.core)

;;load the piano
(use 'overtone.inst.piano)


;;play the c note
;;(piano)

;;play another
;;(piano (node :db4)

;;(definst foo [] (saw 220))
;;(kill 4)
;;(kill foo)


;;(def subject [[:d4 2] [:a4 2] [:f4 2] [:d4 2] [:c#4 2] [:d4 1] [:e4 1]
;;              [:f4 2.5] [:g4 0.5] [:f4 0.5] [:e4 0.5] [:d4 1]])

(def metro (metronome 120))

;;gives current beat
;(metro)
;;gives time for given beat
;;(metro 45)



(defn play-note
  [metronome beat instrument [note dur]]
  (let [end (+ beat dur)]
    (if pitch
      (let [id (at (metronome beat) (instrument note))]
        (at (metronome end) (ctl id :gate 0))))
    end))


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
         (let [next-beat (play-note metronome beat instrument cur-note)]
           (apply-at (metronome next-beat) play metronome next-beat instrument
             (next score) []))))))

;;just a scale run at a given inteval
(defn scale-run [scale-notes intv]
  (map (fn [n] [n intv])
       scale-notes))

(defn random-scale-run [scale-notes intv]
  (map (fn [n]
         (let [r (rand-int (count scale-notes))]
           [(nth scale-notes r) intv]))
       scale-notes))


(defn pick-rand [left]
  (let* [b '(0.5  0.25 )
         r (rand-int (count b))
         l (nth b r)]
        (if (= left 0.25)
          0.25
          (if (> l left)
            (pick-rand left)
            l))))

(defn rec-build [acc left]
  (if (<= left 0)
    acc
    (let [rand (pick-rand left)]
      (rec-build (cons rand acc)
                 (- left rand)))))

(defn break-measure [measures timing]
  (rec-build (list)
             (* measures timing)))

(defn improv-on-beats [scale-notes beats]
  (map (fn [n]
         (let [r (rand-int (count scale-notes))]
           [(nth scale-notes r) n]))
       beats))

;;(improv-on-beats (scale :c4 :major) (break-measure 4 4))

;;(play metro piano (random-scale-run (scale :c4 :mixolydian) 0.25))

;;(improv-on-beats (scale :c4 :major) (break-measure 4 4))



;;(play metro piano (improv-on-beats (scale :c4 :dorian) (break-measure 12 4)))



;solo on a tune ...



(let
    [common (break-measure 1 4)
     common2 (break-measure 1 4)]
  (play metro
        piano
        (concat
         (improv-on-beats (scale :d4 :dorian) common)
         (improv-on-beats (scale :d4 :dorian) common2)
         (improv-on-beats (scale :g4 :mixolydian) common)
         (improv-on-beats (scale :g4 :mixolydian) common2)
         (improv-on-beats (scale :c4 :major) common)
         (improv-on-beats (scale :c4 :major) common2))))

;; https://github.com/overtone/overtone/blob/8b60f2db204eac368b912a03b49fb5500eddb5ef/src/overtone/music/pitch.clj#L239
;; (def SCALE
;;   (let [ionian-sequence [2 2 1 2 2 2 1]
;;         hex-sequence [2 2 1 2 2 3]
;;         pentatonic-sequence [3 2 2 3 2]
;;         rotate (fn [scale-sequence offset]
;;                  (take (count scale-sequence)
;;                        (drop offset (cycle scale-sequence))))]
;;     {:diatonic ionian-sequence
;;      :ionian (rotate ionian-sequence 0)
;;      :major (rotate ionian-sequence 0)
;;      :dorian (rotate ionian-sequence 1)
;;      :phrygian (rotate ionian-sequence 2)
;;      :lydian (rotate ionian-sequence 3)
;;      :mixolydian (rotate ionian-sequence 4)
;;      :aeolian (rotate ionian-sequence 5)
;;      :minor (rotate ionian-sequence 5)
;;      :locrian (rotate ionian-sequence 6)
;;      :hex-major6 (rotate hex-sequence 0)
;;      :hex-dorian (rotate hex-sequence 1)
;;      :hex-phrygian (rotate hex-sequence 2)
;;      :hex-major7 (rotate hex-sequence 3)
;;      :hex-sus (rotate hex-sequence 4)
;;      :hex-aeolian (rotate hex-sequence 5)
;;      :minor-pentatonic (rotate pentatonic-sequence 0)
;;      :yu (rotate pentatonic-sequence 0)
;;      :major-pentatonic (rotate pentatonic-sequence 1)
;;      :gong (rotate pentatonic-sequence 1)
;;      :egyptian (rotate pentatonic-sequence 2)
;;      :shang (rotate pentatonic-sequence 2)
;;      :jiao (rotate pentatonic-sequence 3)
;;      :pentatonic (rotate pentatonic-sequence 4) ;; historical match
;;      :zhi (rotate pentatonic-sequence 4)
;;      :ritusen (rotate pentatonic-sequence 4)
;;      :whole-tone [2 2 2 2 2 2]
;;      :whole [2 2 2 2 2 2]
;;      :chromatic [1 1 1 1 1 1 1 1 1 1 1 1]
;;      :harmonic-minor [2 1 2 2 1 3 1]
;;      :melodic-minor-asc [2 1 2 2 2 2 1]
;;      :hungarian-minor [2 1 3 1 1 3 1]
;;      :octatonic [2 1 2 1 2 1 2 1]
;;      :messiaen1 [2 2 2 2 2 2]
;;      :messiaen2 [1 2 1 2 1 2 1 2]
;;      :messiaen3 [2 1 1 2 1 1 2 1 1]
;;      :messiaen4 [1 1 3 1 1 1 3 1]
;;      :messiaen5 [1 4 1 1 4 1]
;;      :messiaen6 [2 2 1 1 2 2 1 1]
;;      :messiaen7 [1 1 1 2 1 1 1 1 2 1]
;;      :super-locrian [1 2 1 2 2 2 2]
;;      :hirajoshi [2 1 4 1 4]
;;      :kumoi [2 1 4 2 3]
;;      :neapolitan-major [1 2 2 2 2 2 1]
;;      :bartok [2 2 1 2 1 2 2]
;;      :bhairav [1 3 1 2 1 3 1]
;;      :locrian-major [2 2 1 1 2 2 2]
;;      :ahirbhairav [1 3 1 2 2 1 2]
;;      :enigmatic [1 3 2 2 2 1 1]
;;      :neapolitan-minor [1 2 2 2 1 3 1]
;;      :pelog [1 2 4 1 4]
;;      :augmented2 [1 3 1 3 1 3]
;;      :scriabin [1 3 3 2 3]
;;      :harmonic-major [2 2 1 2 1 3 1]
;;      :melodic-minor-desc [2 1 2 2 1 2 2]
;;      :romanian-minor [2 1 3 1 2 1 2]
;;      :hindu [2 2 1 2 1 2 2]
;;      :iwato [1 4 1 4 2]
;;      :melodic-minor [2 1 2 2 2 2 1]
;;      :diminished2 [2 1 2 1 2 1 2 1]
;;      :marva [1 3 2 1 2 2 1]
;;      :melodic-major [2 2 1 2 1 2 2]
;;      :indian [4 1 2 3 2]
;;      :spanish [1 3 1 2 1 2 2]
;;      :prometheus [2 2 2 5 1]
;;      :diminished [1 2 1 2 1 2 1 2]
;;      :todi [1 2 3 1 1 3 1]
;;      :leading-whole [2 2 2 2 2 1 1]
;;      :augmented [3 1 3 1 3 1]
;;      :purvi [1 3 2 1 1 3 1]
;;      :chinese [4 2 1 4 1]
;;      :lydian-minor [2 2 2 1 1 2 2]}))

;;sample at 1 beat per note
;;(play metro piano (scale-run (scale :Bb3 :mixolydian) 1))

;;sample at 2 beat per note
;;(play metro piano (scale-run (scale :Bb3 :minor) 0.5))

(defn  rotate-scale [scale-sequence offset]
                  (take (count scale-sequence)
                        (drop offset (cycle scale-sequence))))
