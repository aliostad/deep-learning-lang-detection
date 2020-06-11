;;
;; garageband steinway grand piano synth
;;
(ns oversampler.garageband.steinway-grand-piano.synth
  (:require [overtone.live :as o]
            [oversampler.garageband.steinway-grand-piano.bank :as bank]))

;; provide an alias
(def sample-init bank/sample-init)
;; (sample-init)

;; ======================================================================
;; the sampled-piano instrument
(o/defsynth steinway-grand-piano
  "A sampled piano synth using samples from Apple's Garageband.  Use
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
        the-samples     (o/scaled-play-buf 2 the-sample-id
                                           :rate (* the-sample-rate rate)
                                           :level 1.0
                                           :action play-buf-action)
        left-samples    (* env (o/select 0 the-samples))
        right-samples   (* env (o/select 1 the-samples))
        ;; adjust volume level for pre-adjusted sample volumes
        adj-level (+ 0.5 (* 0.5 (o/frac (* 4 level))))]
    (o/out out-bus (o/balance2 left-samples right-samples pan adj-level))))

(comment
  ;; testing
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 200))
                         (steinway-grand-piano n :level 0.6)))
          [60 62 67 72]))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (steinway-grand-piano n :level 0.6)))
          (range 20 109)))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (steinway-grand-piano 54 :level n)))
         [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (steinway-grand-piano 60 :level n)))
          [0.05 0.10]))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                        (steinway-grand-piano 60 :level n)))
          [0.24 0.26]))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (steinway-grand-piano 60 :level n)))
          [0.49 0.51]))
  (dorun (map-indexed
          (fn [i n] (o/at (+ (o/now) (* i 500))
                         (steinway-grand-piano 60 :level n)))
         [0.74 0.76]))
 )
