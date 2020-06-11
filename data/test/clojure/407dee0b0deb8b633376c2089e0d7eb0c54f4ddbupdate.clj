(ns ircbook-viewer.update
  (:require [schema.core :as s]
            [cheshire.core :as j :refer :all]
            [clj-time.core :as t]
            [clojure.java.jdbc :as sql]
            [ircbook-viewer.data.order :as o]
            [clj-time.format :as f]))

(def db {:classname   "org.sqlite.JDBC", :subprotocol "sqlite", :subname
         "test.db"})

(defn get-stream
  "Gets stream of JSON from given filename for the status file"
  [fname]
  (j/parse-stream (clojure.java.io/reader fname)))

(def create-orders-sql (sql/create-table-ddl :orders
                                             [[:id :integer :primary :key :autoincrement]
                                              [:account_id :text]
                                              [:side "varchar(32)"]
                                              [:instrument_id :text]
                                              [:price :text]
                                              [:num_shares :text]
                                              [:timestamp :text]
                                              [:rank :int]]))
(defn reset-orders
  []
  (do (sql/execute! db ["drop table if exists orders"])
      (sql/execute! db create-orders-sql)))

(def my-date-formatter (f/formatters :ordinal-date-time))

(s/defn order-to-row
  "Converts an order into map for inserting"
  [order :- o/Order]
  {:account_id (:account-id order)
   :side (if (= (:side order) :ask)
           "ask"
           "bid")
   :instrument_id (:instrument-id order)
   :price (str (:price order))
   :num_shares (str (:num-shares order))
   :timestamp (f/unparse my-date-formatter (:timestamp order))
   :rank  (:rank order)})

(s/defn order-from-row :- o/Order
  "Converts an order from map from results"
  [row]
  {:account-id (:account_id row)
   :side (if (= (:side row) "ask")
           :ask
           :bid)
   :instrument-id (:instrument_id row)
   :price (BigDecimal. (:price row))
   :num-shares (BigDecimal. (:num_shares row))
   :timestamp (f/parse my-date-formatter (:timestamp row))
   :rank (:rank row)})

(s/defn get-orders-from-stream :- [o/Order]
  "Should return a vector of Orders"
  [stream]
  (let [js-orders (get-in stream ["Orderbook" "orders"])]
    (into [] (map o/parse-order js-orders))))

(s/defn get-most-recent-order :- o/Order
  []
   (first (sql/query db ["select * from orders order by timestamp desc limit 1"])))

(defn import-new-orders
  "Imports most recent orders from the status file into the DB
  This is really the only function that should be called externally"
  [fname]
  (let [most-recent (get-most-recent-order)]
    (if (some? most-recent) 
      (let [curr-newest (order-from-row most-recent)
            filt (fn [order]
                   (t/after? (:date order) (:date curr-newest)))]
        (sql/insert-multi! db :orders (map order-to-row
                                           (filter
                                            filt
                                            (get-orders-from-stream (get-stream fname))))))
      (sql/insert-multi! db :orders (map order-to-row
                                         (get-orders-from-stream (get-stream fname)))))))
