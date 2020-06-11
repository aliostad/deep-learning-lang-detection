(ns chorechart.pages.misc-comps.row-cases
  (:require [re-frame.core :as rf]
            [chorechart.misc :as misc]))

(defn row-case-options [options-pressed
                        index
                        remove-dispatch-key
                        remove-dispatch-value]
  [:div.row
   [:div.col-xs-4.text-xs-left
    [:button.btn.btn-sm
     {:on-click
      #(swap!
        options-pressed assoc index :edit)}
     "edit"]]
   [:div.col-xs-4.text-xs-center
    [:button.btn.btn-sm.btn-danger
     {:on-click
      #(do
         (rf/dispatch
          [remove-dispatch-key
           remove-dispatch-value])
         ;; remove options component state for this element
         (swap!
          options-pressed
          misc/vec-remove index))}
     "delete"]]
   [:div.col-xs-4.text-xs-right
    [:button.btn.btn-sm.btn-secondary
     {:on-click
      #(swap!
        options-pressed assoc index :normal)}
     "cancel"]]])

(defn row-case-edit [options-pressed
                     index
                     placeholder
                     on-change-dispatch-key
                     on-change-dispatch-value-fn
                     submit-dispatch-key]
  [:div.row
   [:div.col-xs-8
    [:input
     {:type "text"
      :placeholder placeholder
      :on-change #(rf/dispatch
                   [on-change-dispatch-key
                    (on-change-dispatch-value-fn
                     (-> % .-target .-value))])}]]
   [:div.col-xs-2 [:button.btn.btn-sm.btn-primary
                   {:on-click
                    #(do
                       (rf/dispatch
                        [submit-dispatch-key])
                       (swap!
                        options-pressed
                        assoc index :normal))}
                   "submit"]]
   [:div.col-xs-2 [:button.btn.btn-sm.btn-secondary
                   {:on-click
                    #(swap!
                      options-pressed
                      assoc index :normal)}
                   "cancel"]]])


