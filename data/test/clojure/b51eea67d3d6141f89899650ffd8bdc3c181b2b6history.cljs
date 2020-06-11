"A namespace with functions to manage connection history"
(ns pult.models.history
  (:require [pult.utils :refer [current-time log error]]
            [pult.models.helpers :as h]))

(def store-name "history")
(def store-index "timeIndex")

(defn add
  "adds a new connection item"
  ([db history-dt]
    (add db history-dt #(log "Success: new item in " store-name)))
  ([db history-dt success-fn]
    (h/add db
           store-name
           (merge {:timestamp (current-time)} history-dt)
           success-fn)))

(defn get-by
  "gets an item by its index"
  ([db index-val]
    (get-by db index-val #(log "Got: " (pr-str %))))
  ([db index-val success-fn]
    (h/get-by db store-name store-index index-val success-fn)))

(defn get-all
  "gets a whole list of connection history"
  ([db success-fn]
    (get-all db success-fn 0))
  ([db success-fn from-key]
    (h/get-all db store-name from-key success-fn)))

(defn get-n-latest
  [db n success-fn]
  (get-all
    db
    (fn [rows]
      (->> rows
          (sort-by :timestamp >)
          (take n)
          (vec)
          (success-fn)))))

(defn delete-all
  "cleans whole connection history"
  [db]
  (h/delete-store db store-name))

