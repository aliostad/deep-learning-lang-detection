(ns storybuilder.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [storybuilder.handlers]
              [storybuilder.subs]
              [storybuilder.views :as views]
              [storybuilder.config :as config]))

(when config/debug?
  (println "dev mode"))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch-sync [:load-tropes])
  (re-frame/dispatch-sync [:load-characters])
  (re-frame/dispatch [:load-objects])
  (re-frame/dispatch [:load-places])
  ;; (re-frame/dispatch [:load-stories])
  (mount-root))

