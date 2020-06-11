(ns albatross.tools.services
  (:require
    [clojure.java.io :as io]
    [com.stuartsierra.component :as component]
    [nomad :refer [defconfig]]
    ))


;; Configuration Management
;; ------------------------

(defconfig services-config (io/file "./resources/config/services.edn"))

(defn list-services []
  (:services (services-config)))

(defn configuration-for [name & [more-config]]
  "Load a service configuration by NAME.
  Merge with MORE-CONFIG if set."
  (-> (services-config)
      (get-in [:services-configuration name])
      (merge more-config)))

(defn load-services [str-services]
  (->> str-services
       (map keyword)
       (map configuration-for)
       (into [])))


;; Services Management
;; -------------------

;; TODO: differentiate components and systems. former are configured, latter are instanciated with stuart's dependencies

;; The Component Store manage running systems & components
;; Associate SERVICE-NAME -> SYSTEM or COMPONENT
(def component-store (agent {}))

(defn comp-restart
  "Stop C then build a new instance of the component using BUILDER.
  Start and return it."
  [c builder]
  (component/stop c)
  (component/start (builder)))

(defn toggle
  "Start or restart a system identified by ID,
  Build the component using the BUILDER function."
  [id builder]
  (send component-store
        (fn [store]
          (if (contains? store id)
            (update-in store [id] comp-restart builder)
            (assoc store id (component/start (builder)))))))

(defn stop [id]
  (send component-store
        (fn [store]
          (if (contains? store id)
            (do
              (component/stop (get store id))
              (dissoc store id))
            store))))
