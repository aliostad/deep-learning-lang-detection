(ns cypress-editor.routes
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]])
  (:import goog.History))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (secretary/defroute "/index.html" []
    (dispatch [:set/active-page :app]))

  (secretary/defroute "/login" []
    (dispatch [:set/active-page :login]))

  (secretary/defroute "/query/:query-text/:genre-text" [query-text genre-text]
    (println query-text genre-text))

  ;; --------------------
  (hook-browser-navigation!))
