(ns conduit.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re-frame]))

; TODO dispatch route events via secretary

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  (defroute "/" [] (re-frame/dispatch [:set-active-page :home]))
  (defroute "/home" [] (re-frame/dispatch [:set-active-page :home]))
  (defroute "/auth" [] (re-frame/dispatch [:set-active-page :auth]))
  (defroute "/login" [] (re-frame/dispatch [:set-active-page :auth]))
  (defroute "/logout" [] (re-frame/dispatch [:logout!]))
  (defroute "/signup" [] (re-frame/dispatch [:set-active-page :signup]))
  (defroute "/register" [] (re-frame/dispatch [:set-active-page :auth]))
  (defroute "/settings" [] (re-frame/dispatch [:set-active-page :settings]))
  (defroute "/editor" [] (re-frame/dispatch [:set-active-page :editor]))
  (defroute "/editor/:slug" [slug]
            (do (re-frame/dispatch [:set-active-page :editor])
                (re-frame/dispatch [:set-active-article slug])))
  (defroute "/article/:slug" [slug]
            (do (re-frame/dispatch [:set-active-page :article])
                (re-frame/dispatch [:set-active-article slug])))
  (defroute "/profile" [] (re-frame/dispatch [:set-active-page :profile]))
  (defroute "/profile/:username" [username]
            (do (re-frame/dispatch [:set-active-page :profile])
                (re-frame/dispatch [:set-active-profile username])))
  (defroute "/profile/:username/favorites" [username]
            (do (re-frame/dispatch [:set-active-page :profile])
                (re-frame/dispatch [:set-active-profile username])))
  (hook-browser-navigation!))
