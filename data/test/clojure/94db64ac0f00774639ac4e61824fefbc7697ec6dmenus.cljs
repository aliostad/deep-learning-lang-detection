(ns jsk.data.explorer.menus
  (:require [re-frame.core :as rf]
            [jsk.data.explorer.events :as e]
            [jsk.data.explorer.models :as m]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section Context Menus
(defmulti section-context-menu :jsk-node-type)

(defmethod section-context-menu :agent
  [{:keys [jsk-id] :as node}]
  {:make-agent {:label "Add Agent" :action #(rf/dispatch [e/create-explorer-node :agent])}
   :refresh-agents {:label "Refresh Agent" :action #(rf/dispatch [e/refresh-node jsk-id])}})

(defmethod section-context-menu :alert
  [{:keys [jsk-id] :as node}]
  {:make-alert {:label "Add Alert" :action #(rf/dispatch [e/create-explorer-node :alert])}
   :refresh-alerts {:label "Refresh Alert" :action #(rf/dispatch [e/refresh-node jsk-id])}})

(defmethod section-context-menu :executable
  [{:keys [jsk-id] :as node}]
  {:make-job {:label "Add Job" :action #(rf/dispatch [e/create-explorer-node :job])}
   :make-workflow {:label "Add Workflow" :action #(rf/dispatch [e/create-explorer-node :workflow])}
   :refresh-executables {:label "Refresh Executables" :action #(rf/dispatch [e/refresh-node jsk-id])}})

(defmethod section-context-menu :schedule
  [{:keys [jsk-id] :as node}]
  {:make-schedule {:label "Add Schedule" :action #(rf/dispatch [e/create-explorer-node :schedule])}
   :refresh-schedules {:label "Refresh Schedule" :action #(rf/dispatch [e/refresh-node jsk-id])}})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Context Menus
(defmulti context-menu :type)

(defmethod context-menu :agent
  [{:keys [jsk-id] :as node}]
  {:rm-agent {:label "Delete Agent" :action #(rf/dispatch [e/rm-explorer-node :agent jsk-id])}})

(defmethod context-menu :alert
  [{:keys [jsk-id] :as node}]
  {:rm-alert {:label "Delete Alert" :action #(rf/dispatch [e/rm-explorer-node :alert jsk-id])}})

(defmethod context-menu :job
  [{:keys [jsk-id] :as node}]
  {:trigger-job {:label "Trigger Job" :action #(rf/dispatch [e/trigger-job jsk-id])}
   :rm-job {:label "Delete Job" :action #(rf/dispatch [e/rm-explorer-node :job jsk-id])}})

(defmethod context-menu :schedule
  [{:keys [jsk-id] :as node}]
  {:rm-schedule {:label "Delete Schedule" :action #(rf/dispatch [e/rm-explorer-node :schedule jsk-id])}})

(defmethod context-menu :section
  [node]
  (section-context-menu node))

(defmethod context-menu :workflow
  [{:keys [jsk-id] :as node}]
  {:trigger-workflow {:label "Trigger Workflow" :action #(rf/dispatch [e/trigger-workflow jsk-id])}
   :rm-workflow {:label "Delete Workflow" :action #(rf/dispatch [e/rm-explorer-node :workflow jsk-id])}})

(defn context-menu-items
  [node cb]
  (->> (m/explorer-node node) context-menu clj->js cb))
