(ns cljs-playground.views
  (:require [re-frame.core :as re-frame]
            [reagent.core :as reagent]
            [page-1.views :as page-1]
            [page-2.views :as page-2]
            [cljs-playground.db :as db]))

(defn header []
  (let [current-page (re-frame/subscribe [:current-page])
        dispatch #(re-frame/dispatch [:set-current-page %])]
    (fn []
      [:div.header
       [:div {:class (str "item" (if (= @current-page :page-1) " active"))
              :on-click (partial dispatch :page-1)} "Page 1"]
       [:div {:class (str "item" (if (= @current-page :page-2) " active"))
              :on-click (partial dispatch :page-2)} "Page 2"]])))

(defn main-panel []
  (let [current-page (re-frame/subscribe [:current-page])]
    [:div
     [header]
     [:div.page
      (condp = @current-page
        :page-1 [page-1/main-panel]
        :page-2 [page-2/main-panel])]]))
