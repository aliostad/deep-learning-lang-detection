(ns uqunsa-sim.test.utils
  (:require [clojure.spec.alpha :as s]
            [clojure.spec.gen.alpha :as gen]
            [clojure.spec.test.alpha :as stest]
            [clojure.test :refer :all]
            ))

(defn instrument-namespace
  "Instruments everything in the specified namespace"
  [ns]
  (->> (stest/enumerate-namespace ns)
       (map stest/instrument)
       flatten
       ;; If we need results summarised later, this is what to call
       ;(map stest/summarize-results)
       ))

(defn instrument-and-check-namespace
  "Instruments a namespace, and performs stest/check on it"
  [ns]
  (map stest/check (instrument-namespace ns)))

(defn instrument-all-namespaces
  "Turns on instrumentation for all namespaces it can see
  (basically only the user's test namespaces).
  Returns a list of all the functions that have been instrumented"
  []
  (->> (all-ns)
       (map ns-name)
       (map instrument-namespace)
       flatten
       ))
