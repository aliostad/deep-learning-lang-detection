(ns cosycat.routes
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re-frame]
            [clojure.string :as str])
  (:import goog.History)
  (:require-macros [secretary.core :refer [defroute]]))

(defonce history (History.))

(defn nav! [token]
  (.setToken history token))

(defn find-path []
  (let [href js/window.location.href
        path js/window.location.pathname]
    (-> (clojure.string/split href path)
        last
        (clojure.string/replace "#" ""))))

(defn refresh []
  (nav! (find-path)))

(defn hook-browser-navigation! []
  (doto history
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (let [token (.-token event)]
         (.log js/console "Navigating to " token)
         (secretary/dispatch! token))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  (defroute "/" []
    (re-frame/dispatch [:remove-active-project])
    (re-frame/dispatch [:drop-session-error])    
    (re-frame/dispatch [:set-active-panel :front-panel]))
  (defroute "/project/:project-name" {project-name :project-name}
    (re-frame/dispatch [:set-active-project {:project-name project-name}])
    (re-frame/dispatch [:set-active-panel :project-panel]))  
  (defroute "/project/:project-name/query" {project-name :project-name}
    (re-frame/dispatch [:set-active-project {:project-name project-name}])
    (re-frame/dispatch [:set-active-panel :query-panel]))
  (defroute "/project/:project-name/review" {project-name :project-name}
    (re-frame/dispatch [:set-active-project {:project-name project-name}])
    (re-frame/dispatch [:set-active-panel :review-panel]))
  (defroute "/project/:project-name/settings" {project-name :project-name}
    (re-frame/dispatch [:set-active-project {:project-name project-name}])
    (re-frame/dispatch [:set-active-panel :settings-panel]))
  (defroute "/project/:project-name/updates" {project-name :project-name}
    (re-frame/dispatch [:set-active-project {:project-name project-name}])
    (re-frame/dispatch [:set-active-panel :updates-panel]))
  (defroute "/settings" []
    (re-frame/dispatch [:set-active-panel :settings-panel]))
  (defroute "/admin" []
    (re-frame/dispatch [:set-active-panel :admin-panel]))
  (defroute "/updates" []
    (re-frame/dispatch [:set-active-panel :updates-panel]))
  (defroute "/exit" []
    (.assign js/location "/logout"))
  (hook-browser-navigation!))

