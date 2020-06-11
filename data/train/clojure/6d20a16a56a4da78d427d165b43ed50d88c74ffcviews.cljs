(ns aco.index.views
  (:require [re-frame.core :as re-frame :refer [subscribe dispatch]]))

(defn index-page []
  (let [loading (subscribe [:index/loading])
        error-loading (subscribe [:index/error-loading])
        acos (subscribe [:index/acos])]
    (fn []
      [:div
       (when @loading
         [:p.bg-info "Loading..."])
       (when @error-loading
         [:p.bg-danger "Error loading data"])
       [:ul (for [aco @acos]
              ^{:key (:uuid aco)}
              [:li [:a {:href "#" :on-click #(do (dispatch [:single/request-aco (:uuid aco)])
                                                 (dispatch [:set-active-panel :single]))}
                    (:title aco)]])]])))
