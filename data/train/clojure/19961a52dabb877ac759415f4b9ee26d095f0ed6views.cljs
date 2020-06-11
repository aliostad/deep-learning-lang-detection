(ns gameoflive.views
  (:require [re-frame.core :as re-frame]))

(defn cell [y x alive?]
  [:div {:key      [x y]
         :class    "cell"
         :on-click #(re-frame/dispatch [:toggle x y])}
   [:div {:class (if alive? "alive" "dead")}]]
  )

(defn line [y l]
  [:div {:key   y
         :class "line"}
   (map-indexed (partial cell y) l)])

(defn board []
  (let [b (re-frame/subscribe [:board])]
    (fn []
      [:div {:class "board"}
       (map-indexed line @b)])))

(defn main-panel []
  (let [counter (re-frame/subscribe [:counter])]
    (fn []
      [:div
       [:div
        [:button {:on-click #(re-frame/dispatch [:random])} "Random"]
        [:button {:on-click #(re-frame/dispatch [:clear])} "Clear"]]

       [board]

       [:div
        [:button {:on-click #(re-frame/dispatch [:step])} "|>"]
        [:button {:on-click #(re-frame/dispatch [:play])} ">"]
        [:button {:on-click #(re-frame/dispatch [:stop])} "||"]
        [:span (str "Round: " @counter)]]])))
