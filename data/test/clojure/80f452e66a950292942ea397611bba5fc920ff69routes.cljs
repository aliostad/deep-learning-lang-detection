(ns webtm.routes
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

(defn go-home [params]
  (re-frame/dispatch [:fetch-meta])
  (re-frame/dispatch [:set-active-panel :home-panel params]))

(defroute home "/" [query-params]
  (go-home query-params))

(defroute project "/project/:name" [name query-params]
  (re-frame/dispatch-sync [:active-project name])
  (re-frame/dispatch [:fetch-meta])
  (re-frame/dispatch [:set-active-panel :project-panel (merge query-params {:name name})]))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  home
  project
  ;; (defroute "*" [] (go-home))
  ;; --------------------
  (hook-browser-navigation!))
