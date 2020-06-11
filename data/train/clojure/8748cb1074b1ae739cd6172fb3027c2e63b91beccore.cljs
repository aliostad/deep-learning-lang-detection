(ns annotare.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [pushy.core :as pushy]
            [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [annotare.history :refer [history]]
            [annotare.handlers]
            [annotare.subs]
            [annotare.views.app :refer [annotare-app]])
  (:import [goog History]
           [goog.history EventType]))

(enable-console-print!)
(secretary/set-config! :prefix "/")

(defroute "/" []
  (dispatch [:set-panel :front]))
(defroute "/admin" []
  (dispatch [:set-panel :admin]))
(defroute "/tag/:project-id" [project-id]
  (let [project-id (js/parseInt project-id)]
    (dispatch [:set-panel :tag project-id])))


(defn ^:export main
  []
  (pushy/start! history)
  (dispatch [:fetch :project :all nil :initial-projects])
  (dispatch [:fetch :tagset :all nil :initial-tagsets])
  (dispatch-sync [:initialise-db])
  (reagent/render [annotare-app]
                  (.getElementById js/document "app")))
