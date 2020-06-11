(ns superiortype.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame :refer [subscribe dispatch]]
            [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [superiortype.utils :refer [scroll-body]]
            [superiortype.cart :as cart]
            [superiortype.foundry :as foundry]
            [superiortype.custom :as custom]
            [superiortype.first-aid :as first-aid]
            [superiortype.font :as font]
            [superiortype.home :as home]
            [superiortype.handlers]
            [superiortype.subs]
            [superiortype.views :as views])
  (:import goog.History))

;; current page implementation
(defmulti current-page #(deref (subscribe [:current-page])))

(defmethod current-page :home []
  (dispatch [:hide-wish-list])
  (scroll-body)
  [home/page])

(defmethod current-page :foundry []
  (dispatch [:hide-wish-list])
  (scroll-body)
  [foundry/page])

(defmethod current-page :custom []
  (dispatch [:hide-wish-list])
  (scroll-body)
  [custom/page])

(defmethod current-page :first-aid []
  (dispatch [:hide-wish-list])
  (scroll-body)
  [first-aid/page])

(defmethod current-page :font []
  [font/page])

(defmethod current-page :error []
  [views/error])

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Routes
(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
    (dispatch [:page-changed :home]))

  (defroute "/foundry" []
    (dispatch [:page-changed :foundry]))

  (defroute "/custom" []
    (dispatch [:page-changed :custom]))

  (defroute "/first-aid" []
    (dispatch [:page-changed :first-aid]))

  (defroute "/font/:id" [id]
    (do
      (dispatch [:font-changed id])))

  (defroute "/font/:id/:section" [id section]
    (do
      ;(dispatch [:section-changed section])
      (dispatch [:font-changed id])))

  (hook-browser-navigation!))

;; -------------------------
;; Initialize app

(defn mount-header []
  (reagent/render [views/header] (.getElementById js/document "header")))

(defn mount-cart []
  (reagent/render [cart/page] (.getElementById js/document "cart")))

(defn mount-app []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn mount-root []
  (mount-header)
  (mount-cart)
  (mount-app))

(defn ^:export main []
  (re-frame/dispatch-sync [:initialize-db])
  (app-routes)
  (mount-root))
