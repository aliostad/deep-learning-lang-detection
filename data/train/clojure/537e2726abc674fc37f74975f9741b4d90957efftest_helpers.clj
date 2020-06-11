(ns weatherjerk.controllers.test-helpers
  (:require [weatherjerk.db.test :as tdb]
            [weatherjerk.db.query :as q]
            [weatherjerk.db.manage :as db-manage]
            [weatherjerk.server :as server]
            [clojure.data.json :as json])
  (:use midje.sweet
        weatherjerk.utils
        weatherjerk.paths
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
