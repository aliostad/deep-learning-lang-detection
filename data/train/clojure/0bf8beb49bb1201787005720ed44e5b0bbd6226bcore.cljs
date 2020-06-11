(ns ggj17.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [ggj17.events]
              [ggj17.subs]
              [ggj17.views :as views]
              [ggj17.config :as config]
              ))


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
  ;; (re-frame/dispatch-sync [:get-backdrops])
  ;; (re-frame/dispatch-sync [:get-characters])
  ;; (re-frame/dispatch-sync [:get-objects])
  ;; (re-frame/dispatch-sync [:backdrop "backdrops/beach1.svg"])
  (re-frame/dispatch-sync [:set-character "characters/rex.svg"])
  (re-frame/dispatch-sync [:foot "objects/foot.svg"])
  (dev-setup)
  (mount-root))
