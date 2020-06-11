(ns bluegenes.api
  (:require [re-frame.core :as re-frame]))

(defn has-something [location data]
  ;(println "API: has-something called with data" data)
  (re-frame/dispatch [:update-node location #(assoc % :output data)]))

(defn save-state [location data]
  ;(println "API: save-state called with data" location data)
  (re-frame/dispatch [:update-node location #(assoc % :state data)]))

(defn transaction [location function]
  ;(println "API: transaction called with data")
  (re-frame/dispatch [:update-node location function]))

(defn save-cache [location data]
  ;(println "API: save-cached called (ignoring data)" location data)
  (re-frame/dispatch [:update-node location #(assoc % :cache data)]))

(defn update-cache [location function]
  ;(println "API: save-update-cache called (ignoring data)" location function)
  (re-frame/dispatch [:update-node location #(update % :cache function)]))

(defn update-state [location function]
  ;(println "API: save-update-cache called (ignoring data)" location function)
  (re-frame/dispatch [:update-node location #(update % :state function)]))

(def api {:has-something (partial has-something :someid)})

