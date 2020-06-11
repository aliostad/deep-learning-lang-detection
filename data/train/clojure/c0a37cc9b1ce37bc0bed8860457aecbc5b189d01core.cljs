(ns ics.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [goog.events :as events]
            [reagent.core :as reagent]
            [re-frame.core :as re-frame :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [devtools.core :as devtools]
            [ics.handlers]
            [ics.subs]
            [ics.views :as views]
            [ics.config :as config]
            [cljsjs.highcharts]
            )
  (:import [goog History]
           [goog.history EventType]))

;; -- Routes and History -------
(defroute "/" [] (dispatch [:page :default]))
(defroute "/user/:id" [id] (dispatch [:user id]))
(defroute "/nav/:page" [page] (dispatch [:page (keyword page)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -- Debugging aids -------
(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode")
    (devtools/install!)))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

;; -- Entry Point ------
(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (dev-setup)
  (mount-root))
