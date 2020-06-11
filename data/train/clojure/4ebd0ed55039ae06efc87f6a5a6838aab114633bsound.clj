(ns twpsong.sound
  (:use
   [overtone.core]
   )
  (:import java.io.File)
)

(boot-external-server)

(def notes [60 62 64 65 67 69 71 72])

(def directory (clojure.java.io/file "samples/"))
(def files (file-seq directory))
(def filenames ( take-while #(= % %) files))
(def filenames (sort (next filenames)))
;(def synthz (into-array (for [file filenames] (sample file) )) )
(def synthz (zipmap
             (for [f filenames] (read-string (clojure.string/replace
                                              (clojure.string/replace f ".wav" "") "samples/" "")))
             (for [f filenames] (sample f))))

;; many of these sounds were pilfered from the internet, various authors
;; or the overtone examples themselves
(definst beep [note 60 vol 0.5]
        (let [
                freq (midicps note)
                src (sin-osc freq)
                env (env-gen (perc 0.3 2) :action FREE)
         ]
        (* vol src env))
)

(definst spooky-house [freq 440 width 0.2
                         attack 0.3 sustain 4 release 0.3
                         vol 0.4]
  (* (env-gen (lin-env attack sustain release) 1 1 0 1 FREE)
     (sin-osc (+ freq (* 20 (lf-pulse:kr 0.5 0 width))))
     vol))

(definst c-hat [amp 0.8 t 0.04]
  (let [env (env-gen (perc 0.001 t) 1 1 0 1 FREE)
        noise (white-noise)
        sqr (* (env-gen (perc 0.01 0.04)) (pulse 880 0.2))
        filt (bpf (+ sqr noise) 9000 0.5)]
    (* amp env filt)))

;(definst twpkick [freq 120 dur 0.3 width 0.5]
;  (let [freq-env (* freq (env-gen (perc 0 (* 0.99 dur))))
;        env (env-gen (perc 0.01 dur) 1 1 0 1 FREE)
;        sqr (* (env-gen (perc 0 0.01)) (pulse (* 2 freq) width))
;        src (sin-osc freq-env)
;        drum (+ sqr (* env src))]
;    (compander drum drum 0.2 1 0.1 0.01 0.01)))

(defcgen twpkick
  "basic synthesised kick drum"
  [bpm {:default 120 :doc "tempo of kick in beats per minute"}
   pattern {:default [1 0] :doc "sequence pattern of beats"}]
  (:ar
   (let [kickenv (decay (t2a (demand (impulse:kr (/ bpm 30)) 0 (dseq pattern INF))) 0.7)
         kick (* (* kickenv 7) (sin-osc (+ 40 (* kickenv kickenv kickenv 200))))]
     (clip2 kick 1))))
(defsynth whoah []
  (let [sound (resonz (saw (map #(+ % (* (sin-osc 100) 1000)) [440 443 437])) (x-line 10000 10 10) (line 1 0.05 10))]
  (* (lf-saw:kr (line:kr 13 17 3)) (line:kr 1 0 10) sound)))

(definst round-kick [amp 0.5 decay 0.6 freq 65]
  (* (env-gen (perc 0.01 decay) 1 1 0 1 FREE)
     (sin-osc freq (* java.lang.Math/PI 0.5)) amp))

(defn ugen-cents
  "Returns a frequency computed by adding n-cents to freq.  A cent is a
  logarithmic measurement of pitch, where 1-octave equals 1200 cents."
  [freq n-cents]
  (with-overloaded-ugens
    (* freq (pow 2 (/ n-cents 1200)))))

(definst rise-fall-pad [freq 440 split -5 t 4]
  (let [f-env (env-gen (perc t t) 1 1 0 1 FREE)]
    (rlpf (* 0.3 (saw [freq (ugen-cents freq split)]))
          (+ (* 0.6 freq) (* f-env 2 freq)) 0.2)))
(defcgen kick-drum
  "basic synthesised kick drum"
  [bpm {:default 120 :doc "tempo of kick in beats per minute"}
   pattern {:default [1 0] :doc "sequence pattern of beats"}]
  (:ar
   (let [kickenv (decay (t2a (demand (impulse:kr (/ bpm 30)) 0 (dseq pattern INF))) 0.7)
         kick (* (* kickenv 7) (sin-osc (+ 40 (* kickenv kickenv kickenv 200))))]
     (clip2 kick 1))))

(defcgen snare-drum
  "basic synthesised snare drum"
  [bpm {:default 120 :doc "tempo of snare in beats per minute"}]
  (:ar
   (let [snare (* 3 (pink-noise [1 1]) (apply + (* (decay (impulse (/ bpm 240) 0.5) [0.4 2]) [1 0.05])))
         snare (+ snare (bpf (* 4 snare) 2000))]
     (clip2 snare 1))))

(defsynth dubstep [bpm 120 wobble 1 note 50 snare-vol 1 kick-vol 1 v 1]
 (let [trig (impulse:kr (/ bpm 120))
       freq (midicps note)
       swr (demand trig 0 (dseq [wobble] INF))
       sweep (lin-exp (lf-tri swr) -1 1 40 3000)
       wob (apply + (saw (* freq [0.99 1.01])))
       wob (lpf wob sweep)
       wob (* 0.8 (normalizer wob))
       wob (+ wob (bpf wob 1500 2))
       wob (+ wob (* 0.2 (g-verb wob 9 0.7 0.7)))

 ;      kickenv (decay (t2a (demand (impulse:kr (/ bpm 30)) 0 (dseq [1 0 0 0 0 0 1 0 1 0 0 1 0 0 0 0] INF))) 0.7)
 ;      kick (* (* kickenv 7) (sin-osc (+ 40 (* kickenv kickenv kickenv 200))))
 ;      kick (clip2 kick 1)

;       snare (* 3 (pink-noise [1 1]) (apply + (* (decay (impulse (/ bpm 240) 0.5) [0.4 2]) [1 0.05])))
;       snare (+ snare (bpf (* 4 snare) 2000))
;       snare (clip2 snare 1)
       ]
   (out 0 (* 0.23 wob))
 ;  (out 0    (* v (clip2 (+ wob (* kick-vol kick) (* snare-vol snare)) 1)))
   )
 )

(defn play-notes
  [t speed instrument notes]
  (let [n (first notes)
        notes (next notes)
        t-next (+ t speed)]
    (when n
      (at t
          (instrument (note n)))
      (apply-at t-next #'play-notes [t-next speed instrument notes]))))
