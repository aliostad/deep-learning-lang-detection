(ns freq-words-2.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]]
            [freq-words-2.handlers]
            [freq-words-2.subs]
            [freq-words-2.views]))

;; Routes

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn init []
  (secretary/set-config! :prefix "#")
  (defroute root-path "/" [] (dispatch [:select-group nil]))
  (defroute group-path "/group/:id" {id :id} (dispatch [:select-group (int id)]))
  (hook-browser-navigation!))
