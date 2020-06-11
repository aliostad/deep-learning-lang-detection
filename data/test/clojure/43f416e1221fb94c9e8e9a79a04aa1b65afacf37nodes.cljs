(ns othello-editor.components.nodes
  (:require
   [re-frame.core :refer [dispatch]]
   [othello-editor.lib.dom :refer [styles->spans]]))

(defn- dispatch-preventing-default
  [dom-event dispatch-event]
  (.persist dom-event)
  (dispatch dispatch-event)
  (.preventDefault dom-event))

(defn text-node [id attributes body]
  [:p {:contentEditable true
       :on-focus #(dispatch [:focus-block id])
       :on-input #(dispatch-preventing-default % [:content-editable-input id %])}
   (styles->spans body attributes id)])

(defn title-node [id attributes body]
  [:h1 {:contentEditable true
        :on-focus #(dispatch [:focus-block id])
        :on-input #(dispatch-preventing-default % [:content-editable-input id %])}
   body])
