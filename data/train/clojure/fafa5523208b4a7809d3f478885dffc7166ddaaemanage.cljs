(ns whats-next.manage
  (:require [om.core :as om]
            [om.dom :as dom]
            [sablono.core :as html :refer-macros [html]]

            [whats-next.shared.task-selection :refer [task-selector]]))

(defn manager-view [app owner]
  (reify
    om/IInitState
    (init-state [_]
      {})

    om/IRenderState
    (render-state [_ {:keys [delete-task]}]
      (html
       [:div.manager-container
        [:h3 "Rename Task"]
        [:label "Task" [:input.text]]
        [:label "New Name:" [:input.text]]

        [:h3 "Delete Task"]
        (task-selector app #(om/set-state! owner :delete-task %)
                       delete-task)]))))
