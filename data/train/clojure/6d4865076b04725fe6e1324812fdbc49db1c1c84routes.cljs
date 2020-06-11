(ns service-purchase-cljs.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as rf]))

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
            (rf/dispatch [:set-active-panel :home-panel]))
  (defroute "/service-purchase" []
            (rf/dispatch [:set-active-panel :service-purchase]))
  (defroute "/account/:account-id" [account-id]
            (rf/dispatch [:set-active-panel :account-page account-id]))
  (defroute "/about" []
            (rf/dispatch [:set-active-panel :about-panel]))


  ;; --------------------
  (hook-browser-navigation!))
