(ns ^{:doc "Manage system composed of services"}
  t3chnique.system
  (:require [t3chnique.services.vm-store :as store]
            [t3chnique.services.game-catalogue :as catalogue]
            [t3chnique.services.http :as http]
            [com.stuartsierra.component :as component]))

(defn system
  "Construct a t3chnique system from components."
  []
  (component/system-map
   :vm-store (store/create-store)
   :game-catalogue (catalogue/create-game-catalogue)
   :http (component/using (http/create-server) [:vm-store :game-catalogue])))
