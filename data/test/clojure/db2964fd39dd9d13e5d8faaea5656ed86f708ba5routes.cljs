(ns ers.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]]
            [secretary.core :as secretary]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (dispatch [:page/set :home]))

  (defroute "/profile" []
    (dispatch [:page/set :profile]))

  ; ext link to JORUM for now
  #_(defroute "/item/:id" [id]
      (dispatch [:page/set-id id])
      (dispatch [:items/get-one id])
      (dispatch [:page/set :item]))

  (hook-browser-navigation!))
