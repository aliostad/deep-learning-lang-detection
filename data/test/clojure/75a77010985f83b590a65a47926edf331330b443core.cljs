(ns warehouse.core
  (:require
   [reagent.core :as reagent :refer [atom]]
   [secretary.core :as secretary]
   [warehouse.subs]
   [warehouse.events]
   [re-frame.core :refer [dispatch-sync]]
   [warehouse.views :as view]
   [warehouse.index :as index]))

(defn main []
  (secretary/dispatch! (.-hash js/location))
  (.addEventListener js/window "hashchange" (fn [e]
                                              (secretary/dispatch! (.-hash js/location))))
  (dispatch-sync [:initialize-db])
  (reagent/render-component [view/page]
                            (.getElementById js/document "app"))

  (index/initialize))

