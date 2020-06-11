(ns clirj.events
  (:require [re-frame.core :as rf]))

(rf/reg-event-db
  :initialize
  (fn [_ _]
    {:ws nil
     :members #{}
     :messages []
     :member-input nil
     :message-input nil}))

(rf/reg-event-db
  :web-socket
  (fn [app [_ ws]]
    (assoc app :ws ws)))

(rf/reg-event-db
  :manage-members
  (fn [app [_ members]]
    (assoc app :members members)))

(rf/reg-event-db
  :connect
  (fn [app [_ member]]
    (update-in app [:members] conj (str member))))

(rf/reg-event-db
  :disconnect
  (fn [app [_ member]]
    (update-in app [:members] disj (str member))))

(rf/reg-event-db
  :message
  (fn [app [_ message]]
    (update-in app [:messages] conj message)))

(rf/reg-event-db
  :member-input
  (fn [app [_ member]]
    (assoc app :member-input member)))

(rf/reg-event-db
  :message-input
  (fn [app [_ message]]
    (assoc app :message-input message)))


(rf/reg-sub
  :members
  (fn [app _]
    (:members app)))

(rf/reg-sub
  :messages
  (fn [app _]
    (:messages app)))

(rf/reg-sub
  :ws
  (fn [app _]
    (:ws app)))

(rf/reg-sub
  :member-input
  (fn [app _]
    (:member-input app)))

(rf/reg-sub
  :message-input
  (fn [app _]
    (:message-input app)))

(defn initialize-data
  []
  (rf/dispatch-sync [:initialize]))
