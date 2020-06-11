(ns plinth.metrics
  (:require
    [metrics.core :as m]
    [metrics.timers :as timers]
    [metrics.meters :as meters]
    [metrics.counters :as counters]
    [metrics.histograms :as histograms]
    [metrics.reporters :as reporters]
    [metrics.ring.instrument :refer [instrument]]
    [com.stuartsierra.component :as component])
  (:import
    [com.codahale.metrics Slf4jReporter Slf4jReporter$LoggingLevel]))

; name: [group, type, metric name]
; use metrics-clojure-healthchecks to determine if we are healthy enough for the load balancer

(defrecord Metrics []
  component/Lifecycle
  (start [this]
    (let [registry (m/new-registry)
          reporter
          (->
            (Slf4jReporter/forRegistry registry)
            (.withLoggingLevel Slf4jReporter$LoggingLevel/TRACE)
            (.build))]
      (reporters/start reporter (* 5 60))
      (assoc this :registry registry :reporter reporter)))
  (stop [this]
    (when (:reporter this)
      (reporters/stop (:reporter this)))
    (when (:registry this)
      (m/remove-all-metrics (:registry this)))
    (dissoc this :registry :reporter)))

(defn inc! [m key & [value]]
  (counters/inc! (counters/counter (:registry m) key) (or value 1)))

(defn dec! [m key & [value]]
  (counters/dec! (counters/counter (:registry m) key) (or value 1)))

(defn value [m key]
  (counters/value (counters/counter (:registry m) key)))

(defn mark! [m key]
  (meters/mark! (meters/meter (:registry m) key)))

(defn rates [m key]
  (meters/rates (meters/meter (:registry m) key)))

(defn update! [m key value]
  (histograms/update! (histograms/histogram (:registry m) key) value))

(defn statistics [m key]
  (let [histogram (histograms/histogram (:registry m) key)]
    { :percentiles (histograms/percentiles histogram)
      :count       (histograms/number-recorded histogram)
      :min         (histograms/smallest histogram)
      :max         (histograms/largest histogram)
      :mean        (histograms/mean histogram)
      :std-dev     (histograms/std-dev histogram) }))

(defmacro time! [m key & body]
  `(.time (timers/timer (:registry ~m) ~key)
      (proxy [Callable] []
        (call [] (do ~@body)))))

(defn timer-statistics [m key]
  (let [timer (timers/timer (:registry m) key)]
    { :percentiles (timers/percentiles timer)
      :count       (timers/number-recorded timer)
      :min         (timers/smallest timer)
      :max         (timers/largest timer)
      :mean        (timers/mean timer)
      :std-dev     (timers/std-dev timer) }))

(defn remove! [m key]
  (m/remove-metric (:registry m) key))
