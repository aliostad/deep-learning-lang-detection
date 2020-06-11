;;
;; garageband steel string acoustic guitar synth
;;
(ns oversampler.garageband.steel-string-acoustic-guitar.synth
  (:require [overtone.live :as o]
            [oversampler.garageband.steel-string-acoustic-guitar.bank :as bank]))

;; provide an alias
(def sample-init bank/sample-init)
;; (sample-init)

;; ======================================================================
;; the sampled-piano instrument
(o/defsynth acoustic-guitar ;; interesting error if used steel-string-acoustic-guitar
  "A sampled guitar synth using samples from Apple's Garageband.  Use
note to select the midi pitch and change the global volue via level.
A rate control allows for pitch adjustment.  Use gate to turn off the
provided ADSR envelope.  By default, when the sample goes silent, it
causes a FREE of the instrument to happen.  However, it can be useful
to pass a NO-ACTION in order to only have the instrument freed when
a :gate 0 happens.  Use the pan to control stereo placement and use
out-bus to control where the output of the synth is sent."
  [note    {:default 60  :min bank/min-index :max bank/max-index :step 1}
   level   {:default 1.0 :min 0.0 :max 1.0 :step 0.01}
   rate    {:default 1.0 :min 0.5 :max 2.0 :step 0.01}
   attack  {:default 0.0 :min 0.0 :max 0.5 :step 0.01}
   decay   {:default 0.0 :min 0.0 :max 0.5 :step 0.01}
   sustain {:default 1.0 :min 0.0 :max 1.0 :step 0.01}
   release {:default 0.2 :min 0.0 :max 1.0 :step 0.01}
   curve   {:default -4  :min -5  :max 5   :step 1}
   gate    {:default 1   :min 0   :max 1   :step 1}
   pan     {:default 0.0 :min -1  :max 1   :step 0.01}
   play-buf-action o/FREE
   out-bus 0]
  (let [ofst            (o/index:kr (:id bank/level-to-offset-buffer)
                                   (o/floor (* bank/level-steps level)))
        the-sample-id   (o/index:kr (:id bank/note-to-sample-id-buffer) (+ ofst note))
        the-sample-rate (o/index:kr (:id bank/note-to-rate-buffer) (+ ofst note))
        env             (o/env-gen (o/adsr attack decay sustain release level curve)
                                   :gate gate :action o/FREE)
        the-samples     (o/scaled-play-buf 1 the-sample-id
                                           :rate (* the-sample-rate rate)
                                           :level 1.0
                                           :action play-buf-action)
        ;; adjust volume level for pre-adjusted sample volumes
        adj-level (+ 0.6 (* 0.4 (o/frac (* 3 level))))]
    (o/out out-bus (o/pan2 the-samples pan adj-level))))

(comment
  ;; testing
  (acoustic-guitar 40 :level 0.6)
  ;; strum a chord
  (dorun (map-indexed
          (fn [i n] (let [t0 (o/now)
                         t1 (+ t0 (* i 10))
                         t2 (+ t0 3000)
                         snd  (o/at t1 (acoustic-guitar n :level 0.4))]
                     (o/at t2 (o/ctl snd :gate 0))))
          [30 34 37 42 46 54]))
  ;; arpeggio
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 200))
                         (acoustic-guitar n :level 0.6)))
          [40 42 47 52]))
  ;; check all notes
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (acoustic-guitar n :level 0.75))) ;; 0.25 0.5 0.75
          (range 27 65)))
  ;; check across volumes
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (acoustic-guitar 50 :level n)))
         [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]))
  ;; check at volume boundary 1
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                        (acoustic-guitar 50 :level n)))
          [0.32 0.34]))
  ;; check at volume boundary 2
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (acoustic-guitar 50 :level n)))
          [0.65 0.67]))
 )
