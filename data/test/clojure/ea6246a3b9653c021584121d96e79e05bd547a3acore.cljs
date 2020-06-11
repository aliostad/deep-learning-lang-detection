(ns sonnenzeit.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [sonnenzeit.events]
            [sonnenzeit.subs]
            [sonnenzeit.views :as views]
            [sonnenzeit.config :as config]))


(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode")))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  ; (re-frame/dispatch [:request-suntimes])
  (re-frame/dispatch [:request-geolocation])
  (dev-setup)
  (mount-root))
