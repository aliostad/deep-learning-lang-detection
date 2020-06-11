(ns frontier.site.handler
  (:require [clojure.data.json :as json]
            [frontier.site.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns website entities for the sites that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [website-key & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (prn "get-handler path",path)
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (seq website-key)
      (common/emit-json (#(dissoc (assoc % :is-default (= (:key %) (:default-site-key user))) :_id) (db/get-site db website-key)))
      (common/emit-json (map #(dissoc (assoc % :is-default (= (:key %) (:default-site-key user))) :_id) (db/get-sites db #_(:sites-managed user)))
                        ;{:default (dissoc default-site :_id) :managed (map #(dissoc % :_id) sites)}
                        ))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{key "key"
                      default-page-key "default-page-key"
                      not-found-page-key "not-found-page-key"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/site-exists? db key)
      (do
        (log/trace "Site already exists. Use PUT.")
        {:status 400 :body "That site already exists. Use PUT.\n"})
      (do
        (db/upsert-site db key default-page-key not-found-page-key)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create sites"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn put-handler [{{key "key"
                      default-page-key "default-page-key"
                      not-found-page-key "not-found-page-key"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/site-exists? db key)
      (do
        (db/upsert-site db key default-page-key not-found-page-key)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Site doesn't yet exist. Use POST.")
        {:status 400 :body "That site doesn't yet exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update sites"}

    nil
    {:status 401 :body "User is not authenticated"}))

(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))

(defn get-site
  [db website-key]
  (db/get-site db website-key))

(defn get-domain
  [db domain]
  (db/get-domain db domain))

(defn get-domains
  [db]
  (db/get-domains db))

(defn create-website
  [db domain website-key]
  (db/upsert-website db {:key website-key})
  (db/upsert-domain db {:domain domain :website-key website-key}))

(defn modify-website
  [db website-key default-page-key login-page-key not-found-page-key]
  (db/upsert-website db {:key website-key :default-page-key default-page-key :login-page-key login-page-key :not-found-page-key not-found-page-key}))