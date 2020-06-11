(ns app.routes
  (:require
   [cljs.core.async :as async
    :refer [<!]]
   [goog.dom :as dom]
   [goog.events :as events]
   [goog.history.EventType :as EventType]
   [secretary.core :as secretary
    :refer-macros [defroute]]
   [app.session :as session
    :refer [dispatch]])
  (:import
   [goog History]))

(secretary/set-config! :prefix "#")

(def history
  (memoize #(History.)))

(defn navigate! [token & {:keys [stealth]}]
  (if stealth
    (secretary/dispatch! token)
    (.setToken (history) token)))

(defn hook-browser-navigation! []
  (doto (history)
    (events/listen EventType/NAVIGATE
                   (fn [event]
                     (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defroute "/" []
  nil)

(defroute "/refresh" []
  (dispatch [:refresh])
  (navigate! "/"))
