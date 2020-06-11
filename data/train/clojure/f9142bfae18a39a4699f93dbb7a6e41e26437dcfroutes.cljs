(ns ttt.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]
              [accountant.core :as accountant]
              [ttt.urls :as urls]
              ))

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
  (defroute (urls/naked (urls/menu)) []
    (re-frame/dispatch [:set-active-panel :menu-panel]))

  (defroute (urls/naked (urls/credits)) []
    (re-frame/dispatch [:set-active-panel :credits-panel]))

  (defroute (urls/naked (urls/new-game)) []
    (re-frame/dispatch [:set-active-panel :new-game-panel]))

  (defroute (urls/naked (urls/options)) []
    (re-frame/dispatch [:set-active-panel :options-panel]))

  (defroute (urls/naked (urls/game)) []
    (re-frame/dispatch [:set-active-panel :game-panel]))

  (defroute (urls/naked (urls/game-over)) []
    (re-frame/dispatch [:set-active-panel :game-over-panel]))



  ;; --------------------
  (hook-browser-navigation!)
  (accountant/configure-navigation!)
  )
