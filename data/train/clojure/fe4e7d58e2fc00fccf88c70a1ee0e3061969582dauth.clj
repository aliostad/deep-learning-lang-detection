(ns restful-clojure.auth
  (use korma.core)
  (require [restful-clojure.entities :as e]
           [restful-clojure.models.users :as users]
           [buddy.auth.backends.token :refer [token-backend]]
           [buddy.auth.accessrules :refer [success error]]
           [buddy.auth :refer [authenticated?]]
           [crypto.random :refer [base64]]))

(defn gen-session-id [] (base64 32))

(defn make-token!
  "Creates and stores an auth token in the database for the given user"
  [user-id]
  (let [token (gen-session-id)]
    (insert e/tokens
      (values {:id token :user_id user-id}))
    token))

(defn authenticate-token
  "Validates a token, returning the id of the associated user when valid, and nil otherwise"
  [req token]
  (let [sql (str "SELECT user_id "
                 "FROM auth_tokens "
                 "WHERE id = ? "
                 "AND created_at > current_timestamp - interval '6 hours'")]
    (some-> (exec-raw [sql [token]] :results)
            first
            :user_id
            users/find-by-id)))

(defn unauthorized-handler
  ([req]
    (unauthorized-handler req nil))
  ([reql msg]
    {:status 401
     :body {:status :error
            :message (or msg "User not authorized")}}))

(def auth-backend
  (token-backend {:authfn authenticate-token
                  :unauthorized-handler unauthorized-handler}))

(def permissions
  {"manage-lists" #{:restful-clojure.models.users/user}
   "manage-products" #{:restful-clojure.models.users/admin}
   "manage-users" #{:restful-clojure.models.users/admin}})

(defn authenticated-user [req]
  (if (authenticated? req)
    true
    (error "User must be authenticated")))

(defn user-can
  "Given a certain action, returns a handler that determines if the user can take that action"
  [action]
  (fn [req]
    (let [user-level (get-in req [:identity :level])
          required-levels (get permissions action #{})]
      (if (some #(isa? user-level %) required-levels)
        (success)
        (error "User of level" (name user-level) "cannot perform action" (name action))))))

(defn user-isa
  "Returns a handler to determine if user is of a specific level or any derived level"
  [level]
  (fn [req]
    (if (isa? (get-in req [:identity :level]) level)
      (success)
      (error "User is not a(n)" (name level)))))

(defn user-has-id
  "Return a handler that determines if the user has a given id.
  This is useful, for instance, if the user is the owner of the requested resource"
  [id]
  (fn [req]
    (if (get-in req [:identity :id])
      (success)
      (error "User does not have the given id"))))





























