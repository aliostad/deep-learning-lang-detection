(ns text-style-example.core
    (:require [reagent.core :as r :refer [atom]]
              [re-frame.core :refer [subscribe dispatch dispatch-sync]]
              [text-style-example.handlers]
              [text-style-example.subs]
              [cljs-exponent.reagent :refer [text view image touchable-highlight] :as rn]))

(defn app-root []
  [view {:style {:margin-top 30}}
   [text {:style {:color "black"
                  :line-height 21}}
    [text {:style {:color "red"}}
     "red "]
    [text {:style {:color "green"}}
     "green"]]]
  )

(defn init []
  (dispatch-sync [:initialize-db])
  (.registerComponent rn/app-registry "main" #(r/reactify-component app-root)))
