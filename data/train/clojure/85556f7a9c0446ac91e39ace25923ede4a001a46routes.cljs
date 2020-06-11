(ns client.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as rf]))

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
    (rf/dispatch [:set-active-panel :home-panel]))
  (defroute "/login" []
    (rf/dispatch [:set-active-panel :login-panel]))
  (defroute "/register" []
    (rf/dispatch [:set-active-panel :register-panel]))
  (defroute "/register" []
    (rf/dispatch [:set-active-panel :register-panel]))
  (defroute "/dashboard" []
    (rf/dispatch [:set-active-panel :dashboard-panel]))
  (defroute "/recipes/:id" []
    (rf/dispatch [:set-active-panel :recipe-panel]))


  ;; --------------------
  (hook-browser-navigation!))
