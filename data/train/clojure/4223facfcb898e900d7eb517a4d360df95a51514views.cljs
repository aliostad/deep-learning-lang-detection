(ns flappy-cljs.views
    (:require [re-frame.core :as re-frame]))

(defn main-panel []
  (let [name (re-frame/subscribe [:name])]
    (fn []
      [:section
       [:canvas#flappy {:width "500" :height "512"}]
       [:br]
       [:button#1x {:on-click (fn [] (re-frame/dispatch [:set-speed 60]))}
        "1x"]
       [:button#2x {:on-click (fn [] (re-frame/dispatch [:set-speed 120]) )}
        "2x"]
       [:button#3x {:on-click (fn [] (re-frame/dispatch [:set-speed 180]) )}
        "3x"]
       [:button#4x {:on-click (fn [] (re-frame/dispatch [:set-speed 300]) )}
        "4x"]
       [:button#stop {:on-click (fn [] (re-frame/dispatch [:stop]) )}
        "stop"]
       [:button#spwan{:on-click (fn [] (re-frame/dispatch [:spawn-bird]) )}
        "spawn"]
       [:button#flap {:on-click (fn [] (re-frame/dispatch [:flap-bird]) )}
        "flap"]
       [:button#flap {:on-click (fn [] (re-frame/dispatch [:restart]) )}
        "restart"]






       ]




      )))
