;;
;; the sampled cello instrument
;;
;; to use:
;;   (use 'overtone.live)
;;   (use 'oversampler.cello.inst)
;;   (sampled-cello :note 50 :level 0.5) ;; mf sample
;;
;;   (sampled-cello-init :pp-volume-cutoff 0.3 :mf-volume-cutoff 0.85)
;;   (sampled-cello :note 50 :level 0.2) ;; pp sample
;;   (sampled-cello :note 50 :level 0.5) ;; mf sample
;;   (sampled-cello :note 50 :level 0.9) ;; ff sample
;;
(ns oversampler.freesound.cello.inst
  (:require [overtone.live :as o]
            [oversampler.freesound.cello.bank :as bank]))

;; provide an alias
(def sampled-cello-init bank/sampled-cello-init)

;; ======================================================================
;; the sampled-cello instrument
(o/definst sampled-cello
  "A sampled cello instrument.  Use note to select the midi pitch and
change the global volue via level.  A rate control allows for pitch
adjustment.  Use gate to turn off the provided ADSR envelope.  By
default, when the sample goes silent, it causes a FREE of the
instrument to happen.  However, it can be useful to pass a NO-ACTION
to the play-buf-action in order to only have the instrument freed when
a :gate 0 happens."
  [note    {:default 60  :min bank/min-index :max bank/max-index :step 1}
   level   {:default 1.0 :min 0.0 :max 1.0 :step 0.01}
   rate    {:default 1.0 :min 0.5 :max 2.0 :step 0.01}
   attack  {:default 0.0 :min 0.0 :max 0.5 :step 0.01}
   decay   {:default 0.0 :min 0.0 :max 0.5 :step 0.01}
   sustain {:default 1.0 :min 0.0 :max 1.0 :step 0.01}
   release {:default 0.2 :min 0.0 :max 1.0 :step 0.01}
   curve   {:default -4  :min -5  :max 5   :step 1}
   gate    {:default 1   :min 0   :max 1   :step 1}
   play-buf-action o/FREE]
  (let [ofst (o/index:kr (:id bank/level-to-offset-buffer) (o/floor (* 20 level)))
        the-sample-id (o/index:kr (:id bank/note-to-sample-id-buffer) (+ ofst note))
        the-sample-scale (o/index:kr (:id bank/note-to-level-scale-buffer) (+ ofst note))
        the-sample-length (o/index:kr (:id bank/note-to-length-buffer) (+ ofst note))
        the-sample-rate (o/index:kr (:id bank/note-to-rate-buffer) (+ ofst note))
        ;; envelope for making sure we have zeros at start/end, this
        ;; also allows us to scale the height (level), too.
        env2 (o/env-gen (o/envelope [0 0 1 1 0 0]
                                    [0.01 0.01 (- the-sample-length 0.04) 0.01 0.01]
                                    :sine)
                        :level-scale the-sample-scale
                        :gate gate :action o/FREE)
        ;; regular adsr envelope
        env (o/env-gen (o/adsr attack decay sustain release level curve)
                       :gate gate :action o/FREE)
        the-samples (o/scaled-play-buf 1 the-sample-id
                                       :rate (* rate the-sample-rate)
                                       :level 1.0
                                       :action play-buf-action)
        ;; the cello samples have some crazy low-frequency "issues" that can
        ;; be easily filtered with the leak-dc ugen.
        the-samples (o/leak-dc the-samples 0.995)]
    (* level env2 env the-samples)))
