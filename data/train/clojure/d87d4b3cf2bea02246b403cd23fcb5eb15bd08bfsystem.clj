(ns {{ns-name}}.components.system
  (:require [com.stuartsierra.component :as component]
            [metrics.core :refer [new-registry]]
            [metrics.jvm.core :as jvm]
            [{{ns-name}}.components.graphite.lifecycle :refer [new-metrics-reporter]]
            [{{ns-name}}.components.jetty.lifecycle :refer [new-web-server]]
            [{{ns-name}}.logging-config]))

(def components [:web-server
                 :metrics-registry
                 :metrics-reporter])

(defrecord Quotations-Web-System []
  component/Lifecycle
  (start [this]
    (component/start-system this components))
  (stop [this]
    (component/stop-system this components)))

(defn new-{{ns-name}}-system
  "Constructs the component system for the application."
  []
  (let [metrics-registry (new-registry)]
    (jvm/instrument-jvm metrics-registry)
    (map->Quotations-Web-System
     {:web-server       (component/using (new-web-server) [:metrics-registry])
      :metrics-reporter (component/using (new-metrics-reporter) [:metrics-registry])
      :metrics-registry metrics-registry})))
