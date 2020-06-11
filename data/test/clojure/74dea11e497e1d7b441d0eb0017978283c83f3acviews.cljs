(ns <%= namespace %>.<%= domain %>.item.views
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch]]))

;; <%= domain %> Views

(defn <%= domain %>-actions [item]
  [:div {:class "actions"}
    [:button "Update" #(dispatch [:update-<%= domain %> item])]
    [:button "Delete" #(dispatch [:delete-<%= domain %> item])]])

;; Display single <%= domain %> item

(defn <%= domain %>-item [item]
  (let [item (subscribe [:get-<%= domain %>-item item])]
    [:li
      [:div {:class "item label"} (:name item)]
      (<%= domain %>-actions item)]))

(defn <%= domain %>-item-edit [item]
  (let [item (subscribe [:get-<%= domain %>-item item])]
    [:li
      [:input {:name "<%= domain %>" :class "item edit", :value (:name item)}]]))
