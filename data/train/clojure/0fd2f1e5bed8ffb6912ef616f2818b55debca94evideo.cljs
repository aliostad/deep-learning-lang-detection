(ns rtc.view.video
    (:require [re-frame.core :as re-frame :refer [dispatch]]
              [rtc.util :as util :include-macros true]))

(defn frame []
  (util/with-subs [stream-url [:user-media-url]]
    [:video {:src stream-url :autoPlay true :muted true 
             :on-click #(dispatch [:get-user-media {:video true}])
             :style {:width 500 :height 400 :border "1px solid black"}}]))

(defn remote-frame []
  (util/with-subs [stream-url [:remote-media-url]]
    [:video {:src stream-url :autoPlay true :muted true 
             :style {:width 500 :height 400 :border "1px solid black"}}]))

(defn controls []
  [:div
   [:button {:on-click #(dispatch [:call-peer {:optional [{:RtpDataChannels true}]}])} "call"]  
   [:button {:on-click #(dispatch [:hangup-peer])} "hangup"]])
