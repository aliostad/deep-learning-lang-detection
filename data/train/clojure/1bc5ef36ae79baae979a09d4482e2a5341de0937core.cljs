(ns sentinel.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [re-frisk.core :refer [enable-re-frisk!]]
              [sentinel.events]
              [sentinel.subs]
              [sentinel.views :as views]
              [sentinel.config :as config]))


(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (enable-re-frisk!)
    (println "dev mode")))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn dispatch-timer-event
  []
  (let [now (js/Date.)]
    (re-frame/dispatch [:refresh-all now])))

(defonce do-timer (js/setInterval dispatch-timer-event 3000))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (dev-setup)
  (mount-root))
