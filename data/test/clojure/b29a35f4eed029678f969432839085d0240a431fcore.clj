(ns in24hrs.core
  (:use [overtone.live]
        [overtone.inst.sampled-piano]
        [overtone.inst.drum]
        [overtone.inst.synth]))

;;Global variables! Ugh!
(def metro (metronome 120))
(def root (atom :a3))
(def root-list [:c4 :g3] )

(demo 3 (saw 110))
(demo 3 (+ (saw 110) (sin 110)))
;;define a hi-hat instrument using chopped-off white noise signals
(definst hi-hat [duration 0.1]
  (pan2 (* (env-gen (perc 0 duration :curve -9)) (hpf (white-noise) 9000))))

(hi-hat 0.8)

;;define the kick drum using an audio sample .wav file
(def kick-path "/Users/apatnaik/Workspace/Projects/in24hrs/in24hrs/kick.wav")
(def kick-drum (sample kick-path))

(kick-drum)

;;Play the given instrument at the given pitch at the given level for the given duration
(defn play
  "doc-string"
  [instrument beat pitch level duration]
  (let [cur-inst (at (metro beat) (instrument :note pitch :level level))]
    (at (metro (+ duration beat)) (ctl cur-inst :gate 0))))


(play sampled-piano (metro) (note :E3) 1 1)

(defn find-closest-elem
  [n s]
  (let [nt         (if (float? n) n (note n))
        split-seq  (split-with #(<= % nt) s)
        nt-below   (last (first split-seq))
        nt-above   (first (last split-seq))
        nt-below   (if (nil? nt-below) (first s) nt-below)
        nt-above   (if (nil? nt-above) (last s) nt-above)
        diff-nt-below (- nt nt-below)
        diff-nt-above (- nt-above nt)]
    (if (> diff-nt-above diff-nt-below)
      nt-below
      nt-above)))

;;plays random notes in the scale, but randomisation runs as a
;;sine wave on current root
(defn arpeggiate [beat key mode]
  (play sampled-piano beat
        (find-closest-elem (sinr beat (sinr beat 4 0 3/7) (+ 24 (note @root)) 17/3) (scale-field key mode))
        (cosr beat 1/4 4/4 3/7)
        2/4)
  (apply-at (metro (+ 1/4 beat)) arpeggiate (+ 1/4 beat) key mode []))

;;
(defn piano-rhythm [beat note-list]
  (let [first-note (first note-list)
        other-notes (rest note-list)]
    (if (= 0 (mod beat 8))
      (reset! root (rand-nth (remove #(= % @root) root-list))))
    (at (metro beat) (sampled-piano (note first-note)))
    (at (metro (+ 1/2 beat)) (sampled-piano (note @root)))
    (apply-at (metro (+ 1 beat)) piano-rhythm (+ 1 beat) (concat other-notes [first-note]) []))
  )


;;play the kick-drum on every beat
(defn drum-loop [beat]
  (at (metro beat) (kick1))
  (apply-at (metro (+ 1 beat)) drum-loop (+ 1 beat) []))

;;loop the hi-hat with variable durations
(defn hi-hat-loop [beat]
  (at (metro (+ 1/2 beat)) (hi-hat 0.2))
  (at (metro (+ 3/4 beat)) (hi-hat (sinr beat 0.1 0.4 6)))
  (apply-at (metro (+ 1 beat)) hi-hat-loop (+ 1 beat) []))




;;rhythm section on the piano
(piano-rhythm (* 4 (metro-bar metro)) [:a3 :a3 :b3 :e4])
(arpeggiate (* 4 (metro-bar metro)) :a :minor)

;;bass
(bassline (* 4 (metro-bar metro)) [0.5 0.5 0.6] [3/2 1 3/2])



;;percussions
(drum-loop (* 4 (metro-bar metro)))
(hi-hat-loop (* 4 (metro-bar metro)))



(stop)











;;NOT MY CODE
(defsynth fmsynth
  [note 60 duration 1.0 level 1.0
   attack 0.05 release 0.05
   I 0.1  ;; modulation index (generally 0-1, but can go higher)
   H 10.0 ;; harmonicity ratio (whole numbers 1 - 20)
   out-bus 0
   ]
  (let [freq    (midicps note)
        o2      (* I (* H freq) (sin-osc (* H freq)))
        o1      (* level (/ 5.0 (log freq)) (sin-osc (+ freq o2)))
        S       (- duration attack release)
        amp-env (env-gen (lin attack S release))
        D       0.314
        all-env (env-gen (lin 0.01 (+ D (* 2 S)) 0.01) :action FREE)
        snd     (* amp-env o1)
        dly     (* 0.5 (delay-l snd 1.0 D))
        snd     (+ snd dly)]
    (out out-bus (pan2 (* all-env snd)))))




;;(fmsynth :note 52 :I 1.0 :H 0.5 :attack 0.01 :release 0.6)
(def fmsynth0 (partial fmsynth :I 1.0 :H 0.5 :attack 0.1 :release 0.2))

(defn bassline
  [beat ps ds]
  (let [dur (first ds)];)) ;; uncomment to stop
    (play1 beat fmsynth0 (note @root) 0.8 (* (first ps) (first ds)))
    (apply-by (metro (+ beat dur))
              #'bassline [(+ beat dur) (rotate 1 ps) (rotate 1 ds)])))

(defn play1
  "for synths that have :note, :level and :duration, play a note at a
  certain beat & allow it to turn off after the duration in beats."
  [beat synth pitch level dur]
  (let [dur-s (* dur (/ (metro-tick metro) 1000))]
    (at (metro beat) (synth :note pitch :duration dur-s :level level))))
