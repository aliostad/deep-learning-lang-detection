(ns patrn.examples.overtone
  (:require [clojure.pprint :refer [pprint]]
            [patrn.core :as p]
            [patrn.musical-event :as event]
            [patrn.overtone :refer [play-event play]])
  (:use [overtone.live]))

(defn pp [x] (pprint x) x)

(comment
  (connect-external-server "192.168.0.10" 57110)

  ;; Overtone lets you define instruments
  (definst perc-sine 
    [freq 440 amp 0.5 length 1 pan 0]
    (pan2 (* (env-gen (perc 0.01 length) 
                      :action FREE)
             (sin-osc freq))
          pan amp))

  ;; and play them back like so
  (perc-sine 1230)

  ;; Overtone can also create gated instruments 
  (definst gated-sine
    [freq 440 amp 0.5 gate 1 attack 0.01 decay 0.1 sustain 0.5 release 0.1 pan 0]
    (pan2 (* (env-gen (adsr attack decay sustain release) 
                      gate :action FREE)
             (sin-osc freq))
          pan amp))

  ;; which are triggered similarily but need there gate closed to stop
  (def g (gated-sine 123))
  (ctl g :gate 0)

  ;; patrn's play-event handles gating for you
  (play-event {:instrument perc-sine})
  (play-event {:instrument gated-sine})

  ;; paramater values are assumed where possible unless specified.
  (play-event {:instrument gated-sine
               :freq 1000
               :length 5})

  ;; you can use pre-specified event key derivation
  ;; for example degree -> freq for our instrument here
  (play-event {:instrument perc-sine :degree 0})
  (play-event {:instrument perc-sine :degree 4})

  (def pattern
    (p/bicycle {:instrument perc-sine
                :amp        [1/2 1/3 1/4 1/8]
                :duration   (map #(/ % 4) [2 3 3])
                :degree     (shuffle (range 1 12))
                :octave     [4 5 6 5]}))

  (def player (play pattern))

  (kill-player player)

  (def a (p/bind {:instrument perc-sine
                  :amp 0.5
                  :octave 7
                  :degree   [0   0   4   4   5   5   4]
                  :duration [1/2 1/2 1/2 1/2 1/2 1/2 1]}))

  (play a)
  ;; get patterns length

  (defn slide 
    [repeats len step start coll]
    (->> (drop start coll)
         (partition-all len step)
         (take repeats)))

  (def a-flock-of-sea-gulls 
    (p/bind {:instrument perc-sine
             :degree   (->> (range -6 12 2)
                            (partition-all 3 1) 
                            (take 8)) 
             :duration (cycle [0.1 0.1 0.2])
             :length   0.15}))

  (play a-flock-of-sea-gulls)

  (def prand
    (p/bind {:degree   #(rand-nth (range 6))
             :duration 1/4}))

  ;;;; pxrand is stateful

  (def pshuf 
    ;; randomly ordered once and then repeated
    (p/bind {:degree   (shuffle (range 6))
             :duration 0.25}))

  (defn normalize-sum
    [coll] (let [sum (reduce + coll)]
             (map #(/ % sum) coll)))

  (def pwrand 
    ; use overtone's weighted choose
    {:degree   (weighted-choose (range 8) (normalize-sum [4 1 3 1 3 2 1]))
     :duration 0.25})

  ;;;; pwalk - stateful! - also has streams as inputs?

  (play prand m (m))

  (defn one-of 
    [coll]
    "generates function that returns an item at a time from collection."
    (let [a (atom coll)]
      (fn [] 
        (let [coll @a] 
          (swap! a rest)
          (first coll)))))

  ;; Place 
  (p/stream (repeat 9 [0 (one-of (cycle [1 #(rand-nth [9 10 11])])) (one-of (cycle [3 4 5]))]))

  (defn lace
    [coll] (map #(if (sequential? %) (-> % cycle p/stream one-of) %) coll))

  (def shuffler (comp shuffle range))

  (defn odds-then-evens 
    [coll] (let [{evens true odds false} (group-by even? coll)] [odds evens]))

  (pp (->> (lace [[1 2 3] 4 5 6 [7 8] (shuffler 1 20 3)])
           (repeat 8)
           p/stream
           (partition 8)
           (map odds-then-evens)
           (filter (fn [[a b]] (not= (count a) (count b))))))

  (pn (map odds-then-evens (partition 8 (p/stream)))) 

  (p/patrn->seq (repeat 3 (lace [1 [1 2] 2 3 [4 5 6]])))

  (def first-binding
    (p/bind {:detune   #{0 1 3}
             :freq     (repeat (* 4 5 7) (range 100 1100 100))
             :db       (cycle [-20 -40 -30 -40])
             :pan      (cycle [-1 0 1 0])
             :duration (cycle [2 2 2 2 4 4 8])
             :legato   (cycle [2 1/2 3/4 1/2 1/4])}))

;; TODO: multichannel expand sets #{}}
  (def first-cycle-ride 
    (p/bicycle {:detune   #{0 1 3}
                :freq     (repeat (* 4 5 7) (range 100 1100 100))
                :db       [-20 -40 -30 -40]
                :pan      [-1 0 1 0]
                :duration [2 2 2 2 4 4 8]
                :legato   [2 1/2 3/4 1/2 1/4]}))

;; TODO: possible reordering of function dependancies.
;; ordered-map could support via assoc/dissoc process
  (def interdependant-values
    (p/bind {:stretch-lin (take 8 (cycle [0 0.1 0.2 1]))
             :stretch     #(lin->exp 0 1 1 0.125 (:stretch-lin %))
             :midi-note   (hz->midi 100)
             :harmonic    #(inc (rand-int 15))
             :legato      #(* (:stretch %) (:harmonic %) 0.5)
             :db          #(- -10 (:harmonic %))
             :detune      #(rand 3)
             :duration    0.2}))

;; TODO: could produce 1 arity fn that uses time-stamp
  (def time-based-patterns
    (p/bind {:scale (p/step [:diatonic :aeolian] 5)
             :db    (p/envelope [-2 -30 -25 -30] 0.4)}))

;; TODO: would be stateful walk brownian motion gen
  (def stutter-walk
    (p/bind {:degree    (p/brown 0 6 1)
             :transpose #(rand-nth [:rest (repeat (rand 5) 0)])
             :duration  0.2
             :octave    6}))

  (def chord
    (p/bind {:degree    #{0 2 4}
             :transpose (p/brown 0 6 1)
             :duration  0.4
             :db        -35})))
