(ns athens.controllers.t-likes
  (:require [athens.db.test :as tdb]
            [athens.db.query :as q]
            [athens.db.manage :as db-manage]
            [athens.controllers.likes :as likes])
  (:use midje.sweet
        athens.paths
        athens.controllers.test-helpers))

(setup-db-background)

(defn like
  ([]
     (like (:id (auth))))
  ([userid]
     (q/one [:like/user userid])))

(fact "creating a like results in success"
  (let [response (res :post (str "/likes/" (post-id)) nil (auth "flyingmachine"))]
    (:db/id (:like/user (like))) => (:id (auth))
    response => (contains {:status 201})))

(fact "deleting a like as the creator results in success"
  (res :post (str "/likes/" (post-id)) nil (auth "flyingmachine"))
  (let [response (res :delete (str "/likes/" (post-id)) nil (auth "flyingmachine"))]
    (like) => nil
    response => (contains {:status 204})))
