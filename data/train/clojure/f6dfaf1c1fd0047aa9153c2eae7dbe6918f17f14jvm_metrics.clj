(ns samsara.trackit.jvm-metrics
  (:require [metrics.jvm.core :as jvm]))


(def instrumentations
  {:memory      jvm/register-memory-usage-gauge-set
   :files       jvm/register-file-descriptor-ratio-gauge-set
   :gc          jvm/register-garbage-collector-metric-set
   :threds      jvm/register-thread-state-gauge-set
   :attributes  jvm/register-jvm-attribute-gauge-set})


(defn instrument-jvm-metrics
  "Instruments the JVM to publish metrics about memory, gc, threads etc."
  [registry metrics-set]
  (case metrics-set
    ;; if :none or nil do nothing
    :none nil
    nil   nil

    ;; get all available
    :all  (instrument-jvm-metrics registry (keys instrumentations))

    ;; else - instrument only the given one
    (doseq [mx metrics-set]
      (when-let [instrfn (instrumentations mx)]
        (instrfn registry)))))
