(ns frontier.block.handler
  (:require [frontier.block.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns block entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [website-key key & extra-path-parts :as path] db] ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (and (seq website-key) (seq key))
      (common/emit-json (#(dissoc % :_id) (db/get-block db website-key key)))
      (common/emit-json (map #(dissoc % :_id) (db/get-blocks db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{key "key" website-key "website-key" content "content" style "style"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/block-exists? db key)
      (do
        (log/trace "Block already exists. Use PUT.")
        {:status 400 :body "That block already exists. Use PUT.\n"})
      (do
        (db/create-block db key website-key content style)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create blocks"}

    nil
    {:status 401 :body "User is not authenticated"}))

(defn put-handler [{{key "key" website-key "website-key" content "content" style "style"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/block-exists? db key)
      (do
        (db/create-block db key website-key content style)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Block doesn't already exist. Use POST.")
        {:status 400 :body "That block doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update blocks"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
