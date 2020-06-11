(ns coverton.index.events
  (:require [re-frame.core :as rf :refer [reg-event-db path trim-v reg-event-fx dispatch]]
            [coverton.index.db :refer [default-value]]
            [taoensso.timbre :refer-macros [info]]
            [coverton.ajax.events :as ajax-evt]
            [coverton.util :refer [merge-db]]))



(def index-interceptors [(path :index) trim-v])


(reg-event-fx
 ::initialize
 index-interceptors
 (fn [_ _]
   {:db default-value
    :dispatch [::refresh]}))


(reg-event-fx
 ::refresh
 index-interceptors
 (fn [{db :db} _]
   {:dispatch [::get-covers {:tags (:search-tags db)}]}))


(reg-event-db
 ::update
 index-interceptors
 (fn [db [k f & args]]
   (apply update db k f args)))


(reg-event-db
 ::assoc
 index-interceptors
 (fn [db [k v]]
   (assoc db k v)))


(reg-event-db
 ::merge
 index-interceptors
 merge-db)


(reg-event-db
 ::set-page
 index-interceptors
 (fn [db [k]]
   (assoc db :page k)))



(reg-event-fx
 ::login
 index-interceptors
 (fn [{db :db} [{:keys [email] :as creds}]]
   {:db (assoc db :user email )
    :dispatch
    [::ajax-evt/request {:method     :post
                         :uri        "/login"
                         :params     creds
                         :on-success [::ajax-evt/set-token]}]}))



(reg-event-fx
 ::logout
 index-interceptors
 (fn [{db :db} _]
   {:db (dissoc db :authenticated?)
    :dispatch [::ajax-evt/remove-token]}))



(reg-event-fx
 ::get-covers
 index-interceptors
 (fn [_ [opts]]
   {:dispatch
    [::ajax-evt/request-auth {:method :post
                              :uri "/get-covers"
                              :params opts
                              :on-success [::merge]}]}))





(defn set-page [k]
  (dispatch [::set-page k]))


(defn refresh []
  (dispatch [::refresh]))


(defn set-active-cover [cover]
  (dispatch [::assoc :active-cover cover]))



(defn request-invite [data]
  (dispatch [::ajax-evt/request
             {:method :post
              :uri "/request-invite"
              :params data
              :on-success [::merge]}]))


(defn login [creds]
  (dispatch [::login creds]))
