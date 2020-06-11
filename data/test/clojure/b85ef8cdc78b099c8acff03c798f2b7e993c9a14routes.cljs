(ns slate.routes
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

  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/nothing" []
    (re-frame/dispatch [:set-active-panel :nothing-sketch]))

  (defroute "/tt" []
    (re-frame/dispatch [:set-active-panel :tt-sketch]))

  (defroute "/cc" []
    (re-frame/dispatch [:set-active-panel :cc-sketch]))

  (defroute "/pp" []
    (re-frame/dispatch [:set-active-panel :pp-sketch]))
  
  (hook-browser-navigation!))
