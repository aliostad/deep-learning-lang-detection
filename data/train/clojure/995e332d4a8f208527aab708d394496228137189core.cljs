(ns hackernews.core
  (:require [reagent.core :as r :refer [atom]]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [hackernews.events]
            [hackernews.subs]
            [hackernews.scenes.front-page.subs]
            [hackernews.scenes.front-page.events]
            [hackernews.scenes.detail-view.subs]
            [hackernews.scenes.detail-view.events]
            [hackernews.navigation :as nav]
            [hackernews.components.react-native.core :as rn]))

(defn app-root []
  (fn []
    [nav/navigation-root]))

(defn init []
  (dispatch-sync [:initialize-db])
  (dispatch [:load-front-page-stories])
  (.registerComponent rn/app-registry "hackernews" #(r/reactify-component app-root)))
