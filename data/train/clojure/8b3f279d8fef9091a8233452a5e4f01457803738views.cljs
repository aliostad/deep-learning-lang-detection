(ns hackernews.scenes.front-page.views
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [hackernews.components.story-row :as sr]
            [hackernews.components.list :as l]
            [hackernews.components.react-native.core :as rn]))

(defn- front-page-row
  [story]
  [rn/touchable-highlight {:on-press #(dispatch-sync [:nav-story-detail (:id story)])
                           :key (:id story)}
   (sr/story-row {:story story})])

(defn front-page
  [{:keys [navigation]}]
  [rn/view
   [l/list-view {::l/items (or @(subscribe [:get-front-page-stories]) [])
                 ::l/render-row #(front-page-row %)
                 ::l/on-end-reached #(dispatch [:load-front-page-stories])}] ])

(defn navigation-options
  []
  (clj->js {:title "Front Page"}))
