(ns lean-discussion.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

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
  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/collect" []
            (re-frame/dispatch [:set-session-mode :collect]))

  (defroute "/vote" []
            (re-frame/dispatch [:set-session-mode :vote]))

  (defroute "/discuss" []
            (re-frame/dispatch [:set-session-mode :discuss]))

  ;; --------------------
  (hook-browser-navigation!))
