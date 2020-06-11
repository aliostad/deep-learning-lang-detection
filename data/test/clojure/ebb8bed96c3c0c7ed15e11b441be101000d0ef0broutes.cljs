(ns cohen.routes
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
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/music" []
    (re-frame/dispatch [:set-active-panel :music-panel]))

  (defroute "/photos" []
    (re-frame/dispatch [:set-active-panel :photos-panel]))

  (defroute "/videos" []
    (re-frame/dispatch [:set-active-panel :videos-panel]))

  (defroute "/contact" []
    (re-frame/dispatch [:set-active-panel :contact-panel]))


  ;; --------------------
  (hook-browser-navigation!))
