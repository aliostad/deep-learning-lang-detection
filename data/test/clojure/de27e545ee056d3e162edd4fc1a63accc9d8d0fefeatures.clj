(ns music-examples.features
  (:require [score.core :refer :all]
            [score.freq :refer :all]
            [score.sieves :refer :all])  
  (:require [pink.simple :refer :all]
            [pink.engine :refer :all]
            [pink.config :refer :all]
            [pink.control :refer :all]
            [pink.filters :refer :all]
            [pink.envelopes :refer :all]
            [pink.util :refer :all]
            [pink.node :refer :all]
            [pink.oscillators :refer :all]
            [pink.space :refer :all]
            [pink.event :refer :all]
            [pink.effects.ringmod :refer :all]
            [pink.effects.reverb :refer :all]
            ))

;; Example of using various features from Pink and Score 

;; ====================== 
;; INSTRUMENT DEFINITIONS 
;; ======================
(defn fm
  "Simple frequency-modulation sound with default 1.77:1 cm ratio"
  ([freq amp]
   (fm freq amp 0.4 1.77))
  ([freq amp fm-index mod-mult]
  (let [freq (shared (arg freq)) 
        mod-freq (mul freq mod-mult)]
    (let-s [e (if (fn? amp) 
                amp
                (mul amp (adsr 0.02 2.0 0.0 0.01)))] 
      (->
        (sine2 (sum freq (mul freq fm-index e 
                              (sine2 mod-freq))))
        (mul e)
        )))))


(defn ringm 
  "Simple instrument with ring-modulation"
  ([freq amp]
   (let [e (if (fn? amp) 
             amp
             (mul amp (adsr 0.04 2.0 0.0 0.01)))] 
     (->
       (ringmod 
         (blit-saw freq)
         (sine2 (mul freq 2.0)))
       (mul e)
       ))))

;; AUDIO GRAPH SETUP 
;; =================

(def dry-node (audio-node :channels 2))
(def reverb-node (audio-node :channels 2))

(add-afunc dry-node)
(add-afunc (freeverb reverb-node 0.9 0.5))
(defn clear-afns []
  (node-clear dry-node)
  (node-clear reverb-node))

;; =====================
;; PERFORMANCE FUNCTIONS 
;; =====================

(defn mix-afn 
  "Applies panning (loc) to a mono audio function, 
  then attaches to stereo values to dry and reverb nodes."
  [afn loc]
  (let-s [sig (pan afn loc)] 
    (node-add-func
      dry-node 
      (apply-stereo mul sig 0.7))
    (node-add-func
      reverb-node 
      (apply-stereo mul sig 0.3)))
  nil)

(defn perf-fm 
  "Performance function for FM instrument."
  [dur & args] 
  (binding [*duration* dur] 
    (mix-afn (apply!*! fm args) -0.1)))

(defn perf-ringm 
  "Performance function for ringm instrument."
  [dur & args]
  (binding [*duration* dur] 
    (mix-afn (apply!*! ringm args) 0.1)))

(defn s 
  "Convenience function for creating Pink event from Score note."
  [afn start dur & args]
  (event #(apply afn dur args) start ))

;; ===== 
;; SCORE
;; =====

(defn sieve-chord 
  "Given instrument function, base pitch, and sieve, 
  generate chord where sieve values are offsets from base-pch."
  ([base-pch sieve dur amp]
   (sieve-chord perf-ringm base-pch sieve dur amp))
  ([instrfn base-pch sieve dur amp]
  (gen-notes 
    (repeat instrfn)
    0.0 dur (map #(pch->freq (pch-add base-pch %)) sieve) 
    amp)))

;; Set tempo of engine
(set-tempo 54)

;; glissandi score fragment with higher-order event arguments
(def gliss-fragment
  (map #(into [perf-fm] %) 
       (gen-notes
         0.0 6.0 
         (->> 
           [:A4 :C5 :Cs5 :E5]
           (map keyword->freq)
           (map #(!*! env [0.0 % 6.0 (* 1.2 %)]))) 
         (repeat (!*! env [0.0 0.0 3.0 0.2 3.0 0.0])) 
         )))

;; Score in measured-score format
(def score
  [:meter 4 4
   0.0 (sieve-chord perf-fm [8 0] (gen-sieve 7 [2 0]) 1.0 0.25) 
   0.25 (sieve-chord perf-fm [8 3] (gen-sieve 7 [2 0]) 3.0 0.25) 

   1.0 (sieve-chord perf-fm [9 0] (gen-sieve 7 (U [4 0] [3 1])) 1.0 0.25) 
   1.25 (sieve-chord perf-fm [7 3] (gen-sieve 7 (U [4 0] [3 1])) 3.0 0.25) 
   2.0 (sieve-chord perf-fm [8 3] (gen-sieve 7 [2 0]) 8.0 0.05)   
   3.0 gliss-fragment 
   ])

;; UTILITY FUNCTIONS
(defn play-from 
  "Plays score starting from a given measure"
  [^double measure]
  (->>
    (convert-measured-score score)
    (starting-at (* measure 4))
    (map #(apply s %))
    (add-events)
    ))


;; TEMPORAL RECURSION

(defn cause [func start & args]
  "Implementation of Canon-style cause function"
  (add-events (apply event func start args)))

(defn echoes 
  "Temporally-recursive function for performing echoes"
  [perf-fn counter dur delta-time freq amp]
  (let [new-count (dec counter)
        new-amp (* amp 0.5)]
    ;; perform fm instrument
    (perf-fn dur freq amp) 
    (when (>= new-count 0)
      (cause echoes delta-time perf-fn new-count 
             dur delta-time freq new-amp))))

;; partial function applications to make custom echoes functions
(def fm-echoes (partial echoes perf-fm))
(def ringm-echoes (partial echoes perf-ringm))

;; CONTROL FUNCTION
(defn pulsing
  "Triggers ringm instrument and given frequency and delta-buffer time as atoms. User can adjust values for args externally."
  [done-atm freq delta-buffers]
  (let [counter (atom 0)]
    (fn []    
      (when (not @done-atm)
        (swap! counter inc)
        (when (>= @counter @delta-buffers) 
          (cause perf-ringm 0.0 5.0 @freq 
                 (env [0 0.0 2.5 0.5 2.5 0.0]))
          (reset! counter 0))
        true))))

;; REAL-TIME PERFORMANCE FUNCTIONS 
;; evaluate the below at REPL to perform live
(comment

  (start-engine)

  ;; use temporal recursion
  (cause fm-echoes 0.0 5 0.25 1.5 400.0 0.5)
  (cause fm-echoes 0.0 5 0.25 3.5 900.0 0.5)
  (cause fm-echoes 0.0 5 0.25 4.5 800.0 0.5)
  (cause fm-echoes 0.0 5 0.25 3.0 1500.0 0.5)
  (cause ringm-echoes 0.0 5 0.25 2.5 220.0 0.5)
  (cause ringm-echoes 0.0 5 0.25 4.25 60.0 0.5)
  (cause ringm-echoes 0.0 5 0.25 4.25 51.0 0.5)


  ;; play score 
  (play-from 0)
  (play-from 2)

  ;; play just glissando part
  (play-from 3.0)


  (def done-atm (atom false))
  (def freq (atom 31.0))
  (def delta-buffers (atom 3200))

  (def done-atm2 (atom false))
  (def freq2 (atom 33.0))
  (def delta-buffers2 (atom 3500))

  ;; performing control function
  (reset! done-atm true)
  (reset! done-atm false)

  (reset! done-atm2 true)
  (reset! done-atm2 false)

  (reset! freq 31.0)
  (reset! freq2 33.0)

  (reset! freq 41.0)
  (reset! freq2 44.0)

  (reset! delta-buffers 5300)  
  (reset! delta-buffers2 4700)  

  (add-post-cfunc (pulsing done-atm freq delta-buffers))
  (add-post-cfunc (pulsing done-atm2 freq2 delta-buffers2))

  ;; engine stop
  (clear-engine)
  (stop-engine)

  )

