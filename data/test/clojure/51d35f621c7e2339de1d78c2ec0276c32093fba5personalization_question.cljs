(ns pharmacy.components.personalization-question
  (:require
   [pharmacy.helpers :refer [disabled-wrapper]]
   [re-frame.core :as re-frame :refer [dispatch subscribe]]))

(defn personalization-question [kind k prompt disabled?]
  (let [v (subscribe [:questions kind k])]
    (fn []
      [:div
       [:div prompt]
       [:a {:class (disabled-wrapper (if @v
                                       "button is-primary"
                                       "button")
                                     disabled?)
            :on-click #(dispatch [:question kind k true])} "Yes"]
       [:a.button {:class (disabled-wrapper (if (or @v (nil? @v))
                                              "button"
                                              "button is-primary") disabled?)
                   :on-click #(dispatch [:question kind k false])} "No"]])))
