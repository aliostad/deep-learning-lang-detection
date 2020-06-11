;;; Author: David Goldfarb (deg@degel.com)
;;; Copyright (c) 2017, David Goldfarb

(ns receipts-client.routes
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

(defn qp-server [query-params]
  (when (:server query-params)
    (keyword (:server query-params))))

(defn server-qp [server]
  (str "server=" (name (or server :production))))

(defn page-dispatch [page server]
  (re-frame/dispatch [:set-page page server]))

(defn app-routes []
  (secretary/set-config! :prefix "#")

  (defroute "/" [query-params]
    (page-dispatch :home (qp-server query-params)))

  (defroute "/home" [query-params]
    (page-dispatch :home (qp-server query-params)))

  (defroute "/edit" [query-params]
    (page-dispatch :edit (qp-server query-params)))

  (defroute "/history" [query-params]
    (page-dispatch :history (qp-server query-params)))

  (defroute "/setup" [query-params]
    (page-dispatch :setup (qp-server query-params)))

  (defroute "/about" [query-params]
    (page-dispatch :about (qp-server query-params)))

  (hook-browser-navigation!))

;;; [TODO] If we extend this at all, strongly consider replacing this ad-hoc code with
;;;        https://github.com/SMX-LTD/re-frame-document-fx
(defn goto-page [page server]
  (aset js/window "location" (str "/#/" (name page) "?" (server-qp server))))
