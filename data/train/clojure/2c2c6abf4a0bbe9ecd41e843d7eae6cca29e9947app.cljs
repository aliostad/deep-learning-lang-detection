(ns recipe.app
  (:require [goog.events :as events]
            [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [recipe.views]
            [recipe.subs]
            [recipe.events])
  (:import [goog History]
           [goog.history EventType]))

(defonce booted? (atom nil))

(defn ^:export main
  []
  (when-not @booted?
    (dispatch-sync [:boot])
    (reset! booted? true))
  (reagent/render [recipe.views/app]
                  (.getElementById js/document "app")))
