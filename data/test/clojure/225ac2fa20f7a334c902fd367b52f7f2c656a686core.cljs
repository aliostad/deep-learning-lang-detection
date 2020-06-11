(ns formatron.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [re-frisk.core :refer [enable-re-frisk!]]
              [formatron.events]
              [formatron.subs]
              [formatron.routes :as routes]
              [formatron.views :as views]
              [formatron.config :as config]))


(ns formatron.config
  )

(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (enable-re-frisk!)
    (println "dev mode")))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (routes/app-routes)
  (re-frame/dispatch-sync [:init])
  (dev-setup)
  (mount-root))

(defn dispatch-timer-event
  []
  (let [now (js/Date.)]
    (re-frame/dispatch [:timer now])))

(defonce do-timer (js/setInterval dispatch-timer-event 1000))
