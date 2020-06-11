(ns tmhas.routes
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

  (defroute "/people" []
            (re-frame/dispatch [:set-active-panel :people-panel]))

  (defroute "/events" []
            (re-frame/dispatch [:set-active-panel :events-panel]))

  (defroute "/404" []
    (re-frame/dispatch [:set-active-panel :404]))


  ;; --------------------
  (hook-browser-navigation!))
