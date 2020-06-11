(ns re-tasker.ios.core
  (:require [reagent.core :as r]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [re-tasker.app.handlers]
            [re-tasker.app.subs]
            [re-tasker.ios.ui :refer [app-registry navigator]]
            [re-tasker.ios.styles :refer [styles]]
            [re-tasker.ios.components.root :refer [react-root-scene-component]]))

(defn app-root []
  [navigator
    {:initial-route {:title "ReTasker"
                     :component react-root-scene-component
                     :title-text-color "#fff"
                     :shadow-hidden true
                     :tint-color "#fff"
                     :bar-tint-color "#74546A"
                     :translucent false
                     :right-button-title "+"
                     :on-right-button-press #(dispatch [:show-task-input])}

     :style (:app styles)}])

(defn init []
  (dispatch-sync [:initialize-db])
  (.registerComponent app-registry "ReTasker" #(r/reactify-component app-root)))
