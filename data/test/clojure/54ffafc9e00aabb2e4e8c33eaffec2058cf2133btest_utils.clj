(ns dunbar-api.test-utils
  (:require [dunbar-api.db :as db]
            [dunbar-api.handler :as h]
            [ring.mock.request :as mock]
            [cheshire.core :as json]
            [dunbar-api.config :as config]
            [dunbar-api.clock :as clock]
            [dunbar-api.tokens :as token]))

(defn with-db [f]
  (let [db (db/create-db (config/load-config))]
    (db/migrate-db db nil)
    (db/delete-all db)
    (f db)
    (db/stop-db db)))

(defn with-app
  ([component-overrides f]
   (let [config (merge (config/load-config) (:config component-overrides))
         db (or (:db component-overrides) (db/create-db config))
         clock (or (:clock component-overrides) (clock/create-joda-clock))
         token-generator (or (:token-generator component-overrides) (token/create-uuid-token-generator))
         app (h/app config db clock token-generator)]
     ;; FIXME if db is provided, don't manage lifecycle
     (when-not (:db component-overrides)
       (db/migrate-db db nil)
       (db/delete-all db))
     (f app)
     (when-not (:db component-overrides)
       (db/stop-db db))))
  ([f]
    (with-app {} f)))

(defn json-post-req [path body]
  (let [json (json/generate-string body)]
    (-> (mock/request :post path)
        (mock/body json)
        (mock/content-type "application/json; charset=utf-8"))))

(defn json-get-req [path]
  (mock/request :get path))

(defn json-body [resp]
  (when-let [body (:body resp)]
    (json/parse-string body keyword)))


