(ns components.metrics.service
  (:require
    [pallet.thread-expr :as th]
    [metrics.reporters.console :as console-reporter]
    [metrics.reporters.graphite :as graphite-reporter]
    [metrics.reporters :as rmng]
    [metrics.core]
    [metrics.jvm.core]
    [metrics.counters :as counters]
    [metrics.gauges :as gauges]
    [metrics.histograms :as histograms]
    [metrics.meters :as meters]
    [metrics.timers :as timers]
    [components.lifecycle.protocol]
    [components.metrics.protocol]
    [components.metrics.instrument :as instrument]))

(defn- start-console-reporter
  [registry report-freq]
  (rmng/start (console-reporter/reporter registry #{}) report-freq))

(defn- get-host-name
  []
  (.getHostName (java.net.InetAddress/getLocalHost)))

(defn- start-graphite-reporter
  [registry config]
  (rmng/start (graphite-reporter/reporter registry
                                          (-> config
                                              (th/when-not-> (:prefix config)
                                                         (assoc :prefix (get-host-name)))
                                              (dissoc :freq :enabled)))
              (or (:freq config)
                  10)))

(defrecord SystemMonitor [state]
  components.metrics.protocol/Metrics

  (add-counter! [this id title]
    (let [registry (:metrics-registry @state)
          current  (:current/counters @state)]
      (swap! current assoc id (counters/counter registry title))))

  (counter? [this id]
    (get @(:current/counters @state) id))

  (inc-counter! [this id]
    (components.metrics.protocol/inc-counter! this id 1))

  (inc-counter! [this id value]
    (if-let [counter (get @(:current/counters @state) id)]
      (counters/inc! counter value)
      (throw (RuntimeException. (str "unknown counter " id)))))

  (dec-counter! [this id]
    (components.metrics.protocol/dec-counter! this id 1))

  (dec-counter! [this id value]
    (if-let [counter (get @(:current/counters @state) id)]
      (counters/dec! counter value)
      (throw (RuntimeException. (str "unknown counter " id)))))

  (add-gauge! [this id title function]
    (let [registry (:metrics-registry @state)
          current  (:current/gauges @state)]
      (swap! current assoc id (gauges/gauge-fn registry title function))))

  (gauge? [this id]
    (get @(:current/gauges @state) id))

  (add-histogram! [this id title]
    (let [registry (:metrics-registry @state)
          current  (:current/histograms @state)]
      (swap! current assoc id (histograms/histogram registry title))))

  (histogram? [this id]
    (get @(:current/histograms @state) id))

  (add-meter! [this id title]
    (let [registry (:metrics-registry @state)
          current  (:current/meters @state)]
      (swap! current assoc id (meters/meter registry title))))

  (meter? [this id]
    (get @(:current/meters @state) id))

  (mark-meter! [this id]
    (components.metrics.protocol/mark-meter! this id 1))

  (mark-meter! [this id value]
    (if-let [meter (get @(:current/meters @state) id)]
      (meters/mark! meter value)
      (throw (RuntimeException. (str "unknown meter " id)))))

  (update-histogram! [this id value]
    (if-let [histogram (get @(:current/histograms @state) id)]
      (histograms/update! histogram value)
      (throw (RuntimeException. (str "unknown histogram" id)))))

  (add-timer! [this id title]
    (let [registry (:metrics-registry @state)
          current  (:current/timers @state)]
      (swap! current assoc id (timers/timer registry title))))

  (timer? [this id]
    (get @(:current/timers @state) id))

  (get-timer [this id]
    (get @(:current/timers @state) id))

  components.metrics.protocol/RegistryHolder
  (get-registry [this]
    (:metrics-registry @state))

  components.lifecycle.protocol/Lifecycle
  (start [this system]
    (let [service-registry (metrics.core/new-registry)
          conf (:configuration @state)]
      (swap! state assoc
             :metrics-registry service-registry
             :current/counters   (atom {})
             :current/gauges     (atom {})
             :current/histograms (atom {})
             :current/meters     (atom {})
             :current/timers     (atom {}))
      ;;we have to delay the instrumentation of namespaces in order to give some time to the
      ;;jvm to load them all
      (.start (Thread.  #(do (Thread/sleep 1000)
                             (doseq [rootns (:instrument-namespaces conf)]
                               (instrument/instrument-all this rootns)))))
      (when (:instrument-jvm conf)
        (metrics.jvm.core/instrument-jvm service-registry))
      (when (get-in conf [:console-reporter :enabled])
        (start-console-reporter service-registry (get-in conf [:console-reporter :freq])))
      (when (get-in conf [:graphite-reporter :enabled])
        (start-graphite-reporter
          service-registry
          (:graphite-reporter conf)))))

(stop [this system]))

(defrecord DummySystemMonitor [state]
  components.metrics.protocol/Metrics
  (add-counter! [this id title] true)
  (counter? [this id] true)
  (inc-counter! [this id] true)
  (inc-counter! [this id value] true)
  (dec-counter! [this id] true)
  (dec-counter! [this id value] true)
  (add-gauge! [this id title function] true)
  (gauge? [this id] true)
  (add-histogram! [this id title] true)
  (histogram? [this id] true)
  (add-meter! [this id title] true)
  (meter? [this id] true)
  (mark-meter! [this id] true)
  (mark-meter! [this id value] true)
  (update-histogram! [this id value] true)
  (add-timer! [this id title] true)
  (timer? [this id] true)
  (get-timer [this id] nil)
  components.metrics.protocol/RegistryHolder
  (get-registry [this]
    (:metrics-registry @state))
  components.lifecycle.protocol/Lifecycle
  (start [this system] true)
  (stop[this system] true))

(defn make
  "Creates a monitor metrics server component"
  [pconfig]
  (let [default-config {:application-name "dummy"
                        :instrument-jvm true
                        :graphite-reporter {:enabled false
                                            :host "localhost"
                                            :port 2003
                                            :freq 10}
                        :console-reporter {:enabled false
                                           :freq 10}}
        config (merge-with #(if (map? %1) (merge %1 %2) %2)
                           default-config
                           pconfig)]
    (if (or (get-in config [:graphite-reporter :enabled])
            (get-in config [:console-reporter :enabled]))
      (->SystemMonitor (atom {:configuration config}))
      (->DummySystemMonitor (atom {:metrics-registry (metrics.core/new-registry)})))))

(defn make-dummy-system-monitor []
  (->DummySystemMonitor (atom {:metrics-registry (metrics.core/new-registry)})))

(def ^:dynamic *current-monitor* nil)

(defn monitor [] *current-monitor*)
