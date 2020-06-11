(ns reagent-components-playground.data
    (:require [reagent.core :refer [atom]]))

;;here ALL app data goes

(def app-state 
  (atom {:edit false
         :data {:text-before "Keep calm"
                :text-after "carry on"}}))




;; event system

(def dispatch-table (atom{}))

(defn set-dispatch [name fx]
  (do
    (println (str "Registered " name)) 
    (swap! dispatch-table assoc name fx)))

(defn dispatch [name]
  (do
    (println (str "Dispatching " name))
    ((get @dispatch-table name))))



              
              
