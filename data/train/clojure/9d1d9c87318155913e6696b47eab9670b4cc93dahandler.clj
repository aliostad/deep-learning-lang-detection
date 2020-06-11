(ns frontier.navigation.handler
  (:require [frontier.navigation.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns navigation entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [website-key & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (seq website-key)
      (common/emit-json (#(dissoc % :_id) (db/get-navigation db website-key)))
      (common/emit-json (map #(dissoc % :_id) (db/get-navigations db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{website-key "website-key"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/navigation-exists? db website-key)
      (do
        (log/trace "Navigation already exists. Use PUT.")
        {:status 400 :body "That navigation already exists. Use PUT.\n"})
      (do
        (db/create-navigation db website-key)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create navigations"}

    nil
    {:status 401 :body "User is not authenticated"}))

(defn put-handler [{{website-key "website-key"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/navigation-exists? db website-key)
      (do
        (db/create-navigation db website-key)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Navigation doesn't already exist. Use POST.")
        {:status 400 :body "That navigation doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update navigations"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
