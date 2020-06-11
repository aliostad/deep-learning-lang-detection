(ns tenzing-re-frame-todomvc.app
  (:require-macros [secretary.core :refer [defroute]])
  (:require [goog.events :as events]
            [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [tenzing-re-frame-todomvc.handlers]
            [tenzing-re-frame-todomvc.subs]
            [tenzing-re-frame-todomvc.views])
  (:import [goog History]
           [goog.history EventType]))

(enable-console-print!)

;; -- Routing -----------------------------------------------------------------

(defroute "/" [] (dispatch [:set-showing :all]))
(defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history (History.))

(events/listen history EventType.NAVIGATE
  (fn [e] (secretary/dispatch! (.-token e))))

(.setEnabled history true)


;; -- Entry Point -------------------------------------------------------------

(defn ^:export init
  []
  (dispatch-sync [:initialise-db])
  (reagent/render [tenzing-re-frame-todomvc.views/todo-app]
                  (.getElementById js/document "app")))

