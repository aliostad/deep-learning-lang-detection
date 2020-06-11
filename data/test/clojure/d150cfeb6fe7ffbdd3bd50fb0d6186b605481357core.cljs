(ns todomvc.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [devtools.core :as devtools]
            [goog.events :as events]
            [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [todomvc.handlers]
            [todomvc.subs]
            [todomvc.views])
  (:import [goog History]
           [goog.history EventType]))

(devtools/install!)
;; (.log js/console "hola") ;; how to print to console

;; -- Routes and History ------------------------------------------------------

(defroute "/todos" [] (dispatch [:set-showing :all]))
(defroute "/todos/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))


;; -- Entry Point -------------------------------------------------------------

(defn ^:export main
  []
  (dispatch-sync [:initialise-db])
  (reagent/render [todomvc.views/todo-app]
                  (.getElementById js/document "app")))
