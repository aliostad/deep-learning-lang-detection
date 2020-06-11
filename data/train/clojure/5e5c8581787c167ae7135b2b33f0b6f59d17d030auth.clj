(ns gapi.auth
	(:import
		[java.net URLEncoder])
	(:require
    	[clojure.data.json :as json]
    	[clj-http.client :as http]
		[clojure.string :as string]))

(declare generate-state encode)
(def ^{:private true} auth_url "https://accounts.google.com/o/oauth2/auth")
(def ^{:private true} token_url "https://accounts.google.com/o/oauth2/token")

(defn create-auth
	"Return a state map used to manage the authentication session. 
	Can accept either an API key for simple API access or a client
	ID, client secret and redirect URL for OAuth2. See
	https://developers.google.com/console to generate keys."
	([api_key]
    	(atom {:api_key api_key}))
	([client_id, client_secret, redirect_url]
    	(atom {:client_id client_id, :client_secret client_secret, :redirect_url redirect_url})))

(defmulti call-params
	"Update the call parameters with the authentication details"
	(fn [state params] (if (nil? state)
						:none
						(if (string? (@state :token))
							:oauth :simple))))

(defmethod call-params :oauth [state params]
	;; TODO: check for expired auth token and call refresh if possible
	(let [headers (if (params :headers) (params :headers) {})]
		(assoc params :headers (assoc headers "Authorization" (str "Bearer " (@state :token))))))

(defmethod call-params :simple [state, params]
	(assoc params :query-params (assoc (params :query-params) "key" (@state :api_key))))

(defmethod call-params :default [state, params]
	params)

(defn is-valid
	"Returns true if the authentication is valid, and in date."
	[state]
	(if (@state :token)
		(< (System/currentTimeMillis) (@state :expires))
		false))

(defn generate-auth-url
	"Retrieve a URL suitable for redirecting the user to for auth permissions. 
	Scopes should be supplied as a vector of required scopes. An optional third
	param is a map with access_type and approval_prompt keys."
	([state scopes] (generate-auth-url state scopes {:access_type "offline" :approval_prompt "auto"}))
	([state scopes opts]
	(let [
		oauth2-state  (generate-state)
		params [
			(encode "client_id" (@state :client_id))
			(encode "redirect_uri" (@state :redirect_url))
			(encode "scope" (string/join " " scopes))
			(encode "state" oauth2-state)
			"response_type=code"
			(encode "access_type" (opts :access_type))
			(encode "approval_prompt" (opts :approval_prompt))
		]]
	(swap! state assoc :state oauth2-state)
	(str auth_url "?" (string/join "&" params)))))

(defn exchange-token
	"Handle the user response from the oauth flow and retrieve a valid
	auth token. Returns true on success, false on failure."
	[state, code, checkstate]
	(if (= (@state :state) checkstate)
		(let [params [
				(encode "code" code)
				(encode "client_id" (@state :client_id))
				(encode "redirect_uri" (@state :redirect_url))
				(encode "client_secret" (@state :client_secret))
				"grant_type=authorization_code"
			]
			http_resp (http/post token_url {:body (string/join "&" params)
					:content-type "application/x-www-form-urlencoded"})
			resp (json/read-json (http_resp :body))]
			(swap! state assoc :token (resp :access_token)
				:refresh (resp :refresh_token)
				:expires (+ (System/currentTimeMillis) (* (resp :expires_in) 1000)))
			true
			)
		false))

(defn refresh-token
	"Generate a new authentication token using the refresh token"
	[state]
	(if (@state :refresh)
		(let [params [
				(encode "client_id" (@state :client_id))
				(encode "client_secret" (@state :client_secret))
				(encode "refresh_token" (@state :refresh))
				"grant_type=refresh_token"
			]
			http_resp (http/post token_url {:body (string/join "&" params)
					:content-type "application/x-www-form-urlencoded"})
			resp (json/read-json (http_resp :body))]
			(swap! state assoc :token (resp :access_token)
				:expires (+ (System/currentTimeMillis) (* (resp :expires_in) 1000)))
			true)
		false))

(defn- encode
	"Combine the key and value with an = and URL encode each part"
	[key val]
	(str (URLEncoder/encode (str key) "UTF-8") "=" (URLEncoder/encode (str val) "UTF-8")))

(defn- generate-state
	"Generate a random string for the state"
	[]
	(let [buff (make-array Byte/TYPE 10)]
    (-> (java.security.SecureRandom.)
			(.nextBytes buff))
   	(-> (org.apache.commons.codec.binary.Base64.)
     	(.encode buff)
     	(String.))))