(ns riel-backend.models.data.global-exercises-test
  (:require [monger.core :as mg]
            [monger.collection :as mc])
  (:use midje.sweet)
  (:use [riel-backend.models.data.global-exercises]))

(def conn (mg/connect { :host "localhost" }))
(def db (mg/get-db conn "riel"))

(fact "properly manage storing the list of global exercises"
      (with-state-changes [(after :facts (delete-global-exercises db))]
        (fact "insert"
              (insert-global-exercises db) => truthy
              (get-global-exercises db) =not=> #(empty? %))))
