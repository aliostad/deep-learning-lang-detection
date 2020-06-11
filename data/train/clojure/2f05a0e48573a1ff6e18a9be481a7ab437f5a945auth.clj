(ns elastic-ring.auth
  (:require [buddy.auth.backends.httpbasic :refer [http-basic-backend]]
            [buddy.auth.accessrules :refer [success error]]
            [buddy.auth :refer [authenticated?]]
            [crypto.random :refer [base64]]))

;; Global var that stores valid users with their
;; respective passwords.
(def authdata {:admin "secret"
               :test  "secret"})


(defn unauthorized-handler [req msg]
  {:status 401
   :body   {:status  :error
            :message (or msg "User not authorized")}})

;; Define function that is responsible of authenticating requests.
;; In this case it receives a map with username and password and i
;; should return a value that can be considered a "user" instance
;; and should be a logical true.

(defn my-authfn
  [req {:keys [username password]}]
  (when-let [user-password (get authdata (keyword username))]
    (when (= password user-password)
      (keyword username))))

;; Create an instance of auth backend without explicit handler for
;; unauthorized request. (That leaves the responsability to default
;; backend implementation.

(def auth-backend (http-basic-backend {:realm  "Mini-RESTful Example"
                                       :authfn my-authfn}))

;; Map of actions to the set of user types authorized to perform that action
(def permissions
  {"manage-events" #{::user}})                              ;;#{:elastic_ring.models.events/event}})

;;; Below are the handlers that Buddy will use for various authorization
;;; requirements the authenticated-user function determines whether a session
;;; token has been resolved to a valid user session, and the other functions
;;; take some argument and _return_ a handler that determines whether the
;;; user is authorized for some particular scenario. See handler.clj for usage.

(defn authenticated-user [req]
  (if (authenticated? req)
    true
    (error "User must be authenticated")))

;; Assumes that a check for authorization has already been performed
(defn user-can
  "Given a particular action that the authenticated user desires to perform,
  return a handler determining if their user level is authorized to perform
  that action."
  [action]
  (fn [req]
    (let [user-level (get-in req [:identity :level])
          required-levels (get permissions action #{})]
      (if (some #(isa? user-level %) required-levels)
        (success)
        (error (str "User of level " user-level " is not authorized for action " action))))))

(defn user-isa
  "Return a handler that determines whenther the authenticated user is of a
  specific level OR any derived level."
  [level]
  (fn [req]
    (if (isa? (get-in req [:identity :level]) level)
      (success)
      (error (str "User is not a(n) " (name level))))))

(defn user-has-id
  "Return a handler that determines whether the authenticated user has a given ID.
  This is useful, for example, to determine if the user is the owner of the requested
  resource."
  [id]
  (fn [req]
    (if (= id (get-in req [:identity :id]))
      (success)
      (error (str "User does not have id given")))))
