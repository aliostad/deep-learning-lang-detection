(ns token.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :refer [dispatch]]))

(defonce history (History.))

(defn nav! [token]
  (.setToken history (secretary/locate-route-value token)))

(defn hook-browser-navigation! []
  (doto history
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" []
            (dispatch [:set :current-wallet nil])
            (dispatch [:set-active-panel :wallets-panel]))

  (defroute "/wallet/:wallet-id" [wallet-id]
            (dispatch [:set :current-wallet wallet-id])
            (dispatch [:set-active-panel :wallet-panel wallet-id]))

  (defroute "/transaction" []
            (dispatch [:set-active-panel :transaction-panel]))

  (hook-browser-navigation!))
