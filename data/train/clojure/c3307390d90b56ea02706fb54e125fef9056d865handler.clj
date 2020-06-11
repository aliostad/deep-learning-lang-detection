(ns frontier.auth.handler
  (:require [clojure.data.json :as json]
            [frontier.auth.db :as db]
            [frontier.common :as common]
            [frontier.config :as config]
            [clj-time.core :as t]
            [clojure.tools.logging :as log])
  (:import (java.util UUID)))

(def auth-tokens->users (atom {}))
(def user-ids->auth-tokens (atom {}))

(defn authenticate
  [db website-key name password]
  (let [res (:user-id (db/get-auth db website-key name password))]
    (log/trace "authenticate" website-key name password "returned" res)
    res))

(defn get-authenticated-user                                ; TODO: auth-token should only work with a single originating IP
  [auth-token]
  (log/trace "get-authenticated-user" auth-token)
  (let [res (get @auth-tokens->users auth-token)]
    (log/trace "got" res)
    res))

(defn user-exists?
  [db website-key name]
  (let [res (:user-id (db/has-auth? db website-key name))]
    (log/trace "user-exists?" website-key name "returned" res)
    res))

(defn get-or-create-auth-token
  [user]
  (if-let [auth-token (get user-ids->auth-tokens (:user-id user))]
    auth-token
    (if user
      (let [auth-token (common/generate-key 32)]
        (swap! auth-tokens->users #(assoc % auth-token user))
        (swap! user-ids->auth-tokens #(assoc % (:user-id user) auth-token))
        auth-token)
      nil)))

(defn login
  "Checks login details and if valid returns a vec [auth-token user]. Returns nil otherwise."
  [db website-key name password]
  (log/trace "authenticating" website-key name password)
  (if-let [authenticated-user-id (authenticate db website-key name password)]
    (do
      (log/trace "getting user" authenticated-user-id)
      (if-let [user (db/get-user db authenticated-user-id)]
        (let [auth-token (get-or-create-auth-token user)]
          [auth-token user])
        (log/trace "no user")))))                           ;; TODO: what about wedding accounts where there isn't a user?

(defn login-handler
  "Checks the given credentials and returns an auth token if user can log in"
  [{{password "password" name "username"} :params {website-key :key} :website :as request} db]
  (prn request)
  (if (= :post (:request-method request))
    (do
      (log/trace "login-handler name=" name "password=" password)
      (if-let [[auth-token user] (login db website-key name password)]
        (common/emit-json {:auth-token auth-token})
        (do
          (log/trace "Can't find user. Invalid credentials:" name password)
          (common/emit-json {:message "Invalid credentials"}, 401))))
    (common/emit-json {:message "Not implemented"}, 501)))

(defn generate-user-id
  [username timestamp]
  (str (UUID/randomUUID) "-" timestamp))

(defn create-authenticated-user
  "Creates a user and gives it an account on website-key"
  [db website-key {:keys [user-id username password roles default-website-key sites-managed full-name email]}]
  (db/create-user db user-id roles default-website-key sites-managed full-name email)
  (db/create-account db user-id website-key username password))

(defn signup-handler
  "Adds the given credentials and returns an auth token"
  ; Anyone can sign up atm
  [{{password "password" name "username" email "email"} :params {website-key :key} :website timestamp :timestamp :as request} db]
  (if (= :post (:request-method request))
    (do
      (log/trace "signup-handler name=" name "password=" password "email=" email)
      (if-let [existing-user (user-exists? db website-key name)]
        (common/emit-json {:message "Username already exists"}, 409)
        (let [user-id (generate-user-id name timestamp)]
          (create-authenticated-user
            db website-key {:user-id user-id :username name :password password :roles [] :default-website-key website-key :sites-managed [] :full-name "" :email email})
          (common/emit-json {:message "Sign up accepted" :user-id user-id}, 200))))
    (common/emit-json {:message "Not implemented"}, 501)))

(defn helper-token-matches-role
  "Returns true if user is authenticated and matches role, false if user is authenticated but doesn't match role,
  and nil if user not authenticated."
  [auth-token role]
  (if-let [user (get-authenticated-user auth-token)]
    (do
      (log/trace "Checking user" (:user-id user) "for role" role)
      (if (contains? (:roles user) role)
        true
        (do
          (log/trace "User doesn't have the necessary role.")
          false)))
    nil))

(defn helper-token-is-manager-for-site
  "Returns true if user is authenticated and manages site, false if user is authenticated but doesn't manage site,
  and nil if user not authenticated."
  [auth-token site]
  (if-let [user (get-authenticated-user auth-token)]
    (do
      (log/trace "User" (:full-name user) "wants to manage site" site)
      (if (or (contains? (:sites-managed user) site) (contains? (:roles user) "manager
      -role"))
        true
        (do
          (log/trace "User is not allowed to manage the site.")
          false)))
    nil))

(defn get-all-users
  [db]
  (let [users (db/get-users db)]
    (common/emit-json (map #(dissoc % :_id) users))))

(defn get-user
  [db user-id]
  (common/emit-json (dissoc (db/get-user db user-id) :_id)))

(defn api-get-handler
  [{{auth-token "auth-token"} :params :as request} [user-id & extra-path-parts] db]
  (case (helper-token-matches-role auth-token "sysadmin-role")
    true
    (if-not (empty? user-id)
      (get-user db user-id)
      (get-all-users db))

    false
    {:status 401 :body "Only administrator can access users"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn manager-post-handler
  "Creates a new user with authority to manage the specified website"
  [{{auth-token  "auth-token"
     username    "username"
     full-name   "full-name"
     password    "password"
     managed-site "managed-site"
     parent-site "account"} :params
    timestamp :timestamp
    :as request}
   db]
  (log/trace "auth/api-post-handler" auth-token "posts" managed-site username password)
  (case (helper-token-matches-role auth-token "sysadmin-role")
    true
    (let [user-id (generate-user-id username timestamp)]
      (create-authenticated-user db parent-site
                                 {:user-id user-id
                                  :username username
                                  :password password
                                  :roles []
                                  :default-website-key managed-site
                                  :sites-managed [managed-site]
                                  :full-name (or full-name username)})
      (common/emit-json {:status "ok" :user-id user-id}))

    false
    (do
      (log/trace "Requesting user doesn't have sysadmin-role. Only sysadmin-role can create users.")
      {:status 401 :body "Only administrator can create users"})

    nil
    {:status 401 :body "Requesting user is not authenticated"}))

(defn manager-handler
  [request path db]
  (case (:request-method request)
    :post (manager-post-handler request db)
    :get (api-get-handler request path db)
    :head (assoc (api-get-handler request path db) :body nil)
    {:status 501 :body (str "The HTTP method " (name (:request-method request)) " is not implemented here")}))
