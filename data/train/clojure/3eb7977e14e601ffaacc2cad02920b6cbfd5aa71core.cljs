(ns average-number.core
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [average-number.events]
            [average-number.subs]))

(defn main-view-inner [my-number avg]
  [:div
   [:input {:type      :number
            :on-change #(dispatch [:number-changed (-> % .-target .-value)])
            :value     my-number}]
   [:h3 "Overall avg: " avg]])

(defn main-view []
      (let [my-number (subscribe [:my-number])
            avg (subscribe [:average])]
           (fn []
      [main-view-inner @my-number @avg])))

(defn mount-root []
  (reagent/render [main-view]
                  (.getElementById js/document "app")))

(defn ^:export init []
      (dispatch-sync [:initialize-db])
      (mount-root))
