(ns frontier.user.handler
  (:require [frontier.user.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns user entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [user-id & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (seq user-id)
      (common/emit-json (assoc (#(dissoc % :_id) (db/get-user db user-id)) :_path user-id ))
      (common/emit-json (map #(assoc (dissoc % :_id) :_path (:user-id %))) (db/get-users db)))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{roles "roles" full-name "full-name" default-site-key "default-site-key" user-id "user-id" sites-managed "sites-managed"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/user-exists? db user-id)
      (do
        (log/trace "User already exists. Use PUT.")
        {:status 400 :body "That user already exists. Use PUT.\n"})
      (do
        (db/create-user db roles full-name default-site-key user-id sites-managed)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create users"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn put-handler [{{roles "roles" full-name "full-name" default-site-key "default-site-key" user-id "user-id" sites-managed "sites-managed"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/user-exists? db user-id)
      (do
        (db/create-user db roles full-name default-site-key user-id sites-managed)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "User doesn't already exist. Use POST.")
        {:status 400 :body "That user doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update users"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
