(ns moc.core
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [dispatch-sync]]
            [goog.dom :as gdom]
            [moc.db]
            [moc.router :refer [navigate!]]
            [moc.ui.router :refer [router]]
            [moc.subscription.imports]
            [moc.handler.imports]))

(defn ^:export reload! []
  (navigate! nil)
  (reagent/render [router] (gdom/getElement "app")))

(defn ^:export main []
  (enable-console-print!)
  (dispatch-sync [:app/initialize])
  (dispatch-sync [:user/get-current]) ;; Works as a check for login-status
  (reload!))
