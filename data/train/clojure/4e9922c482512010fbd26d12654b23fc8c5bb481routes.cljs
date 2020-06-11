(ns examples.routes
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
  ;; --------------------
  ;; define routes here
  (defroute "/" []
    (re-frame/dispatch [:set-viewing :about]))

  (defroute "/about" []
    (re-frame/dispatch [:set-viewing :about]))

  (defroute "/docs" []
    (re-frame/dispatch [:set-viewing :api-docs]))

  (defroute "/tutorial" []
    (re-frame/dispatch [:set-viewing :tutorial]))

  (defroute "/examples/:category/:id" {:keys [category id]}
    (re-frame/dispatch [:set-viewing-examples [(keyword category)
                                               (keyword id)]]))

  (defroute "/examples" []
    (re-frame/dispatch [:set-viewing :examples]))

  ;; --------------------
  (hook-browser-navigation!))
