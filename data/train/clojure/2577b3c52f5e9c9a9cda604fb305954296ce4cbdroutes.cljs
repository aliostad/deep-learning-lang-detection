(ns sp.routes
  (:import goog.History)
  (:require-macros [secretary.core :refer [defroute]])
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
    (dispatch [:set-active-panel :about-panel]))

  (defroute "/ambitions" []
    (dispatch [:set-active-panel :ambitions-panel]))

  (defroute "/ambitions/:title" [title]
    (dispatch [:set-ambition title])
    (dispatch [:set-active-panel :ambitions-post-panel]))

  (defroute "/relay" []
    (dispatch [:set-active-panel :relay-panel]))

  (defroute "/talk" []
    (dispatch [:set-active-panel :talk-panel]))

  (defroute "/status" []
    (dispatch [:set-active-panel :status-panel]))

  (hook-browser-navigation!))
