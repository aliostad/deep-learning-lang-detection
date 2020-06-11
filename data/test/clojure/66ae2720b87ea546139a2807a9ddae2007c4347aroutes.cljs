(ns til.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as rf]
            [til.util :as u]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn add-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (rf/dispatch [:set-active-page :home]))

  (defroute "/new" []
    (rf/dispatch [:set-active-page :new]))

  (defroute "/tidbits" []
    (rf/dispatch [:set-active-page :tils]))

  (defroute "/bit/:id" [id]
    (rf/dispatch [:set-route-id (u/hash->id id)])
    (rf/dispatch [:set-active-page :til]))

  (defroute "/tag/:tag" [tag]
    (rf/dispatch [:set-route-tag tag])
    (rf/dispatch [:set-active-page :tag]))

  (defroute "*" {:as p}
    (rf/dispatch [:set-route-not-found (:* p)])
    (rf/dispatch [:set-active-page :not-found]))

  (hook-browser-navigation!))
