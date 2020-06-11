(ns fluxion-test
  (:require [clojure.core.async :refer [chan <!! onto-chan]]
            [fluxion :refer :all]
            [clojure.test :refer :all]
            [clojure.set :as set]
            [clojure.data.generators :as gen]
            [clojure.test.generative :refer [defspec]]
            [clojure.test.generative.runner :as runner]))

(defspec values-from-channel-appear-in-atom
  (fn [vs] (let [ch (chan 1)
                 a (atom nil)
                 terminal (onto-chan ch vs)]
             (<!! (atom-sink a ch))
             @a))
  [^{:tag (gen/vec gen/long)} vs]
  (assert (= % (last vs))
          (str "Atom sink's last value " % " did not match last value of " vs)))

(defspec sink-calls-function-with-every-value
  (fn [vs] (let [ch (chan 1)
                 a (atom [])
                 terminal (onto-chan ch vs)]
             (<!! (sink #(swap! a conj %) ch))
             [@a vs]))
  [^{:tag (gen/vec gen/string)} vs]
  (assert (apply = %)
          (str "Accrued values " (first %) " did not match input values" vs)))

;; Do too much math so that missing one beat doesn't mean each
;; subsequent beat is 100% error in the check.
(defspec timer-is-roughly-periodic
  (fn [interval beats]
    (let [t (timer interval)
          ticks (loop [ticks []
                       beats-to-go beats]
                  (if (< 0 beats-to-go)
                    (recur (conj ticks (<!! t))
                           (dec beats-to-go))
                    ticks))
          lt (last ticks)
          target-schedule (take-while #(<= % lt) (iterate (partial + interval) (first ticks)))]
      [ticks target-schedule]))
  [^{:tag (gen/uniform 80 120)} interval ^{:tag (gen/uniform 80 120)} beats]
  (let [ticks (first %)
        target-schedule (nth % 1)
        error (memoize (fn [target observed]
                         (Math/abs (- target observed))))
        errors (into {}
                     (map
                      (fn [[k v]]
                        [k (sort-by last v)])
                      (group-by first
                                (for [target target-schedule]
                                  (let [nearest-tick (apply min-key
                                                            (partial error target)
                                                            ticks)]
                                    [nearest-tick target (error target nearest-tick)])))))
        tick-errors (for [tick ticks]
                      (/ (or (last (first (errors tick)))
                             interval) interval))
        avg-error (/ (apply + tick-errors) (count tick-errors))
        picked-targets  (map #(nth (first %) 1) (vals errors))
        missed-targets (set/difference (set target-schedule)
                                       (set picked-targets))]
    (assert (<= avg-error 1/10) (str "Average error " 1/10 " greater than " 1/10))
    (assert (< (/ (count missed-targets) beats) 1/10)
            (str "Missed target points " (count missed-targets)
                 " greater than " (* 1/10 beats)))))

#_(defspec timer-doesnt-generate-threads
  (fn [timer-count intervals]
    (let [starting-threads (keys (Thread/getAllStackTraces))
          intervals-sched (cycle intervals)
          timers (doseq [interval intervals-sched]
                        (timer interval))]
      [intervals-sched timers starting-threads (keys (Thread/getAllStackTraces))]))
  [^{:tag (gen/uniform 1 2)} timer-count ^{:tag (gen/vec gen/long)} intervals]
  (let [[intervals-sched timers starting-threads ending-threads] %]
    (assert (<= (+ (count starting-threads) 1) (count ending-threads)))))

(comment (runner/run 2 10000 #'values-from-channel-appear-in-atom #'sink-calls-function-with-every-value))

;; Creating multiple timers should not create multiple threads.
;;
;; Ideally we can drive the sleep loop in one thread iterating at the
;; lowest common denominator of all extant clock cycles, and then send
;; to channels modolu their multiple of that lcd tick cycle.
;;
;; Doing so means having a new potential clock client which requires a
;; faster cycle period than the current clock. We need to decouple the
;; signaling channels from the iterating process so that the iterating
;; process can be replaced.
;;
;; This means clock system needs to both manage the modulo on a per
;; client basis, and swapping clock beats at the inputs of all
;; clients' channels.
;;
;; Ideally we can reclaim clock channels from consumers who stop using
;; them. Holding weak references to the clock channels should enable
;; this (but means modulo channels need to be tolerant to the weak ref
;; having been GCed and then shutting down cleanly.