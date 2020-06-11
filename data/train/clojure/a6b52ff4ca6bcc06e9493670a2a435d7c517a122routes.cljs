(ns tsoha16.routes
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

  (defroute "/login" []
    (re-frame/dispatch [:set-active-panel :login-panel]))

  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (re-frame/dispatch [:get-topic-list])
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/login" []
    (re-frame/dispatch [:set-active-panel :login-panel]))

  (defroute "/aihealueet/:id" {:as params}
    (re-frame/dispatch [:get-topic (:id params)])
    (re-frame/dispatch [:get-threads (:id params)])
    (re-frame/dispatch [:set-active-panel :topic-panel]))

  (defroute "/aihealueet/:alue-id/:aihe-id" {:as params}
    (re-frame/dispatch [:get-thread (:aihe-id params)])
    (re-frame/dispatch [:get-messages (:aihe-id params)])
    (re-frame/dispatch [:set-active-panel :thread-panel]))

  (defroute "/muokkaa-aihetta/:id" {:as params}
    (print params)
    (re-frame/dispatch [:get-thread (:id params)])
    (re-frame/dispatch [:set-active-panel :edit-thread-panel]))

  (defroute "/uusi-aihe/:id" {:as params}
    (print params)
    (re-frame/dispatch [:get-topic (:id params)])
    (re-frame/dispatch [:set-active-panel :new-thread-panel]))

  (defroute "/muokkaa-viestia/:id" {:as params}
    (re-frame/dispatch [:get-message (:id params)])
    (re-frame/dispatch [:set-active-panel :edit-message-panel]))
(hook-browser-navigation!))
