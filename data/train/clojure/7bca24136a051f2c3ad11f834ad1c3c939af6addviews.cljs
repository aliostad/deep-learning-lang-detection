(ns magnet.index.views
  (:require [re-frame.core :as re-frame :refer [subscribe dispatch]]))

(defn index-page []
  (let [title (subscribe [:title])
        loading (subscribe [:index/loading])
        books (subscribe [:index/books])]
    (fn []
      [:div
       [:div [:h2 @title]]
       (when @loading
         [:p "Loading..."])
       [:ul (for [book @books]
              ^{:key (:id book)}
              [:li [:a {:href "#" :on-click #(do (dispatch [:book/request-book (:id book)])
                                                 (dispatch [:set-active-panel :book]))}
                    (:titulua book)]])]])))
