(ns frontend.counter-pair
  (:require [frontend.ui :as ui]
            [frontend.counter :as counter]
            [cljs.core.match :refer-macros [match]]))

(defn init
  [top bottom]
  {:top-counter    (counter/init top)
   :bottom-counter (counter/init bottom)})

(defn control
  [model signal dispatch]
  (match signal
         :on-connect nil
         :on-reset (dispatch :reset)
         [:top s] (counter/control (:top-counter model) s #(:top-counter (dispatch [:top %])))
         [:bottom s] (counter/control (:bottom-counter model) s #(:bottom-counter (dispatch [:bottom %])))))

(defn reconcile
  [model action]
  (match action
         :reset (init 0 0)
         [:top a] (update model :top-counter counter/reconcile a)
         [:bottom a] (update model :bottom-counter counter/reconcile a)))

(defn view-model
  [model]
  {:top-counter    (counter/view-model (:top-counter model))
   :bottom-counter (counter/view-model (:bottom-counter model))})

(defn view
  [view-model dispatch]
  [:div
   [counter/view (:top-counter view-model) (ui/tagged dispatch :top)]
   [counter/view (:bottom-counter view-model) (ui/tagged dispatch :bottom)]
   [:button {:on-click #(dispatch :on-reset)} "Reset"]])

(def spec
  {:init       init
   :view-model view-model
   :view       view
   :control    control
   :reconcile  reconcile})