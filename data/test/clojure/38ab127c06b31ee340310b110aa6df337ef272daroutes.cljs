(ns tilet.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History
           goog.history.EventType)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [re-frame.core :refer [dispatch subscribe]]))


(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" [] (dispatch [:page :home-page]))
  (defroute "/about" [] (dispatch [:page :about-page]))

  (doto (History.)
    (events/listen EventType.NAVIGATE
      (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))
