(ns koomus.trees.metrics
  (:require 
    [com.stuartsierra.component :as component]
    [metrics.jvm.core :refer [instrument-jvm]]
    [metrics.reporters.graphite :as graphite]
    [metrics.core :refer [new-registry]]
    [clojure.string :refer [blank?]])
  (:import 
    [java.util.concurrent TimeUnit]
    [com.codahale.metrics MetricFilter]))

(defn- generate-reporter
  [reg {:keys [host port prefix]}]
  (graphite/reporter reg {:host host
                          :port port
                          :prefix prefix
                          :rate-unit TimeUnit/SECONDS
                          :duration-unit TimeUnit/MILLISECONDS
                          :filter MetricFilter/ALL}))

(defn- init-reporter
  [this]
  (let [reg (new-registry)]
    (instrument-jvm reg)
    (let [reporter (generate-reporter reg this)]
      (graphite/start reporter 10)
      reporter)))

(defn- convert-port
  [port]
  (when (not (blank? port))
    (java.lang.Integer/parseInt port)))

(defn- start
  [{:keys [gr port host prefix] :as this}]
  (if (not (or (nil? port) (blank? host) (blank? prefix)))
    (if gr
      (do (graphite/start gr 10) this)
      (->> this init-reporter (assoc this :gr)))
    this))

(defn- stop
  [{:keys [gr] :as this}]
  (graphite/stop gr)
  this)

(defrecord Metrics [host port prefix]
  component/Lifecycle
  (start [this]
    (start this))
  (stop [this]
    (stop this)))

(defn new-metrics [host port prefix]
  (map->Metrics {:host host
                 :port (convert-port port)
                 :prefix prefix}))
