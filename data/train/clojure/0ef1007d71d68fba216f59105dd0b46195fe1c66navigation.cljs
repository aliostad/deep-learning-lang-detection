(ns lend-a-lot.navigation
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [goog.events :as events]
            [reagent.core :as r]
            [goog.history.EventType :as EventType]
            [lend-a-lot.effect-processor :refer [dispatch!]])
  (:import goog.History))

;========= Secratary Config ==========
(secretary/set-config! :prefix "#")

(defroute home-path "/" []
  (dispatch! [:pages :home]))

(defroute details-path "/details/:id" [id]
  (dispatch! [:pages :details id]))

(defroute details-by-item-path "/details-by-item/:id" [id]
  (dispatch! [:pages :details-by-item id]))

(defroute new-user-path "/new" [query-params]
  (let [{item :item} query-params]
    (if (= item "")
      (dispatch! [:pages :new])
      (dispatch! [:pages :new item]))))

(defroute "*" []
  (dispatch! [:pages :home]))


(defonce history
  (let [h (History.)]
    (goog.events/listen h EventType/NAVIGATE #(secretary/dispatch! (.-token %)))
    (doto h (.setEnabled true))))
