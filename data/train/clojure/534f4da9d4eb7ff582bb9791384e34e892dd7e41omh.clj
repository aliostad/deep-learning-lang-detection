(ns experiment.models.omh
  (:use
   experiment.infra.models
   experiment.infra.api
   experiment.models.samples)
  (:require
   [clj-time.core :as time]
   [clojure.string :as str]
   [experiment.models.user :as user]
   [experiment.infra.auth :as auth]
   [experiment.libs.datetime :as dt]))


;; SERVER
;; ----------------------------

;;
;; ## Authentication
;;


;; Expiration
(def server_timeout 30) ;; in days
(defn expiration []
  (dt/as-iso-8601 (time/plus (dt/now) (time/days server_timeout))))

;; Authentication tokens
(defonce tokens (atom {}))

(defn find-token [spec]
  (first (first (filter (fn [[k v]] (= v spec)) @tokens))))
  
(defn generate-token
  "Given the requestor and username, generate a unique token"
  [req username]
  (let [table @tokens
        spec [req username]]
    (if-let [token (find-token spec)]
      token
      (let [token (str (java.util.UUID/randomUUID))]
        (swap! tokens assoc token [req username])
        token))))

(defn token->user [token]
  (when-let [username (second (@tokens token))]
    (fetch-model :user {:username (second (@tokens token))})))

;; Authenticate
(defn authenticate-user [requester userref password]
  (let [user (auth/lookup-user-for-auth userref)]
    (cond (not user)
          (with-meta {:error_msg "User or password not recognized"}
            {:code 401})
          (auth/valid-password? user password)
          {:auth_token (generate-token requester (:username user))
           :expires (expiration)})))

(defn authenticated-user [token]
  (token->user token))

;; Authenticate API Request
(defapi omh-authenticate [:get "/omh/v1.0/authenticate"]
  {:keys [username password requester] :as options}
  (authenticate-user requester username password))

(defapi omh-auth-get [:get "/omh/v1.0/authenticate"]
  {:keys [username password requester] :as options}
  (authenticate-user requester username password))

;;
;; ## Server STATUS
;;

(defapi omh-status [:get "/omh/v1.0/status"]
  {:as options}
  {:status "alive"
   :foo "bar"})

;;
;; ## Server READ
;;

(defmacro with-user [[sym token] & body]
  `(if-let [~sym (authenticated-user ~token)]
     ~@body
     (with-meta {:errors ["Invalid or expired auth_token"]}
      {:code 401})))

(defn read-response [user]
  {:time_start (dt/as-iso-8601 (time/minus (dt/now) (time/days 30)))
   :time_end (dt/as-iso-8601 (dt/now))
   :time_next nil 
   :time_final nil
   :local_time_valid true
   :column_names ["time" "value" "location"]
   :column_definitions 
   :pe_username (:username user)
   {:time {:payload_id "urn:omh:measure:time:iso8601"}
    :temp {:payload_id "urn:omh:measure:temperature"
           :units "farenheight"}}
   :data
   [[(time/minus (dt/now) (time/days 1)) 86.8 {:lat 38.8 :lon -77.0}]
    [(dt/now) 87.4 {:lat 38.8 :lon -77.0}]]})

(defapi omh-read [:get "/omh/v1.0/read"]
  {:keys [auth_token source_name
          time_start time_end column_names]}
  (with-user [user auth_token]
    (read-response user)))

;;
;; # LINT
;; --------------------------

(defapi omh-lint "/omh/v1.0/lint" {:as options}
  {:success false
   :messages ["Lint Not Supported"]})

;;
;; # CATALOG
;; --------------------------

(defn parse-source [source]
  (str/split source))

(defn source-name [instrument]
  (str (:variable instrument) ":" (:src instrument)))

(defn catalog-entry [tracker]
  (let [instrument (resolve-dbref (:instrument tracker))]
    [(source-name instrument)
     {:source_class {:name (:src instrument) :columns []}}]))

(defn catalog
  ([user] 
     (into {} (map catalog-entry (user/trackers user))))
  ([user source]
     (let [[var src] (parse-source source)]
       (map catalog-entry
            (filter (fn [tracker]
                      (let [inst (resolve-dbref (:instrument tracker))]
                        (and (= (:variable inst) var)
                             (= (:src inst) src))))
                    (user/trackers user))))))
    
(defapi omh-catalog [:get "/omh/v1.0/catalog"]
  {:keys [source_name auth_token]}
  (with-user [user auth_token]
    (vec (if source_name
           (catalog user source_name)
           (catalog user)))))
