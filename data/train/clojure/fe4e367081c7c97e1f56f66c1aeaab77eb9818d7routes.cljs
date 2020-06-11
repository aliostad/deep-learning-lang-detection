(ns pedestal-frontend.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.dom :as dom]
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

  (defroute "/login" []
    (re-frame/dispatch [:set-active-panel :login-panel]))

  (defroute "/orders" []
    (re-frame/dispatch [:set-active-panel :orders]))

  (defroute "/items" []
    (re-frame/dispatch [:initialize-item-list])
    (re-frame/dispatch [:set-active-panel :items]))

  (defroute "/items/new" []
    (re-frame/dispatch [:initialize-new-item])
    (re-frame/dispatch [:set-active-panel :add-item]))

  ;; --------------------
  (hook-browser-navigation!))
