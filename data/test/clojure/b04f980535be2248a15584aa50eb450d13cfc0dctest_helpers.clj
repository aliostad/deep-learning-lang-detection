(ns athens.controllers.test-helpers
  (:require [athens.db.test :as tdb]
            [athens.db.query :as q]
            [athens.db.manage :as db-manage]
            [athens.server :as server]
            [clojure.data.json :as json])
  (:use midje.sweet
        athens.utils
        athens.paths
        [ring.mock.request :only [request header content-type]]))

(defn auth
  ([] (auth "flyingmachine"))
  ([username]
     {:id (:db/id (q/one [:user/username username]))
      :username username}))

(defn authenticated
  [request auth]
  (if auth
    (merge request {:authentications {:test auth}
                    :current :test})
    request))

(defnpd req
  [method path [params nil] [auth nil]]
  (-> (request method path params)
      (content-type "application/json")
      (authenticated auth)))

(defnpd res
  [method path [params nil] [auth nil]]
  (let [params (json/write-str params)]
       (server/app (req method path params auth))))

(defn data
  [response]
  (-> response
      :body
      json/read-str))

(defnpd response-data
  [method path [params nil] [auth nil]]
  (data (res method path params auth)))

(defmacro setup-db-background
  []
  `(background
    (before :contents (tdb/with-test-db (db-manage/reload)))
    (around :facts (tdb/with-test-db ?form))))

(defn topic-id
  []
  (:db/id (q/one [:topic/title])))

(defn post-id
  ([] (post-id "flyingmachine"))
  ([author-username]
     (:db/id (q/one [:post/content] [:content/author (:id (auth author-username))]))))
