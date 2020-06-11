(ns crudurama.routes
  (:require [re-frame.core :refer [dispatch dispatch-sync subscribe] :as rf]
            [goog.events :as events]
            [goog.history.EventType :as HistoryEventType]
            [secretary.core :as secretary]
            [crudurama.utils :refer [dispatch-multi]]
            [accountant.core :as accountant])
  (:import goog.History))

;; -------------------------
;; Routes
(secretary/defroute "/" []
  (dispatch-multi [[:set-active-page :home]
                   [:get-first-page]
                   [:set-show-more]]))

(secretary/defroute "/signup" []
  (dispatch [:set-active-page :signup]))

(secretary/defroute "/login" []
  (dispatch [:set-active-page :login]))

(secretary/defroute "/about" []
  (dispatch [:set-active-page :about]))

(secretary/defroute "/robot/:id" [id]
  (dispatch-multi [[:load-robot (js/parseInt id)]
                   [:set-active-page :view-robot]]))

(secretary/defroute "/create-robot" []
  (dispatch [:set-active-page :create-robot]))

(secretary/defroute "/edit-robot" []
  (dispatch [:set-active-page :edit-robot]))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      HistoryEventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true))
  (accountant/configure-navigation!
    {:nav-handler
     (fn [path]
       (secretary/dispatch! path))
     :path-exists?
     (fn [path]
       (secretary/locate-route path))})
  (accountant/dispatch-current!))
