(ns smithereens.sound
  (:use overtone.core))

(defonce sc-server (boot-server))

(definst steel-drum [note 60 amp 0.8 gate 0]
  (let [freq (midicps note)]
    (* amp
       (env-gen (perc 0.01 2.0) 1 1 0 1 :action FREE)
       (+ (sin-osc (/ freq 6))
          (rlpf (saw freq) (* 1.1 freq) 0.4)))))

(definst saw-wave [note 60 amp 0.8 gate 1 attack 0 release 0 vol 10]
  (let [freq (midicps note)]
    (* (env-gen (lin-env attack 1 release) 1 1 0 1 FREE)
       (saw freq)
       vol)))

(definst ding
  [note 60 velocity 100 gate 1]
  (let [freq (midicps note)
        amp  (/ velocity 127.0)
        snd  (sin-osc freq)
        env  (env-gen (adsr 0.001 0.1 0.6 0.3) gate :action FREE)]
            (* amp env snd))) 

;; Adding an instrument to midi player
(def player (midi-poly-player ding))
;; To remove the synth
;; (midi-player-stop)
