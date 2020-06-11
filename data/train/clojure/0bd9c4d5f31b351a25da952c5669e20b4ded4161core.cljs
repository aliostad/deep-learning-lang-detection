(ns life.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [life.events]
              [life.subs]
              [life.views :as views]
              [life.config :as config]))


(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode")))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn dispatch-tick-event
  []
  (let [now (.now js/Date)]
    (re-frame/dispatch [:tick])))

(defonce do-timer (js/setInterval dispatch-tick-event 500))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (dev-setup)
  (mount-root))
