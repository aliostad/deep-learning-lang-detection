(ns frontier.blocksmap.handler
  (:require [frontier.blocksmap.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns blocksmap entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [website-key page-key slot-name & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (and (seq website-key) (seq page-key) (seq slot-name))
      (common/emit-json (#(dissoc % :_id) (db/get-blocksmap db website-key page-key slot-name)))
      (common/emit-json (map #(dissoc % :_id) (db/get-blocksmaps db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{website-key "website-key" page-key "page-key" slot-name "slot-name" block-specifier "block-specifier" block-type "block-type"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/blocksmap-exists? db website-key page-key slot-name)
      (do
        (log/trace "Blocksmap already exists. Use PUT.")
        {:status 400 :body "That blocksmap already exists. Use PUT.\n"})
      (do
        (db/create-blocksmap db website-key page-key slot-name block-specifier block-type)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create blocksmaps"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn put-handler [{{website-key "website-key" page-key "page-key" slot-name "slot-name" block-specifier "block-specifier" block-type "block-type"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/blocksmap-exists? db website-key page-key slot-name)
      (do
        (db/create-blocksmap db website-key page-key slot-name block-specifier block-type)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Blocksmap doesn't already exist. Use POST.")
        {:status 400 :body "That blocksmap doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update blocksmaps"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
