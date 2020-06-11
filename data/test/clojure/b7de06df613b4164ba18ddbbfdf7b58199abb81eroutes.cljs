(ns cia.routes
  (:require [goog.events :as events]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary :refer-macros [defroute]])
  (:import goog.History
           goog.History.EventType))

(defn- ->int [x]
  (when x (js/parseInt x)))

(defn- ->boolean
  [x]
  (if x
    (not (contains? #{"false" "0"} x))
    false))

(defn- inspect-dispatch
  ([url-path] (inspect-dispatch url-path nil))
  ([url-path url-params]
   (dispatch [:url-changed url-path url-params])))

(def home :home)
(def entity-detail :entity-detail)
(def attributes :attributes)

(defroute home-url
          "/"
          []
          (inspect-dispatch home))

(defroute entity-detail-url
          "/entity/:id"
          [id]
          (inspect-dispatch entity-detail {:entity-id (->int id)}))

(defroute attributes-url
          "/attributes"
          []
          (inspect-dispatch attributes))

(defroute
  "*"
  []
  (js/console.log "404"))

(secretary/set-config! :prefix "#")

(defn init!
  []
  (doto (History.)
    (goog.events/listen EventType.NAVIGATE
                        (fn [event]
                          (secretary/dispatch! (.-token event))))
    (.setEnabled true)))