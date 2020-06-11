(ns fn8-io.routes
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
    (re-frame/dispatch [:set-tab :screen-panel]))
  ;; (re-frame/dispatch [:set-active-panel :screen-panel]))

  (defroute "/files" []
    (re-frame/dispatch [:set-tab :file-panel]))
  ;; (re-frame/dispatch [:set-active-panel :file-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-tab :about-panel]))
  ;; (re-frame/dispatch [:set-active-panel :about-panel]))


  ;; --------------------
  (hook-browser-navigation!))
