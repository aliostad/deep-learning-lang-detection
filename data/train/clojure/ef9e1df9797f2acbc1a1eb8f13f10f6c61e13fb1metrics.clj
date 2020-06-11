(ns ^{:doc
  "Logger LCMAP REST Service metrics component

  For more information, see the module-level code comments in
  ``lcmap.rest.components``."}
  lcmap.rest.components.metrics
  (:require [clojure.tools.logging :as log]
            [com.stuartsierra.component :as component]
            [metrics.jvm.core :as metrics-jvm]
            [metrics.reporters.jmx :as metrics-jmx]
            [dire.core :refer [with-handler!]]))

(defrecord Metrics []
  component/Lifecycle

  (start [component]
    (log/info "Setting up LCMAP metrics ...")
    (metrics-jvm/instrument-jvm)
    (-> {}
        (metrics-jmx/reporter)
        (metrics-jmx/start))
    component)

  (stop [component]
    (log/info "Tearing down LCMAP metrics ...")
    (log/debug "Component keys" (keys component))
    component))

(defn new-metrics []
  (->Metrics))

;; Starting this component more than once, as occurs during a project refresh,
;; generates an exception:
;; "A metric named jvm.attribute.vendor already exists"
;; ...which makes sense given the JVM itself isn't reloaded. However, there
;; isn't an inverse of `instrument-jvm` so handling the exception seems to be
;; our only choice.

(with-handler! #'metrics-jvm/instrument-jvm
  java.lang.IllegalArgumentException
  (fn [e & [compoentn]]
    (log/warn (str "Failed to (re)instrument jvm; has instrumentation "
                   "already been set up? This may be safely ignored when "
                   "reloading project namespaces."))))
