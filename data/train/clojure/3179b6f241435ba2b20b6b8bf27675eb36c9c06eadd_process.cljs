(ns flow-editor.views.modals.add-process
  (:require [reagent.core :as r]
            [re-frame.core :refer [dispatch]]
            [re-com.core :refer [title button v-box h-box modal-panel input-text line]]))


(defn add-process-modal []
  (let [process-id (r/atom "")]
    (fn []
      [modal-panel
       :child [v-box
               :children [[title
                           :label "Enter process id"
                           :level :level2
                           :margin-bottom "20px"]
                          [input-text
                           :model process-id
                           :on-change #(reset! process-id %)
                           :placeholder "Process id"]
                          [line
                           :color "#ddd" :style {:margin "20px"}]
                          [h-box
                           :gap "12px"
                           :children [[button
                                       :label "Create"
                                       :class "btn-primary"
                                       :on-click #(dispatch [:flow-runtime/add-process @process-id])]
                                      [button
                                       :label "Cancel"
                                       :on-click (fn [] (dispatch [:ui/close-modal])
                                                        (dispatch [:graph-ui/set-new-node-position nil]))]]]]]])))
