(ns basic-player.views
    (:require [re-frame.core :as re-frame]))

(defn enter? [event]
  (== 13 (.-keyCode event)))

(defn input-text [event]
  (-> event .-target .-value))

(defn clear-input [event]
  (-> event .-target .-value (set! "")))

(defn main-panel []
  [:div#main
   [:input
    {:placeholder "Add a YouTube URL or ID, press enter"
     :on-key-up #(when (enter? %)
                   (re-frame/dispatch [:load-video (input-text %)])
                   (clear-input %)
                   false)}]
   [:button#play {:on-click #(re-frame/dispatch [:play-video])} "Play"]
   [:button#pause {:on-click #(re-frame/dispatch [:pause-video])} "Pause"]])
