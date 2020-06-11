(ns cleanstreet.views
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [subscribe dispatch]]
            [cleanstreet.map :as map]))

(defn app []
  (let [editing (subscribe [:is-new-path])
        new-path (subscribe [:new-path])]
    (fn []
      [:div#header
       [:div
        [:label {:for "editing"} "Editing"]
        [:input#editing {:type "checkbox"
                         :checked @editing
                         :on-change #(dispatch [:toggle-edit])}]
        [:label {:for "name"} "Name"]
        [:input#name {:value (:name @new-path)
                      :on-change #(dispatch [:set-name (-> % .-target .-value)])}]
        [:button {:on-click #(dispatch [:add-path @new-path])
                  :disabled (not @editing)}
         "Save"]
        [:button {:on-click #(dispatch [:undo-path-marker])
                  :disabled (not @editing)}
         "Undo"]
        [map/google-map]]])))
