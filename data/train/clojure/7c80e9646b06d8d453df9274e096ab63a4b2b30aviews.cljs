(ns magnet.bez2.views
  (:require [re-frame.core :as re-frame :refer [dispatch subscribe]]
            [magnet.index.views :refer [index-page]]
            [magnet.about.views :refer [about-page]]
            [magnet.book.views :refer [book-page]]))

(defn current-page []
  (let [active-panel (subscribe [:active-panel])]
    (fn []
      [:div
       [:h1 "magnet bez"]
       [:div
        [:a {:href "#" :on-click #(dispatch [:set-active-panel :index])} "index"]
        " "
        [:a {:href "#" :on-click #(dispatch [:set-active-panel :about])} "about"]]
       (condp = @active-panel
         :index [index-page]
         :about [about-page]
         :book [book-page])])))
