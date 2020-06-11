(ns mq.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

(def history (History.))

(defn hook-browser-navigation! []
  (doto history
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn nav! [token]
  (.setToken history (subs token 1)))

(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (re-frame/dispatch [:set-active-panel [:main-page]]))

  (defroute "/programs/:page" [page]
    (re-frame/dispatch [:set-active-panel [:programs-list (int page)]])
    (re-frame/dispatch [:api-call :programs/list (int page) ""]))

  (defroute "/program/:id/add-to-scope/:page" [id page]
    (re-frame/dispatch [:set-active-panel [:program-add-to-scope (int id) (int page)]])
    (re-frame/dispatch [:api-call :programs/list (int page) ""]))

  (defroute "/program/:id" [id]
    (re-frame/dispatch [:set-active-panel [:program-details (int id)]])
    (re-frame/dispatch [:api-call :programs/details (int id)]))

  (defroute "/tasks/:page" [page]
    (re-frame/dispatch [:set-active-panel [:tasks-list (int page)]])
    (re-frame/dispatch [:api-call :tasks/list (int page)])))

(hook-browser-navigation!)


(defn main-page []
  "#/")

(defn programs-list [page]
  (str "#/programs/" page))

(defn program-details [id]
  (str "#/program/" id))

(defn add-to-scope [id page]
  (str "#/program/" id "/add-to-scope/" page))

(defn tasks-list [page]
  (str "#/tasks/" page))