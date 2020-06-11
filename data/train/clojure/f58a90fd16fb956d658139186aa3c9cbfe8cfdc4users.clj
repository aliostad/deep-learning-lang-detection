(ns galliforme.endpoint.users
  (:require [clojure.data.json :as json]
            [clojure.spec :as spec]
            [compojure.core :refer :all]
            [crypto.password.scrypt :as scrypt]
            [hugsql.core :as hugsql]))

(hugsql/def-db-fns "galliforme/endpoint/users.sql")

(def users-ns (str *ns*))

;; This is bad, namespaces should be sent on the wire with the keys... FIXME
;; look into transit?
(defn parse-json-payload-to-namespaced-keys-map [req]
  (json/read-str (slurp (:body req))
                 :key-fn #(keyword users-ns %)))

(defn parse-json-payload [req]
  (json/read-str (slurp (:body req))
                 :key-fn keyword))

(defn handle-register-user [db req]
  (let [user (parse-json-payload req)
        db-password (scrypt/encrypt (:password user))
        db-user (assoc user :password db-password)]
    (println user)
    (register-user db db-user)))

(defn users-endpoint [{{db :spec} :db}]
  (routes
   (context "/users" []
     (GET "/" []
       (all-users db))
     (POST "/" [] #(handle-register-user db %)))
   (context "/auth" []
     (POST "/" req
       (let [body (parse-json-payload-to-namespaced-keys-map req)
             plop (println {:email (::email body)})
             db-user (user-by-email db {:email (::email body)})]
         (if-not db-user
           {:status 400 :body "user does not exist..."}
           (if-not (scrypt/check (::password body) (:password db-user))
             {:status 400 :body "wrong password!"}
             "welcome!")))))))

;; specs to validate input before insertint into db
;; theses are not usable as is, because hugsql does not handle namespaced
;; keywords

(spec/def ::first-name string?)
(spec/def ::last-name string?)
(spec/def ::email string?)
(spec/def ::password string?)

(spec/def ::user (spec/keys :req [::first-name ::last-name ::email ::password]))

(spec/fdef register-user
           :args (spec/cat :db-component ::spec/any
                           :user ::user))


;;(spec/instrument #'register-user)

(spec/def ::login (spec/keys :req [::email ::password]))

(spec/fdef user-by-email
           :args (spec/cat :db-component ::spec/any
                           :login ::login))

;;(spec/instrument #'user-by-email)
