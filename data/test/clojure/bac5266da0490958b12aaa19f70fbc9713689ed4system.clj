(ns {{ns-name}}.components.system
  (:require [com.stuartsierra.component :as component]
            [metrics.core :refer [new-registry]]
            [metrics.jvm.core :as jvm]
            [{{ns-name}}.components.graphite.lifecycle :refer [new-metrics-reporter]]
            [{{ns-name}}.components.mongodb.lifecycle :refer [new-mongodb]]
            [{{ns-name}}.components.jetty.lifecycle :refer [new-web-server]]
            [{{ns-name}}.controllers.people.lifecycle :refer [new-people-controller]]
            [{{ns-name}}.logging-config]))

(def components [:web-server
                 :mongodb
                 :metrics-registry
                 :people
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
     {:web-server       (component/using (new-web-server) [:metrics-registry :people])
      :mongodb          (new-mongodb)
      :metrics-reporter (component/using (new-metrics-reporter) [:metrics-registry])
      :people           (component/using (new-people-controller) [:mongodb])
      :metrics-registry  metrics-registry})))
