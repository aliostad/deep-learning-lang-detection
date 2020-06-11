(ns frontier.domain.handler
  (:require [frontier.domain.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns domain entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [domain & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (seq domain)
      (common/emit-json (#(dissoc % :_id) (db/get-domain db domain)))
      (common/emit-json (map #(dissoc % :_id) (db/get-domains db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{domain "domain" website-key "website-key"} :body {auth-token "auth-token"} :params :as request} db]
  (prn "why getting old data" request)
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/domain-exists? db domain)
      (do
        (log/trace "Domain already exists. Use PUT.")
        {:status 400 :body (format "That domain %s already exists. Use PUT.\n" name)})
      (do
        (log/trace "Domain being created" domain website-key)
        (db/create-domain db domain website-key)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create domains"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn put-handler [{{domain "domain" website-key "website-key"} :body {auth-token "auth-token"} :params :as request} db]
  (prn "why getting old data" request)
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/domain-exists? db domain)
      (do
        (log/trace "Domain being created" domain website-key)
        (db/create-domain db domain website-key)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Domain doesn't already exist. Use POST.")
        {:status 400 :body (format "That domain %s doesn't already exist. Use POST.\n" name)}))

    false
    {:status 401 :body "Only administrator can update domains"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
