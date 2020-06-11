(ns alex-silva-music.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
            (dispatch [:set-active-panel nil])
            (dispatch [:set-active-project nil])
            (dispatch [:set-active-collection nil]))

  (defroute "/:panel" [panel]
            (dispatch [:set-active-panel (keyword panel)]))

  (defroute "/projects/:project" [project]
            (dispatch [:set-active-panel :projects])
            (dispatch [:set-active-project (keyword project)]))

  (defroute "/projects/face-of-man/:collection" [collection]
            (dispatch [:set-active-panel :projects])
            (dispatch [:set-active-project :face-of-man])
            (dispatch [:set-active-collection (keyword collection)]))

  ;; --------------------
  (hook-browser-navigation!))
