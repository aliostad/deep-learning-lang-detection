(ns shist.core
  (:import [java.security MessageDigest]
           [org.apache.commons.codec.binary Hex])
  (:use compojure.core
        hiccup.core
        shist.signatures
        [ring.middleware.params :only [wrap-params]]
        [ring.middleware.keyword-params :only [wrap-keyword-params]])
  (:require [appengine-magic.core :as ae]
            [appengine-magic.services.datastore :as ds]
            [appengine-magic.services.user :as user]
            [clj-json.core :as json]
            [clojure.contrib.string :as cstr]
            ))

(ds/defentity Command [ ^:key id, command, hostname, timestamp, tty, owner ])

(ds/defentity ApiKey [ ^:key key, owner ])

(defn md5
  "Generate a md5 checksum for the given string"
  [token]
  (let [hash-bytes
        (doto (java.security.MessageDigest/getInstance "MD5")
          (.reset)
          (.update (.getBytes token)))]
    (.toString
     (new java.math.BigInteger 1 (.digest hash-bytes)) ; Positive and the size of the number
              16))) ; Use base16 i.e. hex

(defn manage-keys-ui []
  (html
   [:div (str "Logged in as " (user/current-user))]
   [:div [:a {:href "/add_key"} "Add Key" ]]
   (for [x (ds/query :kind ApiKey :filter (= :owner (user/current-user))) ]
     [:div (str "Key: [" (:key x) "] [" (hmac "foobar" (:key x)) "]" )])
   ))


(defn parselong [s] (. Long parseLong s))
(def maxlong (. Long MAX_VALUE))

(defn unauthorized [request params]
  {:status 403
   :body (str "403 Unauthorized.\nString to sign: "
              (signable-string (:request-method request) (:uri request) params))})

(defroutes shist-app-routes
  (GET "/" req
       {:status 200
        :headers {"Content-Type" "text/plain"}
        :body "Hello, world! (updated 4)"})

  ;; Insert a new command into the archive
  (POST "/commands/" [:as request & params]
        (if (not (:signature-valid params))
          (unauthorized request params)
          (let [cmd (Command. (md5 (str (:host params) (:ts params)))
                              (:cmd params)
                              (:host params)
                              (parselong (:ts params))
                              (:tty params)
                              (:owner params))]
            (ds/save! cmd)
            "OK")))
  
  ;; List all commands
  (GET "/commands/" [:as request & params]
       (if (:signature-valid params)
         (let [mints (if (nil? (:mints params)) 0 (parselong (:mints params)))
               maxts (if (nil? (:maxts params)) maxlong (parselong (:maxts params)))
               cmdfilter (if (nil? (:filter params)) "" (:filter params))
               cmds (ds/query :kind Command :filter
                              [(>= :timestamp mints) (<= :timestamp maxts)])
               filtercmds (filter #(cstr/substring? cmdfilter (:command %)) cmds)
               ]
           (json/generate-string filtercmds))
         (unauthorized request params)))
  
  ;; List one command
  (GET "/command/:cmdid" [cmdid :as request & params]
       (if (:signature-valid params)
         (let [cmd (ds/retrieve Command cmdid)]
           (if (nil? cmd)
             {:status 404 :body (str cmdid " not found sir.")}
             {:status 200 :body (json/generate-string cmd)}))
         (unauthorized request params))) 

  ;; Non-REST interactive (key-management) UI
  
  (GET "/manage_keys*" []
       (if (user/user-logged-in?)
         (manage-keys-ui)
         {:status 302
          :headers {"Location" (user/login-url :destination "/manage_keys")}
          :body ""}))

  (GET "/add_key" []
       (let [key (ApiKey. (gen-key) (user/current-user))]
         (ds/save! key)
         {:status 302
          :headers {"Location" "/manage_keys"}
          :body ""}))

  (GET "/logout" []
       {:status 302
        :headers {"Location" (user/logout-url)}
        :body ""})

  (ANY "/test" [& params]
       (if (:signature-valid params)
         (str "verified? [" (:signature-valid params) "] -> AUTHORIZED")
         (str "UNAUTHORIZED.")))
        
  ;; Chrome always asks for a favicon. This suppresses error traces
  (GET "/favicon.ico" [] { :status 404 })

  (ANY "*" [] { :status 404 :body "404 NOT FOUND"})

  )

(defn wrap-check-signature [handler]
  (fn [request]
    (let [key "12345"
          their-signature (:signature (:params request))
          method (:request-method request)
          signable-params (dissoc (:params request) :signature)
          our-signature (sign key method (:uri request) signable-params)
          signature-valid (= their-signature our-signature)
          new-params (assoc (:params request) :signature-valid signature-valid)]
      (handler (assoc request :params new-params)))))

; Right now you need to make sure the header:
; Content-Type:application/x-www-form-urlencoded
; I think we might be able to omit that with something like
; (defn wrap-correct-content-type [handler]
;   (fn [request]
;      (handler (assoc request :content-type "application/json"))))

; Makes GET parameters work in dev-appserver
; https://github.com/gcv/appengine-magic/issues/28
(def shist-app-handler
  (-> #'shist-app-routes
      wrap-check-signature
      wrap-keyword-params
      wrap-params))

(ae/def-appengine-app shist-app #'shist-app-handler)
