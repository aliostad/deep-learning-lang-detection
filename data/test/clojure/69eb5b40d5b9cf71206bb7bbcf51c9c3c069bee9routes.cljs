(ns wesele-app.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]
              [wesele-app.utils.login :refer [check-login-time]]
              ))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
    (if (false? (check-login-time))
      (re-frame/dispatch [:set-active-panel :login-page])
      (re-frame/dispatch [:set-active-panel :home-page])))

  (defroute "/login" []
    (re-frame/dispatch [:set-active-panel :login-page]))
  
  (defroute "/rsvp" []
    (re-frame/dispatch [:set-active-panel :rsvp-page]))

  (defroute "/news" []
    (re-frame/dispatch [:set-active-panel :news-page]))

  (defroute "/church" []
    (if (false? (check-login-time))
      (re-frame/dispatch [:set-active-panel :login-page])
      (re-frame/dispatch [:set-active-panel :church-page])))

  (defroute "/wedding-hall" []
    (if (false? (check-login-time))
      (re-frame/dispatch [:set-active-panel :login-page])
      (re-frame/dispatch [:set-active-panel :wedding-hall-page])))

  (defroute "/galeria" []
    (if (false? (check-login-time))
      (re-frame/dispatch [:set-active-panel :login-page])
      (do
        (re-frame/dispatch [:request-gallery "gallery/1"])
        (re-frame/dispatch [:set-active-panel :gallery-page]))))

  ;; --------------------
  (hook-browser-navigation!))
