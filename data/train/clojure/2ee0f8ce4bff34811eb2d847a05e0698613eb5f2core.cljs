(ns todomvc.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [reagent.core :as reagent :refer [atom]]
            [goog.events :as events]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary :include-macros true]
            [todomvc.handlers]
            [todomvc.subs]
            [todomvc.views])
  (:import [goog History]
           [goog.history EventType]))

(enable-console-print!)

;; -- Routes and History ------------------------------------------------------

(defroute "/" [] (dispatch [:set-showing :all]))
(defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))


;; -- Entry Point -------------------------------------------------------------

(defn mount-root
  []
  (reagent/render [todomvc.views/login-todo-app]
                  (.getElementById js/document "app")))

(defn ^:export main
  []
  (dispatch-sync [:initialise-db])
  (mount-root))
