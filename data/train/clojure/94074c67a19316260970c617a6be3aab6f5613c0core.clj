(ns jam1.core
  (:use [overtone.core]
        [overtone.inst.sampled-piano]
        [overtone.inst.drum]
        [overtone.inst.synth]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;This is a partial recration of Andrew Sorensen's OSCON 2014 piece
;;in overtone.
;;the original video: https://www.youtube.com/watch?v=yY1FSsUV-8c
;;
;;I borrowed alot including the fmsynth and play functions
;;from Roger Allen's version at:
;;https://github.com/rogerallen/explore_overtone/blob/master/src/explore_overtone/sorensen_oscon_2014.clj
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsynth fmsynth
  [note 60 divisor 1.0 depth 1.0
   attack 0.05 release 0.05 ;; envelope times
   duration 1.0 level 1.0 out-bus 0]
  (let [carrier   (midicps note)
        modulator (/ carrier divisor)
        S         (- duration attack release)
        mod-env   (env-gen (lin attack 0 (+ S release)))
        amp-env   (env-gen (lin attack S release) :action FREE)
        osc1      (* mod-env (* carrier depth) (sin-osc modulator))]
    (out out-bus (pan2 (* amp-env (sin-osc (+ carrier osc1)))))))

(def fmsynth1 (partial fmsynth :attack 0.01 :release 0.3))

(defn quantize
  [midi field]
  (let [nt (note midi)]
    (if (some #{nt} field)
      nt
      (loop [x 1]
        (let [up (int (+ nt x))
              down (int (- nt x))]
          (cond
           (some #{up} field) up
           (some #{down} field) down
           :else (recur (inc x))))))))

(def scl (scale-field :E :aeolian))

(def metro (metronome 110))

(defn play-sample
  "takes the beat recorded-sample note volume and duration and plays the note for that duration"
  [beat instrument note level dur]
  (let [instrument (at (metro beat) (instrument :note note :level level))]
    (at (metro (+ beat dur)) (ctl instrument :gate 0))))

(defn play-synth
  [beat synth note level dur]
  (let [synth-duration (* dur (/ (metro-tick metro) 1000))]
    (at (metro beat) (synth :note note :duration synth-duration :level level))))


(def metro (metronome 110))

(def root (atom :E2))

(defn right-hand
  [beat dur]
  (play-sample beat
        sampled-piano
        (quantize (int (cosr beat (cosr beat 3 5 2) (+ (note @root) 24) 3/7)) scl)
        (cosr beat 0.15 0.5 3/7)
        (* 2.0 dur))
  (if (< (rand) 0.4)
    (play-synth beat
           fmsynth1
           (quantize (int (+ 7 (cosr beat (cosr beat 3 5 2) (+ (note @root) 24) 3/7))) scl)
           (cosr beat 0.15 0.6 3/7)
           (* 0.2 dur)))
      (apply-by (metro (+ beat (* 0.5 dur))) #'right-hand [(+ beat dur) dur]))


(defn left-hand
  [beat notes durations]
  (let [n (first notes)
        dur (first durations)]
    (when (= 0 (mod (metro) 8))
      (reset! root (rand-nth
                    (remove
                     #(= @root %) '(:E2 :D2 :C2)))))
    (play-sample beat sampled-piano (note n) 0.5 dur)
    (play-sample (+ 1/2 beat) sampled-piano (note @root) 0.45 dur)
    (apply-by (metro (+ beat (* 0.5 dur)))
              #'left-hand [(+ beat dur) (rotate 1 notes) (rotate 1 durations)])))

(defn bassline
  [beat notes durations]
  (let [n (first notes)
        dur (first durations)]
    (play-synth beat fmsynth (note @root) 0.8 (* n dur))
    (apply-by (metro (+ beat (* 0.5 dur)))
              #'bassline [(+ beat dur) (rotate 1 notes) (rotate 1 durations)])))

(defn hats
  [beat dur]
  (at (metro beat)
      (closed-hat2 :amp 0.2 :decay (rand-nth '(0.3 0.1))))
  (apply-by (metro (+ beat (* 0.5 dur))) hats (+ beat dur) dur []))

(defn kick-drum
  [beat dur]
  (at (metro (- beat 1/4))
      (kick4 :freq 35 :amp 1.5 :attack 0.04 :decay dur))
  (at (metro beat)
      (kick4 :freq 35 :amp 1.2 :attack 0.04 :decay dur))
  (apply-by (metro (+ beat (* 0.5 dur))) kick-drum (+ beat dur) dur []))


(do
  (left-hand (* 4 (metro-bar metro)) '(:G3 :G3 :A3 :B3) '(1))
  (right-hand (* 4 (metro-bar metro)) 1/4)
  (bassline (* 4 (metro-bar metro)) '(0.25 0.25 0.6) '(3/2 1 3/2))
  (hats (* 4 (metro-bar metro)) 1/4)
  (kick-drum  (* 4 (metro-bar metro)) 1)
  )

(stop)
