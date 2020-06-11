(ns random-noises.instruments
  (:require [overtone.live :as ovl]))

(def kick (ovl/sample (ovl/freesound-path 2086)))

(ovl/definst adv-kick [freq 120 dur 0.3 width 0.5]
  (let [freq-env (* freq (ovl/env-gen (ovl/perc 0 (* 0.99 dur))))
        env (ovl/env-gen (ovl/perc 0.01 dur) 1 1 0 1 ovl/FREE)
        sqr (* (ovl/env-gen (ovl/perc 0 0.01)) (ovl/pulse (* 2 freq) width))
        src (ovl/sin-osc freq-env)
        drum (+ sqr (* env src))]
  (ovl/compander drum drum 0.2 1 0.1 0.01 0.01)))

(ovl/definst c-hat [amp 0.8 t 0.04]
  (let [env (ovl/env-gen (ovl/perc 0.001 t) 1 1 0 1 ovl/FREE)
        noise (ovl/white-noise)
        sqr (* (ovl/env-gen (ovl/perc 0.01 0.04)) (ovl/pulse 880 0.2))
        filt (ovl/bpf (+ sqr noise) 9000 0.5)]
  (* amp env filt)))

(ovl/definst saw-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4]
  (* (ovl/env-gen (ovl/env-lin attack sustain release) 1 1 0 1 ovl/FREE)
     (ovl/saw freq)
     vol))

(ovl/definst square-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4]
  (* (ovl/env-gen (ovl/lin attack sustain release) 1 1 0 1 ovl/FREE)
     (ovl/lf-pulse:ar freq)
     vol))

(ovl/definst triangle-wave [freq 440 attack 0.01 sustain 0.1 release 0.4 vol 0.4]
  (* (ovl/env-gen (ovl/lin attack sustain release) 1 1 0 1 ovl/FREE)
     (ovl/lf-tri freq)
     vol))

(defn sawh
  "Takes a music note...like :C4 and plays a saw instrument"
  [music-note]
  (saw-wave (ovl/midi->hz (ovl/note music-note))))

(defn squarew
   "Takes a music note...like :C4 and plays a square instrument"
   [music-note]
   (square-wave (ovl/midi->hz (ovl/note music-note))))

(defn trianglew
  "Takes a music note...like :C3 and plays a triangle instrument"
  [music-note]
  (triangle-wave (ovl/midi->hz (ovl/note music-note))))
