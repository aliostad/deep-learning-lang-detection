(ns lux-adt.routes
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
            (js/console.log "Home Page")
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/order" [query-params]
    (re-frame/dispatch [:set-active-panel :order-panel])
    (re-frame/dispatch [:select-user (int (:user-id query-params))]))


  ;; --------------------
  (hook-browser-navigation!))
