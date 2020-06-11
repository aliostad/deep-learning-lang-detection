(ns btc-market.subs
  (:require [re-frame.core :refer [reg-sub]]))

(reg-sub
 :active-instrument-data
 (fn [db _]
   (let [instrument (:active-instrument db)]
     (or  (get (:market-data db) instrument ) {:instrument instrument}))))

(reg-sub
 :coin-prices
 (fn [db _]
   (:prices db)))

(reg-sub
 :top-view
 (fn [db _]
   (first (:view-stack db))))

(reg-sub
 :config
 (fn [db _]
   (:config db)))

(reg-sub
 :account
 (fn [db _]
   (:account db)))

(reg-sub
 :open-orders
 (fn [db [_ instrument]]
   (let [instrument (or instrument (:active-instrument db))]
     (filter #(= (:instrument %) instrument) (:orders db)))))
