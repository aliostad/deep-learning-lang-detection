(ns barr-hub.routes
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
  (secretary/set-config! :prefix "#")
  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/search/" [query-params]
    (js/console.log (str "---> " query-params))
    (re-frame/dispatch [:set-active-panel :search-repositories-panel])
    (re-frame/dispatch-sync [:request-search query-params]))

  ;; --------------------
  (hook-browser-navigation!))
