(ns palr.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn has-no-conversations? [db]
  (-> db :conversations empty?))

(defn signed-out? [db]
  (-> db :session :access-token empty?))

(defn has-temporary-conversation? [db]
  (->> db :conversations (every? :isPermanent) not))

(def signed-in? (complement signed-out?))

(defn temporarily-matched? [db]
  (-> db :session :isTemporarilyMatched boolean))

(defn permanently-matched? [db]
  (-> db :session :isPermanentlyMatched boolean))

(defn in-matching-process? [db]
  (-> db :session :inMatchingProcess boolean))

(def matched? (some-fn temporarily-matched? permanently-matched?))
(def not-matched? (complement matched?))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" {:as params}
    (re-frame/dispatch [:cond-sap [signed-in? "/conversations"] [] :palr.views/landing])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "/login" {:as params}
    (re-frame/dispatch [:cond-sap [signed-in? "/conversations"] [] :palr.views/login])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "/register" {:as params}
    (re-frame/dispatch [:cond-sap [signed-in? "/conversations"] [] :palr.views/register])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "/match-me" {:as params}
    (re-frame/dispatch [:cond-sap [temporarily-matched? "/conversations" signed-out? "/"] [] :palr.views/match-me])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "/conversations/:id" {:as params}
    (re-frame/dispatch [:cond-sap [not-matched? "/match-me" signed-out? "/"] [[:fetch-conversations] [:fetch-messages (:id params)]] :palr.views/conversations])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "/conversations" {:as params}
    (re-frame/dispatch [:cond-sap [not-matched? "/match-me" signed-out? "/"] [[:fetch-conversations]] :palr.views/conversations])
    (re-frame/dispatch [:reset-router-params params]))

  (defroute "*" {:as params}
    (re-frame/dispatch [:change-route "/"])
    (re-frame/dispatch [:reset-router-params params]))

  ;; --------------------
  (hook-browser-navigation!))
