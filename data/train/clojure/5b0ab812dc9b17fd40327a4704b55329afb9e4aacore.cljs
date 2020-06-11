(ns reframetodos.core
  (:require-macros [reagent.ratom :refer [reaction]])
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [reframetodos.handlers :as h :refer [initial-state]]
            [reframetodos.views :refer [footer List-Todo Add-Todo-List]]))

(enable-console-print!)


(defn home []
  [:div
   [Add-Todo-List]
   [List-Todo] 
   [footer]])

(defn main []
  (dispatch-sync [:initialize])
  
  (reagent/render [home] (js/document.getElementById "app")))

(main)
