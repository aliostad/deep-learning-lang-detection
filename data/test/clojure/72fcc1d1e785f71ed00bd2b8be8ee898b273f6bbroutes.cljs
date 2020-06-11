(ns mazda.routes
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

  (defroute "/blog" []
    (re-frame/dispatch [:set-active-panel :blog-panel]))

  (defroute "/portfolio" []
    (re-frame/dispatch [:set-active-panel :portfolio-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/form" []
    (re-frame/dispatch [:set-active-panel :form-panel]))

  ;; --------------------
  (hook-browser-navigation!))
