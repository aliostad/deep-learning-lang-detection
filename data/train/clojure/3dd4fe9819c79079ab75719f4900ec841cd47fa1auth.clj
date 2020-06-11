(ns recursiftion.auth
  (:require [buddy.auth.backends.token :refer [token-backend]]
            [buddy.auth.accessrules :refer [success error]]
            [buddy.auth :refer [authenticated?]]
            [buddy.sign.jws :as jws]
            [recursiftion.models.users :as users]
            [clj-time.core :as time]
            [crypto.random :refer [base64]]
            [monger.core :as mg]
            [monger.collection :as mc]
            [monger.operators :refer :all]
            [monger.conversion :refer [from-db-object]]))


; (def mongo-uri "mongodb://mcferren:Broadway$19@candidate.36.mongolayer.com:11032,candidate.33.mongolayer.com:11038/app40992485")
(def mongo-uri "mongodb://mcferren:Broadway$19@candidate.55.mongolayer.com:10588,candidate.54.mongolayer.com:10796/mysyllabi-data-store?replicaSet=set-56526ee0a5b023028800061a")

(def mongoconnection (let [{:keys [conn db]} (mg/connect-via-uri mongo-uri)] db))

(def secret "mysupersecret")

(defn gen-session-id [] (base64 32))

(def insert-token-query "CREATE (t:Token {
	                           id         : {_token},
	                           user_id    : {_userid},
	                           created_at : {_created_at}
				        })
						RETURN t AS token;")

(defn insert-token [token userid]
  (let [_token token
        _userid userid
	    ucoll "tokens"]

  		(if (mc/any? mongoconnection ucoll {:_id _token})
            (mc/find-one-as-map mongoconnection ucoll {:_id _token})
            (mc/insert-and-return mongoconnection ucoll {
            								:_id 			_token
                                            :user_id 		_userid
                                            :created_at 	(System/currentTimeMillis)
                                            }))
    )
)

(defn make-token!
  "Creates an auth token in the database for the given user and puts it in the database"
  [userid]
  (let [claims {:user (keyword userid)
                :exp (str (time/plus (time/now) (time/seconds 3600)))}
        token (jws/sign claims secret {:alg :hs512})]

        (get-in (insert-token token userid) [:_id]) 
  ))


(defn delete-token
  "Deletes a token"
  [token]
  (let [_token token
	    coll "tokens"
        _reponseobject (mc/remove mongoconnection coll { :_id _token }) ]

    	(if _reponseobject
            (success "SUCCESSFULLY LOGGED OUT")
	    	(error "TROUBLE LOGGING OUT"))
	)
)



(def validate-token-query "Match (t:Token)
						   WHERE t.id = {_token} AND
						         t.created_at > {_measuretime}
						   RETURN t AS token;")

(defn authenticate-token
  "Validates a token, returning the id of the associated user when valid and nil otherwise"
  [req token]
  (let [_howstale? (- (System/currentTimeMillis) 21600000) 
        ucoll "tokens"
  	    _responseobject (mc/find-one-as-map mongoconnection ucoll {
  	    					:_id token
  	    					:created_at { "$gt" _howstale? }
  	    				})]

	  (if _responseobject
	    (get-in _responseobject [:user_id] )
	    (error "NO TOKEN AUTHORIZATION")))
)

(defn unauthorized-handler [req msg]
  {:status 401
   :body {:status :error
          :message (or msg "User not authorized")}})

;; Looks for an "Authorization" header with a value of "Token XXX"
;; where "XXX" is some valid token.
(def auth-backend (token-backend {:authfn authenticate-token
                                  :unauthorized-handler unauthorized-handler}))


;; Map of actions to the set of user types authorized to perform that action
(def permissions
  {"manage-nodes"    "user"
   "manage-lists"    "user"
   "manage-products" "admin"
   "manage-users"    "admin"})


(defn authenticated-user [req]
        (println "$$$ JAMES BROWN GIGS" req)
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
    (let [user-id (get-in req [:identity])
    	    user-level (get-in (users/find-user-by-id user-id) [:level])
          required-levels (get permissions action #{})]

          (if (= user-level required-levels)
          (success)
          (error (str "User of level " user-level " is not authorized for action " action))))))

; (defn user-isa
;   "Return a handler that determines whenther the authenticated user is of a
;   specific level OR any derived level."
;   [level]
;   (fn [req]
;     (if (isa? (get-in req [:identity :level]) level)
;       (success)
;       (error (str "User is not a(n) " (name level))))))

(defn user-has-id
  "Return a handler that determines whether the authenticated user has a given ID.
  This is useful, for example, to determine if the user is the owner of the requested
  resource."
  [id]
  (fn [req]
    (if (= (str id) (str (get-in req [:identity])))
      (success)
      (error (str "User does not have id given")))))

