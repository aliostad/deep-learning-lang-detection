(ns frontier.page.handler
  (:require [frontier.page.db :as db]
            [frontier.common :as common]
            [frontier.auth.handler :as auth]
            [clojure.tools.logging :as log]))

(defn get-handler
  "Returns page entities that the requesting user, represented by auth-token, is allowed to manage."
  [{auth-token :auth-token :as request} [website-key url-key & extra-path-parts :as path] db]       ;; using :auth-token not "auth-token" because we set :auth-token ourselves further up the call stack in a big OR statement
  (if-let [user (auth/get-authenticated-user auth-token)]
    (if (and (seq website-key) (seq url-key))
      (common/emit-json (#(dissoc % :_id) (db/get-page db website-key url-key)))
      (common/emit-json (map #(dissoc % :_id) (db/get-pages db))))
    (do
      (log/info "Couldn't find a user for the supplier auth-token")
      {:status 401 :body "User is not authenticated"})))


(defn post-handler [{{url-key "url-key"
                      layout-key "layout-key"
                      type "type"
                      website-key "website-key"
                      restrictions "restrictions"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/page-exists? db website-key url-key)
      (do
        (log/trace "Page already exists. Use PUT.")
        {:status 400 :body "That page already exists. Use PUT.\n"})
      (do
        (db/create-page db url-key
                        layout-key
                        type
                        website-key
                        restrictions)
        (common/emit-json {:status "ok"})))

    false
    {:status 401 :body "Only administrator can create pages"}

    nil
    {:status 401 :body "User is not authenticated"}))

(defn put-handler [{{url-key "url-key"
                      layout-key "layout-key"
                      type "type"
                      website-key "website-key"
                      restrictions "restrictions"} :body {auth-token "auth-token"} :params :as request} db]
  (case (auth/helper-token-matches-role auth-token "sysadmin-role")
    true
    (if (db/page-exists? db website-key url-key)
      (do
        (db/create-page db url-key
                        layout-key
                        type
                        website-key
                        restrictions)
        (common/emit-json {:status "ok"}))
      (do
        (log/trace "Page dosen't already exist. Use POST.")
        {:status 400 :body "That page doesn't already exist. Use POST.\n"}))

    false
    {:status 401 :body "Only administrator can update pages"}

    nil
    {:status 401 :body "User is not authenticated"}))


(defn handler
  [request path db]
  (case (:request-method request)
     :post (post-handler request db)
     :put (put-handler request db)
     :get (get-handler request path db)
     :head (assoc (get-handler request path db) :body nil)))
