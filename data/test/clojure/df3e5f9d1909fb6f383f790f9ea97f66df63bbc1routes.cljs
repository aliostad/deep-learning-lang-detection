(ns dctrl.routes
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
  (defroute "/calendar" []
    (re-frame/dispatch [:set-active-panel :calendar-panel]))
  (defroute "/members" []
    (re-frame/dispatch [:set-active-panel :members-panel]))
  (defroute "/forum" []
    (re-frame/dispatch [:set-active-panel :forum-panel]))
  (defroute "/sidewalk" []
    (re-frame/dispatch [:set-active-panel :sidewalk-panel]))


  ;; --------------------
  (hook-browser-navigation!))
