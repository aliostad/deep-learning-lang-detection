(ns flashcards.routes
  "Client-side routing"
    (:require-macros [secretary.core :refer [defroute]])
    (:require
     [goog.events :as events]
     [goog.history.EventType :as EventType]
     [re-frame.core :as re-frame]
     [secretary.core :as secretary])
    (:import goog.History))

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

  (defroute "/play" []
    (re-frame/dispatch [:set-active-panel :play-panel]))


  ;; --------------------
  (hook-browser-navigation!))
