(ns predictor.views.app
  (:require [rum.core :as rum]
            [carry.core :as carry]
            [predictor.models.app :as model]
            [predictor.controls.app :as control]
            [predictor.reconcilers.app :as reconciler]
            [predictor.view-models.app :as view-model]
            [predictor.carry-rum :as carry-rum]))

(rum/defc view < rum/reactive
  [{:keys [counter] :as _view-model} dispatch]
  [:p
   (str "#" (rum/react counter)) " "
   [:button {:on-click #(dispatch :on-increment)} "+"] " "
   [:button {:on-click #(dispatch :on-decrement)} "-"] " "])