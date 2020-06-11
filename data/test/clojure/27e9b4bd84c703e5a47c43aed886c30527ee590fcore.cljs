(ns merkledag.browser.core
  (:require-macros
    [secretary.core :refer [defroute]])
  (:require
    [ajax.core :as ajax]
    [ajax.edn :refer [edn-response-format]]
    [goog.events :as events]
    [goog.history.EventType :as EventType]
    [merkledag.browser.handlers]
    [merkledag.browser.queries]
    [merkledag.browser.routes]
    [merkledag.browser.views :as views]
    [multihash.core :as multihash]
    [reagent.core :as reagent]
    [re-frame.core :refer [dispatch dispatch-sync]]
    [secretary.core :as secretary])
  (:import
    goog.History))


(enable-console-print!)


(defn ^:export run
  [container]
  (dispatch-sync [:initialize-db])
  (reagent/render-component
    [views/browser-app]
    container))


(defn on-js-reload
  []
  (dispatch [:touch-ui]))
