(ns flow-editor.views.modals.add-entity
  (:require [reagent.core :as r]
            [re-frame.core :refer [dispatch]]
            [re-com.core :refer [title button v-box h-box modal-panel input-text line]]))


(defn add-entity-modal []
  (let [entity-id (r/atom "")]
    (fn []
      [modal-panel
       :child [v-box
               :children [[title
                           :label "Enter entity id"
                           :level :level2
                           :margin-bottom "20px"]
                          [input-text
                           :model entity-id
                           :on-change #(reset! entity-id %)
                           :placeholder "Entity id"]
                          [line
                           :color "#ddd" :style {:margin "20px"}]
                          [h-box
                           :gap "12px"
                           :children [[button
                                       :label "Create"
                                       :class "btn-primary"
                                       :on-click #(dispatch [:flow-runtime/add-entity @entity-id])]
                                      [button
                                       :label "Cancel"
                                       :on-click (fn [] (dispatch [:ui/close-modal])
                                                        (dispatch [:graph-ui/set-new-node-position nil]))]]]]]])))
