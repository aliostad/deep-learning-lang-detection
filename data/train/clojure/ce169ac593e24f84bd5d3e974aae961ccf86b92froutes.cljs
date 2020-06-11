(ns respa.routes
  (:require-macros [secretary.core :refer [defroute]]) 
  (:import [goog History]
           [goog.history EventType])
  (:require [secretary.core :as secretary]
            [accountant.core :as accountant]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))


;; accountant allows 
(accountant/configure-navigation!
 {:nav-handler (fn [path]
                 (secretary/dispatch! path))
  :path-exists? (fn [path]
                  (secretary/locate-route path))})


(defn app-routes [] 
  (defroute home  "/home"  [] (dispatch [:navigate-to :home]))
  (defroute login "/login" [] (dispatch [:navigate-to :login]))
  (defroute about "/about" [] (dispatch [:navigate-to :about])))
