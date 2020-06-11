(ns dissertation.routes
  (:require [secretary.core :as secretary :include-macros true :refer-macros [defroute]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [subscribe dispatch]]
            [dissertation.components.home.view :as home])
  (:import goog.History))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn init-routes []
  (secretary/set-config! :prefix "#")
  (defroute "/home" []
    (dispatch [:render-component :home]))
  (defroute "/next-page" []
    (dispatch [:render-component :next-page]))
  (hook-browser-navigation!))
