(ns darg.oauth.github
  "For details on the Github OAuth flow, refer to documentation here: 
   
   https://developer.github.com/v3/oauth/#web-application-flow. 
   
   This namespace includes the callback function and other utility functions 
   for creating github auth-tokens and attaching them to a darg user account"
  (:require [cheshire.core :refer [parse-string generate-string]]
            [clojure.tools.logging :as logging]
            [darg.model.github-user :as gh-user]
            [darg.model.github-token :as gh-token]
            [darg.api.responses :as responses]
            [environ.core :as env]
            [clj-http.client :as http]
            [slingshot.slingshot :refer [try+]]
            [tentacles.oauth :as t-oauth]))


(def client-id (env/env :darg-gh-client-id))
(def client-secret (env/env :darg-gh-client-secret))

; Callback

(defn parse-oauth-response
  [resp]
  (-> resp 
      :body
      (cheshire.core/parse-string true)))

;; Parses Github OAuth response and updates tables

(defn insert-and-link-github-user
  "This function is usually called from darg.oauth.github/callback. 
   
   It takes a Github OAuth response and darg userid, and updates the database 
   with the access-token and related Github user information. The Github user 
   and Github token are then linked to the provided userid."
  [userid body]
  (let [access-token (:access_token (parse-oauth-response body))]
    (gh-token/create-github-token! {:gh_token access-token})
    ;Link token to github user
    (let [github-user (assoc-in (gh-user/github-api-get-current-user access-token)
                                [:github_token_id]
                                (gh-token/fetch-github-token-id {:gh_token access-token}))
          github-user-id (:id github-user)]
      ;if a github user already exists, update it if not, create it
      (if (empty? (gh-user/fetch-github-user-by-id github-user-id))
        (gh-user/create-github-user! github-user)
        (gh-user/update-github-user! github-user-id github-user)))))

;; Callback Function. Called after the user completes their github login.

(defn callback
  "This function is called after a user is redirected back to darg from 
   https://github.com/login/oauth/authorize. 
   
   It takes the github request as an input, parses out the access code from 
   the params, and then makes a call to 
   https://github.com/login/oauth/access_token to generate an OAuth token."
  [request]
  (let [userid (-> request :user :id)
        options {:headers {"Accept" "application/json"}
                 :query-params {:code (-> request :params :code)
                                :client_id client-id
                                :client_secret client-secret}}
        {:keys [status body error] :as resp} (http/post "https://github.com/login/oauth/access_token" options)]
    (cond (= status 200)
          (try
            (insert-and-link-github-user userid body)
            (responses/ok "Github integration successful!")
            (catch Exception e
              (logging/errorf "Failed to save github user with exception: %s" e)
              (responses/server-error "Unable to complete Github integration")))
          :else
          {:status (status)
           :body (error)})))

;; Authorizations API, Used to create and manage OAuth authorization tokens for test cases

(defn create-auth-token
  [username password note]
  (let [options {:auth (str username ":" password)
                 :client_id client-id
                 :client_secret client-secret
                 :note note
                 :scopes "user:email"}]
    ; Simulate web-flow OAuth response
    {:body (-> (t-oauth/create-auth options)
               (select-keys [:scopes :token :id])
               (clojure.set/rename-keys {:token :access_token})
               (cheshire.core/generate-string))}))

(defn delete-auth-token!
  [username password id]
  (let [options {:auth (str username ":" password)}]
    (t-oauth/delete-auth id options)))

(defn list-auth-tokens
  [username password]
  (let [options {:auth (str username ":" password)}]
    (t-oauth/authorizations options)))

(defn list-auth-token-ids
  [username password]
  (let [options {:auth (str username ":" password)}]
    (map :id (t-oauth/authorizations options))))

(defn delete-all-auth-tokens
  [username password]
  (let [token-ids (list-auth-token-ids username password)]
    (for [x token-ids] 
      (delete-auth-token! username password x))))
