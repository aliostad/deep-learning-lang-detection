(ns cadenza.instruments.tab
  (:require
    [clojure.string :refer [join lower-case]]
    [dmohs.react :as react]
    [cadenza.common.common :as common]
    [cadenza.common.components :as comps]
    [cadenza.common.table :as table]
    [cadenza.utils :as utils]
    ))


(react/defc InstrumentEditor
  {:render
   (fn [{:keys [props]}]
     (let [{:keys [instrument update-instrument delete]} props
           labeled (fn [label content] (common/labeled label 100 content))]
       [:div {:key (:guid instrument)
              :style {:flex "1 0 auto"
                      :position "relative"
                      :padding "0.5em"
                      :border common/standard-line}}
        [:div {:style {:position "absolute" :top 3 :right 3}}
         [comps/XButton {:on-click (:close props)}]]
        [:div {} "Edit Instrument"]
        (labeled "Name"
                 [comps/TextField {:text (:name instrument)
                                   :on-change #(update-instrument (assoc instrument :name %))}])
        [:div {:style {:marginTop "0.5em"}}
         [comps/DeleteButton {:on-click delete}]]]))})


(react/defc InstrumentsTab
  {:render
   (fn [{:keys [props state this]}]
     (let [{:keys [instruments add-instrument]} props
           {:keys [selected-instrument]} @state]
       [:div {:style {:margin "0.5em"}}
        [:div {:style {:marginBottom "0.5em"}}
         [comps/Button {:text "Add Instrument"
                        :on-click #(let [guid (utils/guid)
                                         new-instrument {:name (utils/find-name "Untitled" (set (map :name instruments)))
                                                         :guid guid
                                                         :patches []}]
                                     (swap! state assoc :selected-instrument new-instrument)
                                     (add-instrument new-instrument))}]]
        [:div {:style {:display "flex" :alignItems "top"}}
         [:div {:style {:flex (if selected-instrument
                                "0 0 auto"
                                "1 0 auto")}}
          [table/Table
           {:data (sort-by (comp lower-case :name) instruments)
            :empty-message "No instruments defined"
            :row-style (fn [_ instrument]
                         (let [selected? (= (:guid selected-instrument) (:guid instrument))]
                           {:cursor "pointer"
                            :backgroundColor (when selected? (:blue common/color))
                            :color (when selected? "white")}))
            :columns (vec (concat
                            [{:header "Name" :initial-width 150
                              :renderer :name}]
                            (when-not selected-instrument
                              [{:header "Patches" :initial-width :auto
                                :renderer (utils/fn->> :patches
                                                       (map :name)
                                                       (join ", ")
                                                       not-empty)
                                }])))
            :on-row-selected
            (fn [_ instrument]
              (if (= (:guid instrument) (:guid selected-instrument))
                (swap! state dissoc :selected-instrument)
                (swap! state assoc :selected-instrument instrument)))}]]
         (when selected-instrument
           [InstrumentEditor {:instrument selected-instrument
                              :update-instrument #(react/call :replace-selected-instrument this %)
                              :delete #(react/call :delete-selected-instrument this)
                              :close #(swap! state dissoc :selected-instrument)}])]]))
   :replace-selected-instrument
   (fn [{:keys [props state]} new-instrument]
     (let [{:keys [instruments update-instruments]} props
           {:keys [selected-instrument]} @state
           index (utils/first-index-by #(= (:guid selected-instrument) (:guid %)) instruments)]
       (update-instruments (assoc instruments index new-instrument))))
   :delete-selected-instrument
   (fn [{:keys [props state]}]
     (let [{:keys [instruments update-instruments]} props
           {:keys [selected-instrument]} @state
           index (utils/first-index-by #(= (:guid selected-instrument) (:guid %)) instruments)]
       (update-instruments (utils/delete instruments index))
       (swap! state dissoc :selected-instrument)))})
