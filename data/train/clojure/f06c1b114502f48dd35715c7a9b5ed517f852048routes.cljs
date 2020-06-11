(ns crowd-scribe.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re-frame]))

(defn begin-listening! []
  (doto (History. false false (.getElementById js/document "history-state"))
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn init-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (re-frame/dispatch [:set-page :home]))
  (defroute "/sign-up" []
    (re-frame/dispatch [:set-page :sign-up]))
  (defroute "/dashboard" []
    (re-frame/dispatch [:set-page :dashboard]))
  (defroute "/write" []
    (re-frame/dispatch [:set-page :write]))
  (defroute "/translate" []
    (re-frame/dispatch [:set-page :translate]))
  (defroute "*" []
    (re-frame/dispatch [:set-page :not-found]))

  (begin-listening!))
