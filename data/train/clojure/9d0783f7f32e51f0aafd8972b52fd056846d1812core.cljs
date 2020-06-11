(ns client.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [client.handlers]
              [client.subs]
              [client.views :as views]
              [client.config :as config]))

(when config/debug?
  (println "dev mode"))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init [] 
  (re-frame/dispatch [:initialize-db])
  (re-frame/dispatch [:load-tropes])
  (re-frame/dispatch [:load-characters])
  (re-frame/dispatch [:load-archetypes])
  (mount-root))
