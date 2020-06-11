(ns wireworld.views
  (:require [re-frame.core :as re-frame]))

(defn class-for-type [type]
  (case type
    :e "empty"
    :c "conductor"
    :t "tail"
    :h "head"))

(defn cell [y x cell-type]
  [:div {:key             [x y]
         :class           "cell"
         :on-click        #(re-frame/dispatch [:toggle x y])
         :on-context-menu (fn [evt] 
                            (.preventDefault evt) 
                            (re-frame/dispatch [:empty x y]))}
   [:div {:class (class-for-type cell-type)}]]
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
        [:button {:on-click #(re-frame/dispatch [:reset])} "Reset Electrons"]
        [:button {:on-click #(re-frame/dispatch [:clear])} "Clear"]]

       [board]

       [:div
        [:button {:on-click #(re-frame/dispatch [:step])} "|>"]
        [:button {:on-click #(re-frame/dispatch [:play])} ">"]
        [:button {:on-click #(re-frame/dispatch [:stop])} "||"]
        [:span (str "Round: " @counter)]]])))
