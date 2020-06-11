(ns go-client.routes
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
  (defroute default-tab "/" []
            (re-frame/dispatch [:set-active-tab :game-list-tab]))

  (defroute game-list-tab "/games" []
            (re-frame/dispatch [:set-active-tab :game-list-tab]))

  (defroute development-tab "/development" []
            (re-frame/dispatch [:set-active-tab :development-tab]))

  (defroute game-tab "/games/:game-id" [game-id]
            (re-frame/dispatch [:set-active-game game-id])
            (re-frame/dispatch [:set-active-tab :game-tab]))

  ;; --------------------
  (hook-browser-navigation!))
