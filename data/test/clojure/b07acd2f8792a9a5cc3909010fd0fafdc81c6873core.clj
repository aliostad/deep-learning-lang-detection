(ns ssounds.core
  (:use [overtone.core]
   [ssounds.instrument :only [bell bass babs kick]]))

(def pats {bell [ 0 1 0 0 0 1 0 1]
           babs [ 0 0 [0 0 1] 1 0 1 0 0 0]
           kick [ 1 0 1 0 1 0 1 1]})

(def live-pats (atom pats))

(defn live-sequencer
  ([curr-t sep-t live-patterns] (live-sequencer curr-t sep-t live-patterns 0))
  ([curr-t sep-t live-patterns beat]
     (doseq [[sound pattern] @live-patterns
             :when (= 1 (nth pattern (mod beat (count pattern))))]
       (at curr-t (sound)))
     (let [new-t (+ curr-t sep-t)]
       (apply-at new-t #'live-sequencer [new-t sep-t live-patterns (inc beat)]))))

(live-sequencer (+ 100 (now) ) 250 live-pats 1000)

(swap! live-pats assoc bass [ 0 ])

(swap! live-pats assoc kick [ 0 0 0 0 0 1 0 0])

(swap! live-pats assoc bell [ 0 ])


;; (inst-fx! bell fx-reverb)

;; (inst-fx! kick fx-rlpf)

;; (inst-fx! kick fx-distortion)

;; (inst-fx! babs fx-distortion)

;; (clear-fx bell)

;; (clear-fx kick)

;; (clear-fx bass)

(stop)
