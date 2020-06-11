(ns clj-web-boot.security.auth
  (:require [crypto.random :refer [base64]]
            [buddy.auth.backends.token :refer [token-backend]]
            [buddy.auth.accessrules :refer [success error]]
            [buddy.auth :refer [authenticated?]]
            [clj-web-boot.models.tokens :as tokens]
            [clj-web-boot.models.accounts :as accounts]))

(defn- authenticate-token
  "Validates a token, returning the id of the associated user when valid and nil otherwise."
  [req token]
  (let [account-id (tokens/find-account-id-by-token-id token 24)]
    (accounts/find-by-id account-id)))

(defn unauthorized-handler [req msg]
  {:status 401
   :body {:status :error
          :message (or msg "User not authorized")}})

;; Looks for an "Authorization" header with a value of "Token XXX"
;; where "XXX" is some valid token.
(def auth-backend
  (token-backend {:authfn authenticate-token
                  :unauthorized-handler unauthorized-handler}))

;; Map of actions to the set of account types authorized to perform that actions
(def permissions
  {"manage-profiles" #{::accounts/user}
   "manage-accounts" #{::accounts/admin}})

;; Below are handlers that Buddy will use for various authorization requirements.

(defn authenticated-user
  "Determines whether a session token has been resolved to a valid user session."
  [req]
  (if (authenticated? req)
    true
    (error "User must be authenticated")))

;; Assumes that a check for authorization has already been performed
(defn user-can
  "Given a particular action that the authenticated user desires to perform,
  return a handler determining if their user level is authorized to perform that action."
  [action]
  (fn [req]
    (let [user-level (get-in req [:identity :level])
          required-levels (get permissions action #{})]
      (if (some #(isa? user-level %) required-levels)
        (success)
        (error (str "User of level " (str user-level) " is not authorized for action " (name action)))))))

(defn user-isa
  "Returns a handler that determines whether the authenticated user
  is of a specific level or any derived level."
  [level]
  (fn [req]
    (if (isa? (get-in req [:identity :level]) level)
      (success)
      (error (str "User is not a(n) " (name level))))))

(defn user-has-id
  "Returns a handler that determines whether the authenticated user has a given ID.
  This is useful, for example, to determine if the user is the owner of the requested resource."
  [id]
  (fn [req]
    (if (= id (get-in req [:identity :id]))
      (success)
      (error (str "User does not have given id")))))
