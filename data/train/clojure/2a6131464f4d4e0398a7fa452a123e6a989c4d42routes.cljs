(ns devdays.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]
              [pushy.core :as pushy]
              [accountant.core :as accountant]))

(def history (pushy/pushy secretary/dispatch!
                      (fn [x] (when (secretary/locate-route x) x))))

;; Start event listeners
(pushy/start! history)

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "/")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/counter" []
    (re-frame/dispatch [:set-active-panel :counter-panel]))

  (defroute "/input" []
    (re-frame/dispatch [:set-active-panel :input-panel]))

  ;; --------------------
  (hook-browser-navigation!)

  (accountant/configure-navigation!
  {:nav-handler
   (fn [path]
     (secretary/dispatch! path))
   :path-exists?
   (fn [path]
     (secretary/locate-route path))})
  (accountant/dispatch-current!))
