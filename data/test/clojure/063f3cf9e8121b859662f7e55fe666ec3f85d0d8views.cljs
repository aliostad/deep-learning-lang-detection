(ns aco.client.views
  (:require [re-frame.core :as re-frame :refer [dispatch subscribe]]
            [aco.index.views :refer [index-page]]
            [aco.single.views :refer [single-page]]
            [aco.tags.views :refer [tags-page]]))

(defn about-page []
  [:h2 "about page"])

(defn current-page []
  (let [active-panel (subscribe [:active-panel])]
    (fn []
      [:div
       [:h1 "Article Collector"]
       [:div
        [:a {:href "#" :on-click #(do (dispatch [:index/request-acos])
                                      (dispatch [:set-active-panel :index]))} "index"]
        " "
        [:a {:href "#" :on-click #(do (dispatch [:tags/request-tags])
                                      (dispatch [:set-active-panel :tags]))} "tags"]
        " "
        [:a {:href "#" :on-click #(dispatch [:set-active-panel :about])} "about"]]
       (condp = @active-panel
         :index [index-page]
         :single [single-page]
         :tags [tags-page]
         :about [about-page])])))
