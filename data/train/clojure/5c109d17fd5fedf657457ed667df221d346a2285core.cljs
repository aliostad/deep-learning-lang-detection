(ns review.ios.core
  (:require [reagent.core :as r :refer [atom]]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [review.events]
            [review.subs]
            [review.navigator :refer [app-navigator]]))

(def ReactNative (js/require "react-native"))

(def app-registry (.-AppRegistry ReactNative))




(defn app-root []
      (fn []
          [app-navigator]))

(defn init []
      (dispatch-sync [:initialize-db])
      (.registerComponent app-registry "review" #(r/reactify-component app-root)))
