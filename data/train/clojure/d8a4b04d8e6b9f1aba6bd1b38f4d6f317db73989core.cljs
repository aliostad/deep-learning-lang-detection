(ns todomvc.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [goog.events :as events]
            [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [re-frisk.core :refer [enable-re-frisk!]]
            [secretary.core :as secretary]
            [todomvc.events]
            [todomvc.subs]
            [todomvc.routes :as routes]
            [todomvc.views]
            [todomvc.config :as config]
            [devtools.core :as devtools])
  (:import [goog History]
           [goog.history EventType]))



(defn dev-setup []
  (when config/debug?
    (devtools/install!)
    (enable-console-print!)
    (enable-re-frisk!)
    (println "dev mode")))

(defroute "/" [] (dispatch [:set-showing :all]))
(defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event]
                     (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn ^:export main []
  (dev-setup)
  (dispatch-sync [:initialise-db])
  (dev-setup)
  (reagent/render [todomvc.views/todo-app]
                  (.getElementById js/document "app")))
