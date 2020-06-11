(ns sf-ladder-ui.routes
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
    (dispatch [:set-active-page :home-page]))
  (defroute "/about" []
    (dispatch [:set-active-page :about-page]))
  (defroute "/chat" []
    (dispatch [:set-active-page :chat-page]))
  (defroute "/login" []
    (dispatch [:set-active-page :login-page]))
  (hook-browser-navigation!))
