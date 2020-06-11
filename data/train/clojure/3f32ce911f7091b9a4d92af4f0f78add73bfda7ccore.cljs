(ns raiseyourgame.core
  (:require [raiseyourgame.views :as views]
            [raiseyourgame.subscriptions]
            [raiseyourgame.handlers]
            [raiseyourgame.routes :as routes]
            [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [accountant.core :as accountant]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [devtools.core :as devtools])
  (:import goog.history.Html5History))

(defn initialize []
  (devtools/enable-feature! :sanity-hints :dirac)
  (devtools/install!)

  ; Auto-converts links covered by Secretary into client-side routing dispatch.
  (accountant/configure-navigation!
    {:nav-handler (fn [path] (secretary/dispatch! path))
     :path-exists? (fn [path] (secretary/locate-route path))})

  ; initialize RYG-specific data
  (dispatch-sync [:initialize])

  ; run initial client-side route, if any
  (secretary/dispatch! (.-pathname (.-location js/window))))

; run reagent/render whenever this namespace is loaded
(reagent/render [views/main] (.getElementById js/document "app"))

; only run init function once on document load
(.addEventListener js/window "DOMContentLoaded" initialize)
