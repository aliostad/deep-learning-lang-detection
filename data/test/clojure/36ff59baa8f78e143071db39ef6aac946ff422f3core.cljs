(ns memegen-ui.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [memegen-ui.events]
              [memegen-ui.subs]
              [memegen-ui.views :as views]
              [memegen-ui.config :as config]))

(defn setup-browser-listeners []
  (.addEventListener js/window
                     "resize"
                     (fn [] (re-frame/dispatch [:window-resizing])))
  (re-frame/dispatch [:window-resizing]))

(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode, for real")))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:get-init-data])
  (dev-setup)
  (mount-root)
  (setup-browser-listeners))
