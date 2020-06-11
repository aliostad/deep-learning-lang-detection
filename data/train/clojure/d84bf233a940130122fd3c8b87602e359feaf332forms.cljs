(ns gemtoes.views.forms
  (:require [re-frame.core :as re-frame :refer [subscribe dispatch]]))

(defmacro crud-form
  [model fields]
  (fn []
    ('let [(map #((str "current-" (nth % 0)
                      (subscribe [(keyword (str "current-" (nth % 0)))])))
               fields)]
      (fn []
        [:form
         (map #([:div.form-group
                 [:label {:for (str "\"" (nth % 0) "\"")}
                  (str "\"" (nth % 1) "\"")]
                 [(keyword (str ":input#" (nth % 0) ".form-control"
                                {:type "text"
                                 :value (str "@current-" (nth % 0))
                                 :on-change (fn [e]
                                              (dispatch [:update-current-maker-name (-> e .-target .-value)]))}))]]))
         [:div.form-group
          [:button.btn.btn-default {:type "submit"
                                    :on-click (fn [e]
                                                (dispatch [(keyword (str "save-" model))]))} "Save"]
        [:button.btn.btn-default {:on-click (fn [e]
                                              (dispatch [(keyword (str "active-edit-" model)) ""]))} "Cancel"]
        [:button.btn.btn-default {:on-click (fn [e]
                                              (dispatch [(keyword (str "delete-" model))]))} "Delete"]]]))))
