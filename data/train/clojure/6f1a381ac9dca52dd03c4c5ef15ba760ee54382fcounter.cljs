(ns frontend.counter
  (:require [cljs.core.match :refer-macros [match]]))

(defn init
  "Pure function. Creates a model intance."
  [x]
  x)

(defn control
  "Non-pure signal handler.
  Based on current model snapshot and received signal it can dispatch actions further to reconcile."
  [_model signal dispatch]
  (match signal
         :on-connect nil
         :on-increment (dispatch :increment)
         :on-decrement (dispatch :decrement)))

(defn reconcile
  "Pure function. It returns a new model based on current model snapshot and received action."
  [model action]
  (match action
         :increment (inc model)
         :decrement (dec model)))

(defn view-model
  "Pure function. Given a model snapshot returns an immutable value for view to display."
  [model]
  (str "#" model))

(defn view
  "Pure function. View is given an immutable view-model and a signal dispatching function."
  [view-model dispatch]
  [:div
   [:button {:on-click #(dispatch :on-increment)} "+"]
   [:span view-model]
   [:button {:on-click #(dispatch :on-decrement)} "-"]])

(defn view-with-remove-button
  "dispatch-on-remove is passed because it's up to container to decide how to handle removing."
  [view-model {:keys [dispatch dispatch-on-remove] :as _context_}]
  [:div
   [:button {:on-click #(dispatch :on-increment)} "+"]
   [:span view-model]
   [:button {:on-click #(dispatch :on-decrement)} "-"]
   [:button {:on-click #(dispatch-on-remove)} "X"]])

(def spec
  {:init       init
   :view-model view-model
   :view       view
   :control    control
   :reconcile  reconcile})