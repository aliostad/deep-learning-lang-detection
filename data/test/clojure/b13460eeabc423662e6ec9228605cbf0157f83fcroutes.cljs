(ns re-frame-git.routes
  (:require [re-frame.core :as re-frame]
            [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType])
  (:import goog.History))

(secretary/set-config! :prefix "#")

(secretary/defroute home-route "/" []
  (re-frame/dispatch [:set-current-route "home"]))

(secretary/defroute repositories-route "/repositories/:github-username" [github-username]
  (re-frame/dispatch [:set-current-route "repositories"])
  (re-frame/dispatch [:set-repo-list github-username]))

(secretary/defroute
  repo-details-route
  "/repositories/:github-username/:repo-name"
  [github-username repo-name]
  (re-frame/dispatch [:set-current-route "repo-details"])
  (re-frame/dispatch [:set-current-repo github-username repo-name]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))
