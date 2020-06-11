(ns outpace.metrics-delivery.core
  "Conveniently start metric reporters from data (configuration)."
  (:require
    [metrics.core :as metrics]
    [metrics.jvm.core :as jvm]
    [metrics.reporters.graphite :as graphite]
    [metrics.reporters.jmx :as jmx]
    [metrics.reporters.csv :as csv]
    [metrics.reporters.console :as console]
    [metrics.ring.instrument :as metrics-ring]
    [outpace.metrics-delivery.ring :as ring])
  (:import
    [java.util.concurrent TimeUnit]
    [com.codahale.metrics MetricFilter]))

(def constructor
  {:jmx jmx/reporter
   :graphite graphite/reporter
   :csv #(csv/reporter "./" %)
   :console console/reporter})

(def starter
  {:jmx (fn [reporter period] (jmx/start reporter))
   :graphite graphite/start
   :csv csv/start
   :console console/start})

(def stopper
  {:jmx jmx/stop
   :graphite graphite/stop
   :csv csv/stop
   :console console/stop})

(def keywords
  {:all MetricFilter/ALL
   :seconds TimeUnit/SECONDS
   :milliseconds TimeUnit/MILLISECONDS
   :microseconds TimeUnit/MICROSECONDS
   :nanoseconds TimeUnit/NANOSECONDS
   :minutes TimeUnit/MINUTES
   :hours TimeUnit/HOURS
   :days TimeUnit/DAYS})

(def jvm-instrumentation
  {:file-descriptor-ratio jvm/register-file-descriptor-ratio-gauge-set
   :garbage-collector jvm/register-garbage-collector-metric-set
   :jvm-attribute jvm/register-jvm-attribute-gauge-set
   :memory-usage jvm/register-memory-usage-gauge-set
   :thread-state jvm/register-thread-state-gauge-set})

(def ring-instrumentation
  {:by-method metrics-ring/instrument
   :by-uri ring/instrument-by-uri
   :by-routes ring/instrument-by-routes})

(defn javaize [options]
  (into {}
        (for [[k v] options]
          [k (get keywords v v)])))

;; TODO: singletons aren't great
(def reporters [])

(defn stop-metrics []
  (doseq [[k v] reporters
          :let [stop (stopper k)]]
    (if stop
      (stop v)
      (throw (ex-info "No stopper found"
                      {:k k
                       :available (keys stopper)}))))
  (alter-var-root #'reporters (constantly nil)))

(def attached false)

(defn start
  "Instruments and starts reporting from configuartion.
  {:instrument {instrument-type instrument-options}
   :report {reporter-type reporter-options}}
  Where instrument-type is one of :jvm :ring
  And reporter-type is one of :jmx :graphite :csv :console
  Also you can specify :period in seconds."
  [{:keys [report instrument]}]
  (when reporters
    (stop-metrics))
  (when-let [{:keys [jvm ring]} instrument]
    (when jvm
      (cond
        (= :all jvm) (jvm/instrument-jvm)
        (and (sequential? jvm) (every? (set (keys jvm-instrumentation)) jvm))
        (doseq [k jvm]
          ((jvm-instrumentation k) metrics/default-registry))
        :else (throw (ex-info (str "JVM must be :all or a seq containing " (keys jvm-instrumentation))
                              {:jvm jvm}))))
    (when (and ring (not attached))
      (alter-var-root #'attached (constantly true))
      (if-let [handler (some-> ring :handler resolve)]
        (let [{:keys [by-method by-uri by-routes]} ring]
          (if (or by-method by-uri by-routes)
            (alter-var-root handler
              (constantly
                (cond-> @handler
                  by-method (metrics-ring/instrument)
                  by-uri (ring/instrument-by-uri)
                  by-routes (ring/instrument-by-routes by-routes))))
            (throw (ex-info "Must specify at least one of by-method by-uri by-routes"
                            {:ring ring}))))
        (throw (ex-info "Could not resolve handler"
                        {:ring ring})))))
  (alter-var-root #'reporters
    (constantly
      (vec
        (for [[k options] report
              :let [create (constructor k)
                    start (starter k)]]
          [k
           (cond
             (not (map? options))
             (throw (ex-info "Options must be a map"
                             {:k k
                              :options options}))
             (not (and create start))
             (throw (ex-info "No constructor found"
                             {:k k
                              :available (keys constructor)}))
             :else
             (doto (create (javaize options))
               (start (get options :period 10))))]))))
  stop-metrics)
