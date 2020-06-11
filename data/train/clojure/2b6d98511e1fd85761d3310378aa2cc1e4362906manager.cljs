(ns iframe-app.components.selections.manager
  (:require-macros [cljs.core.async.macros :refer [go-loop go]])
  (:require
    [om.core :as om :include-macros true]
    [iframe-app.components.selections.field-value :refer [field-value-selector]]
    [iframe-app.components.selections.slave-fields :refer [slave-fields-selector]]
    [iframe-app.components.selections.master-field :refer [master-field-selector]]
    [om-tools.core :refer-macros [defcomponent]]
    [sablono.core :refer-macros [html]]
    [iframe-app.utils :refer [active-conditions form->form-kw]]
    [iframe-app.fetch-remote-data :refer [fetch-ticket-forms]]
    [cljs.core.async :refer [put! chan <!]]
    [dommy.core :as dommy]))


(defn remove-condition
  "Takes a list of conditions, and returns all the ones that don't include
   the selected master field / value. Used when “updating” a condition to
   have new slave fields (actually removing old one and adding new one.)"
  [selected-master-field selected-field-value conditions]
  (set (remove (fn [{:keys [master-field field-value]}]
                 (and (= master-field selected-master-field)
                      (= field-value selected-field-value)))
               conditions)))

(defn update-conditions
  "Adds a new condition or updates an old one based on the currently selected
   master field / field value / slave fields. Called when someone toggles a
   slave field."
  [conditions selections]
  (let [{:keys [master-field field-value slave-fields]} selections
        cleaned-conditions (remove-condition master-field field-value conditions)
        slave-fields-selected? (not (empty? slave-fields))]
    (if slave-fields-selected?
      (conj cleaned-conditions {:master-field master-field
                                :field-value  field-value
                                :slave-fields slave-fields})
      cleaned-conditions)))

(defn selected-condition
  "Returns the condition whose master field and field value are selected"
  [selections conditions]
  (first (filter (fn [{:keys [master-field field-value]}]
                   (and (= (:master-field selections) master-field)
                        (= (:field-value selections) field-value)))
                 conditions)))

(defn reset-irrelevant-selections
  "When someone selects (e.g.) a master field we want to deselect the value
   and slave fields that were selected (because they only applied to that
   field. Likewise when someone selects a new value."
  [selections selection-to-update conditions]
  (case selection-to-update
    :master-field (assoc selections :field-value nil
                                    :slave-fields #{})
    :field-value (let [slave-fields-of-selected-condition (-> selections
                                                              (selected-condition conditions)
                                                              :slave-fields)]
                   (assoc selections :slave-fields (or slave-fields-of-selected-condition #{})))
    :user-type (assoc selections :master-field nil
                                 :field-value nil
                                 :slave-fields #{})
    :ticket-form (assoc selections :master-field nil
                                   :field-value nil
                                   :slave-fields #{})
    selections))


(defcomponent selections-manager [app-state owner]
  (will-mount [_]
    (go-loop []
      ; handle updates from the selectors
      (let [selector-channel (om/get-shared owner :selector-channel)
            selection-msg (<! selector-channel)
            {:keys [selection-to-update new-value]} selection-msg
            {:keys [conditions selections]} @app-state
            conditions (active-conditions selections conditions)
            new-selections (-> selections
                               (assoc selection-to-update new-value)
                               (reset-irrelevant-selections selection-to-update conditions))]
        (om/update! app-state :selections new-selections)

        (when (= selection-to-update :slave-fields)
          (let [updated-conditions (update-conditions conditions new-selections)
                {:keys [user-type ticket-form]} selections]
            (om/update! app-state
                        [:conditions user-type (form->form-kw ticket-form)]
                        updated-conditions)
            (om/update! app-state :saved false))))
      (recur)))
  (render-state [_ _]
    (let [{:keys [selections]} app-state]
      (html
        [:div.pane.right.section
         [:section.main
          [:div.intro
           [:h3 "Manage conditional fields"]
           [:p
            "Configure your conditions to build your conditional fields. Select a field, a value for that field, and the appropriate field to show. "
            [:a
             {:target "_blank",
              :href
                      "https://support.zendesk.com/entries/26674953-Using-the-Conditional-Fields-app-Enterprise-Only-"}
             "Learn more."]]]

          [:ul.table-header.clearfix
           [:li "Fields"]
           [:li "Values"]
           [:li (str "Fields to show (" (count (:slave-fields selections)) ")")]]

          [:div.table-wrapper
           [:table.table
            [:tbody
             [:tr
              (om/build master-field-selector
                        app-state)


              (om/build field-value-selector
                        app-state)

              [:td.selected
               [:div.values
                [:div.separator "Available"]
                (om/build slave-fields-selector selections)]]]]]]]]))))