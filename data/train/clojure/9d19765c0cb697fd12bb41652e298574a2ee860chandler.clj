(ns frontier.account.handler
  (:require [frontier.account.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns account entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [user-id & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (seq user-id)
      (common/emit-json (#(dissoc % :_id) (db/get-account db user-id)))
      (common/emit-json (map #(dissoc % :_id) (db/get-accounts db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{user-id "user-id" auth-id "auth-id"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/account-exists? db user-id)
      (do
        (log/trace "Account already exists. Use PUT.")
        {:status 400 :body "That account already exists. Use PUT.\n"})
      (do
        (db/create-account db user-id auth-id)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create accounts"}

    nil
    {:status 401 :body "User is not authenticated"}))

(defn put-handler [{{user-id "user-id" auth-id "auth-id"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/account-exists? db user-id)
      (do
        (db/create-account db user-id auth-id)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Account doesn't already exist. Use POST.")
        {:status 400 :body "That account doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update accounts"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
