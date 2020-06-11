(ns borderless.sound
  (:require [overtone.core :as o :refer [out hold FREE]]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.test]))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utilities            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn control-range
  "I return a function that will return true/false if a value is within a min/max range."
  [min max]
  (fn [value]
    (and (>= value min) (<= value max)) ))

(defn inst-name-getter
  [inst]
  (-> inst meta :name))

;;;;;;;;;;;;;;;;;;;;;
;; spec            ;;
;;;;;;;;;;;;;;;;;;;;;

(s/def ::vca-range (s/double-in :min 0.4 :max 1.0))
(s/def ::reverb-range (s/int-in 0 1000))
(s/def ::vco-range (s/int-in 0 25))
(s/def ::q-range (s/double-in :min 0.1 :max 1.0))
(s/def ::frequency-range (s/int-in 20 20000))


;; TODO: What about frequency vs. frequency-range, vca vs. vca-range, etc...?

(s/def ::frequency (s/and number? #((control-range 20 20000) %) ))

;; VCA, VCO, and FX
(s/def ::vca (s/and number? #((control-range 0.4 1) %) ))
(s/def ::reverb (s/and integer? #((control-range 0 1000) %)))
(s/def ::vco (s/and integer? #((control-range 0 25) %)))

;; envelope
(s/def ::attack (s/and number? #((control-range 0 10) %)))
(s/def ::sustain (s/and number? #((control-range 0 1) %)))
(s/def ::release (s/and number? #((control-range 0 10) %)))
(s/def ::gate (s/and integer? #((control-range 0 1) %)))

(s/def ::sound-params
  (s/keys :req [::vca ::reverb ::vco]
          :opt [::attack ::sustain ::release ::gate]))

(def synth-defaults
  {::vca 1 ;; TODO: arbitrarily changed this from 1. What is the correct value?
   ::reverb 1
   ::vco 25
   ::vibrato 5
   ::attack 5.0
   ::sustain 0.4
   ::release 5.0
   ::gate 1})

(defn synth-generator []
  [(last (gen/sample (s/gen ::vca-range) 20))
   (last (gen/sample (s/gen ::reverb-range) 20))
   (last (gen/sample (s/gen ::vco-range) 20))])

(s/def ::pitch ::frequency-range)
(s/def ::eq-freq (s/coll-of ::frequency-range))
(s/def ::hpf-rlpf (s/coll-of number?))
(s/def ::q ::q-range)
(s/def ::drone (s/keys :req [::pitch ::eq-freq ::hpf-rlpf ::q]
                       :opt [::amp ::verb ::mod-rate]))

;; (= :overtone.studio.inst/instrument (type (get @person-sound 1)))
;; (s/fdef ctl-names
;;         :args (s/cat :instrument ??? :parameter keyword?)
;;         :ret keyword?)

;;;;;;;;;;;;;;;;;;;;;
;; Audio Sculpting ;;
;;;;;;;;;;;;;;;;;;;;;

(def drones {::drone-aw {::pitch 300 ::eq-freq [570 840 2410]  ::hpf-rlpf [900 600 0.6] ::q 0.1}
             ::drone-oo {::pitch 120 ::eq-freq [300 870 2240]  ::hpf-rlpf [0 600 0.6] ::q 0.1}
             ::drone-ae {::pitch 100 ::eq-freq [270 2290 3010] ::hpf-rlpf [600 8000 0.6] ::q 0.1}
             ::drone-eh {::pitch 80  ::eq-freq [530 1840 2480] ::hpf-rlpf [0 750 0.9] ::q 0.1}})

(def drone-names (map #(name (first %)) drones))

(defn synth-unit-layered
  "I create a stack of oscilators, each narrowly EQed on a given Q (frequency) to shape a saw waveform of a certain pitch.
   The end results are sharp Q spikes that resemble vowel formants like eh, aw, ae, etc...

   Step one is created a stack of pitches, all tuned to a fundamental frequency (the freq parameter)
   The frequency is modulated (the mod-rate parameter) by the control rate (0hz = no modulation)
   The mod-rate parameter is adjusted by an array of mod-multipliers (3 mod-multipliers = three voices)
   Note: the freq and mod-rate parameters are not integers, they are overtone.sc.machinery.ugen.sc_ugen.ControlProxy
         coming from the definst macro, therefore the * must be overtone.sc.ugen-collide/*

   ex: (synth-unit-layered 200 [530 1840 2480] 0.1 25)
   --> (#<sc-ugen: binary-op-u-gen:ar [4]> #<sc-ugen: binary-op-u-gen:ar [4]> #<sc-ugen: binary-op-u-gen:ar [4]>)"

  [freq eq-freq q mod-rate]
  (let [[freq-a freq-b freq-c] eq-freq
        mod-multipliers [2.5 0.5 1.5]
        pitch-with-kr (map #(overtone.sc.ugen-collide/+ freq (o/sin-osc:kr (overtone.sc.ugen-collide/* % mod-rate))) mod-multipliers)]

    (o/mix
        (map #(o/resonz (o/saw %) %2 q) pitch-with-kr eq-freq))))

(defn synth-filter-chain
  "I shape a sound with high pass filters, resonante low pass filters, amplifiers, and reverb."
  [synth-unit amp verb gate hpf-rlpf mod-rate-ctl vib-rate]
  (let [attack (synth-defaults ::attack)
        sustain (synth-defaults ::sustain)
        release (synth-defaults ::release)
        [hpf-freq rlpf-freq rlpf-q] hpf-rlpf]

    (-> synth-unit
        (overtone.sc.ugen-collide/* (o/env-gen (o/asr attack sustain release) gate))
        (o/hpf hpf-freq)
        (o/rlpf rlpf-freq rlpf-q)
        (overtone.sc.ugen-collide/* amp)
        (overtone.sc.ugen-collide/* mod-rate-ctl)
        (o/vibrato :rate vib-rate :depth 0.5 :depth-variation 0.5)
        (o/free-verb verb verb verb))))

(defn ctl-names
  "I take an instrument (type - :overtone.studio.inst/instrument) and a keyword parameter (ex: :freq)
   ane destructure the generated control values (ex: :freq > freq__20280__auto__).

   I return the generated control value.

   Example: (ctl-names (get @person-sound 1) :amp) => :amp__20282__auto__"

  [instrument parameter]

  (if-let [instrument-symbol (inst-name-getter instrument)]
    ;; If the instrument doesn't exist, it will return nil and not execute the rest of the closure.
    (let [ctl-data (eval (symbol "borderless.sound" (str instrument-symbol))) ;; Grab the control data map
          {params :params} ctl-data                 ;; Grab the parametrs from the control data
          [freq gate amp verb mod-rate vib-rate] params      ;; Destructure the parameters
          gensym-keymap {:freq (freq :name)
                         :gate (gate :name)
                         :amp (amp :name)
                         :verb (verb :name)
                         :mod-rate (mod-rate :name)
                         :vib-rate (vib-rate :name)}]

      (keyword (gensym-keymap parameter)))))

(defmacro sound-returner [drone]
  "I take a sound's name as defined using clojure.spec and call the definst macro to generate an instrument on the fly

   Example: (sound-returner 'drone-eh') => #<instrument: drone-eh24097>

   Then the user can use Overtone's ctl function to update the sound.

   Example: (o/ctl drone-eh24097 (ctl-names 'drone-eh24097 :amp) 10)"

  `(do
     ~(let [inst-name (symbol drone)
            synth-drone (drones (keyword "borderless.sound" (str drone)))]
        `(o/definst ~inst-name [freq#     (~synth-drone ::pitch)
                                gate#     (~synth-defaults ::gate)
                                amp#      (~synth-defaults ::vca)
                                verb#     (~synth-defaults ::reverb)
                                mod-rate# (~synth-defaults ::vco)
                                vib-rate# (~synth-defaults ::vibrato)]
           (let [eq-freq#    (~synth-drone ::eq-freq)
                 hpf-rlpf#   (~synth-drone ::hpf-rlpf)
                 q#          (~synth-drone ::q)
                 synth-unit# (synth-unit-layered freq# eq-freq# q# mod-rate#)]

             (synth-filter-chain synth-unit# amp# verb# gate# hpf-rlpf# mod-rate# vib-rate#)
             )))))

(defn sound-maker
  "I make a vowel sound at a given frequency.

   Example: (sound-maker 'drone-aw')"

  [drone]
  (let [synth-drone (drones (keyword "borderless.sound" drone))]
    ((o/synth (o/out 0 (let  [freq   (synth-drone ::pitch)
                              gate   (synth-defaults ::gate)
                              amp    (synth-defaults ::vca)
                              verb   (synth-defaults ::reverb)
                              mod-rate   (synth-defaults ::vco)
                              eq-freq    (synth-drone ::eq-freq)
                              hpf-rlpf   (synth-drone ::hpf-rlpf)
                              q          (synth-drone ::q)
                              synth-unit (synth-unit-layered freq eq-freq q mod-rate)]

                         (synth-filter-chain synth-unit amp verb gate hpf-rlpf mod-rate)))))))

(defn test-frequency
  "This is the most basic use of o/synth"
  []
  (o/synth [] (o/out 0 (o/sin-osc 440))))

(o/definst test-vibrato
  "Example: (o/ctl 96 :freq 200 :depth 0.9 :rate 9)"
  [freq 440 rate 5 depth 0.02]
  (o/vibrato (o/saw freq) rate depth :depth-variation 0.5))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Person/Sound Mapping ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(def person-sound (atom {}))

(defn get-sound [pid]
  (if (contains? @person-sound pid)
    ((first (get @person-sound pid)))))

(defn add-person-sound! [pid sound x sound-name]
  (reset! person-sound (assoc @person-sound pid [sound x sound-name]))
  (get-sound pid))

(defn remove-person-sound! [pid]
  (if (contains? @person-sound pid)
    (reset! person-sound (dissoc @person-sound pid))))

(defn instrument-and-symbol [pid]
  (let [instrument (first (get @person-sound pid))
        instrument-symbol (inst-name-getter instrument)]
    [instrument instrument-symbol]))

;;;;;;;;;;;;;;;;;;;;;
;; Control         ;;
;;;;;;;;;;;;;;;;;;;;;

(defn amplitude-mul
  "This is a quick 'n dirty function that lowers the amplitude over time. It was written to compensate the removal of reverb over time and the increase in the perceived loudness of a sound."
  [age]
  (cond
    (< age 600) 10
    (< age 750) 1.7
    (< age 900) 1.6
    (< age 1000) 1.5
    (>= age 1000) 1.4
    :else 1))

(defn end-sound! [pid]
  (let [[instrument instrument-symbol] (instrument-and-symbol pid)
        gate-name (ctl-names instrument :gate)]
    (when (contains? (deref person-sound) pid)
      (o/ctl
       (eval (symbol "borderless.sound" (str instrument-symbol)))
       gate-name 0)
          (println "Left: " pid)
      (remove-person-sound! pid))))

(defn reset-atom [current-people]
  (when (seq current-people) (end-sound! (ffirst current-people)) (reset-atom (rest current-people))))

(defn first-occurance [collection]
  (let [nil-finder (loop [n 0 col collection]
                     (if (nil? (first col))
                       n
                       (recur (inc n) (rest col))))]
    (if (= nil-finder (count collection))
      nil
      nil-finder)))

(defn first-non-occurance []
  (let [playing-sounds (map #(nth (second %) 2) @person-sound)]

    (for [x drone-names
          :let [containing-tester (some #(= x %) playing-sounds)]
          :when (nil? containing-tester)]
      x)))

(defn start-sound!
  "Start the sound and add it to the atom. Reset that atom every xx number of people."
  [pid x]
  (let [[drone-1 drone-2 drone-3 drone-4] drone-names
        sound-to-add (first (first-non-occurance))
        reset-val        40]

    ;; TODO: IS THIS WHERE THE HANGING NOTES HAPPEN?
    (when (zero? (rem pid reset-val)) (o/clear) (reset-atom (deref person-sound)))

    (println pid " entered")

    (case sound-to-add
      "drone-aw" (add-person-sound! pid (sound-returner drone-aw) x drone-1)
      "drone-oo" (add-person-sound! pid (sound-returner drone-oo) x drone-2)
      "drone-ae" (add-person-sound! pid (sound-returner drone-ae) x drone-3)
      "drone-eh" (add-person-sound! pid (sound-returner drone-eh) x drone-4)
      "atom full: four people are tracked")))

(defmulti controller (fn [parameter pid val] parameter))

(defmethod controller :rate [parameter pid x]
  (let [anchor-id (ffirst @person-sound)
        [instrument instrument-symbol] (instrument-and-symbol pid)

        rate-name (ctl-names instrument :vib-rate)
        rate-val  (o/scale-range x 0 1 0.025 6)]

    (if (and (contains? @person-sound pid) (not= pid anchor-id))
      (do (println "Updated: " pid)
          (o/ctl (eval (symbol "borderless.sound" (str instrument-symbol))) rate-name rate-val))

      )))

(defmethod controller :timbre [parameter pid age]
  "I take a val between 0 and 1000+, map the value, and send it to the instrument's controller."
  (let [[instrument instrument-symbol] (instrument-and-symbol pid)

        amp-name (ctl-names instrument :amp)
        verb-name (ctl-names instrument :verb)
        mod-name (ctl-names instrument :mod-rate)

        amp-val   (amplitude-mul age)
        verb-val  (o/scale-range age 0 1000 1 0.3)
        kr-val    (o/scale-range age 0 1000 25 4)]
    (if (contains? @person-sound pid)
      (o/ctl (eval (symbol "borderless.sound" (str instrument-symbol)))
             amp-name amp-val
             verb-name verb-val
             mod-name kr-val))))


;; Transducers are composable algorithmic transformations. They are independent from the context of their input and output sources and specify only the essence of the transformation in terms of an individual element. Because transducers are decoupled from input or output sources, they can be used in many different processes - collections, streams, channels, observables, etc. Transducers compose directly, without awareness of input or creation of intermediate aggregates.
;; https://clojure.org/guides/spec
;; Generating synthdefs: https://github.com/overtone/overtone/wiki/Comparing-sclang-and-Overtone-synthdefs
;; OSC -> Transducer -> keyword list
