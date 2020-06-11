(ns ideamind.test-util
  (:require [clojure.spec.test :as st])
  (:import (clojure.lang Namespace)))

(def test-iterations 40)

(defn instrument-namespaces []
  (let [syms (map (fn [^Namespace ns] (.getName ns)) (all-ns))]
    (map #(-> (st/enumerate-namespace %) st/instrument)
         syms)))

(defn check
  ([sym]
   (check sym {::clojure.spec.test.check/opts {:num-tests test-iterations}}))
  ([sym params]
   (let [outcome (st/check sym params)
         data    (-> outcome
                     first)
         failure (:failure data)
         result  (nil? failure)]
     (if data
       (println sym (:clojure.spec.test.check/ret data)))
     (if (empty? outcome)
       (println "No spec found for" sym))
     (and result (not (empty? outcome))))))
