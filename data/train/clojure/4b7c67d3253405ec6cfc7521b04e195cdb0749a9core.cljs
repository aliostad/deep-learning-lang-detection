(ns snakegame.core
  (:require-macros [reagent.ratom :refer [reaction]])
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [register-handler register-sub subscribe dispatch dispatch-sync]]
            [goog.events :as events]
            [snakegame.handlers :as handlers]
            [snakegame.view :refer [render-board score game-over]]))

(enable-console-print!)

;;dispatch the next state event every 150ms

(defonce snake-moving
   (js/setInterval #(dispatch [:next-state]) 300))

(defn game []
  [:div
   [render-board]
   [score]
   [game-over]])

(defn run [] 
  (dispatch-sync [:initialize])
  (reagent/render [game] (js/document.getElementById "app")))

(run)
