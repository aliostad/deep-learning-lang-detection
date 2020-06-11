(ns experiment.models.user
  (:use
   noir.core
   experiment.infra.models)
  (:require
   [experiment.libs.datetime :as dt]
   [experiment.infra.session :as session]
   [experiment.infra.middleware :as mid]
   [experiment.infra.auth :as auth]))

;; USER
;; ---------------------------------
;;  :username (client, :public)
;;  :name "Full Name" (client, :owns|:friend)
;;  :email "Account email" (client, :owns)
;;  :password (server)
;;  :avatar <image> (client, :public)
;; 
;;  Demographics (:demog, client, :owns)
;;    :age
;;    :gender
;;    :country
;;    :state
;;    :weight
;;    :height
;;
;;  Profile (:profile, client, :owns)
;;    :bio
;;    :units
;;    :default_privacy
;;    :cell
;;
;;  Permissions (:perm, server)
;;    ...
;;
;;  :trackers []
;;  :trials []
;;  :past_trials []

;; ## Convenience methods

(defmethod valid-model? :user [user]
  (and (:username user)
       (:email user)
       (:type user)))

(defn create-user! [username password email name]
  (create-model!
   (auth/set-user-password
    {:type :user
     :username username
     :uname (.toLowerCase username)
     :name name
     :email email
     :startdate (dt/now)
     :services {}
     :trackers {}
     :trials {}
     :preferences {}
     :journals {}}
    password)))
    
(defn get-user
  "Model for reference"
  [reference]
  (cond (string? reference)
	(or (fetch-model :user {:uname (.toLowerCase reference)})
        (fetch-model :user {:email reference}))
	true
	(resolve-dbref reference)))

(mid/set-user-fetcher
 (fn [& {:keys [id username email]}]
   (cond id (fetch-model :user {:_id id})
         username (get-user username)
         email (get-user email))))

(defn get-user-dbref [reference]
  (cond (and (map? reference) (= (name (:type reference)) "user"))
	(as-dbref reference)
	true
	(as-dbref (get-user reference))))

(defmethod public-keys :user [user]
  (if (= (:_id user) (:_id (session/current-user)))
    (keys (apply dissoc user
                 [:updates :permissions :password :salt :dataid :state]))
    [:username :bio :name]))

;; ## Trials

(defn attach-user [user submodel]
  (assoc submodel :user (as-dbref user)))

(defn trials [user]
  (map (partial attach-user user) (vals (:trials user))))

(defn get-trial [user id]
  (attach-user user ((:trials user) (keyword id))))

(defn has-trials? [user]
  (if (not (empty? (:trials user))) true false))

;; ## Trackers

(defn add-tracker! [user instrument schedule]
  (let [inst (if (model? instrument)
               instrument
               (fetch-model :instrument {:src instrument}))
        submod {:type "tracker"
                :state "active"
                :user (as-dbref user)
                :instrument (as-dbref inst)
                :schedule schedule}]
    (create-submodel! user "trackers" submod)))

(defn trackers [user]
  (vals (:trackers user)))

(defn has-trackers? [user]
  (if (not (empty? (trackers user))) true false))

(defn remove-tracker! [user tracker]
  (delete-submodel! user [:trackers (:id tracker)]))

;; ## Services

(defn set-service [user service record]
  (assert (model? user))
  (modify-model! user {:$set {:services {service record}}
                       :$inc {:updates 1}}))

(defn set-service-param [user service param value]
  (assert (model? user))
  (modify-model! user {:$set {(str "services." (name param)) value}
                       :$inc {:updates 1}}))

(defn get-service-param [user service entry]
  (assert (model? user))
  (get-in user [:services service entry]))


;; ## User Properties

(defn get-pref
  ([user property]
     (get-in user [:preferences property]))
  ([property]
     (get-pref (session/current-user) property)))
  
(defn set-pref!
  ([user property value]
     (modify-model! user {:$set {(str "preferences." (name property)) value}
                          :$inc {:updates 1}}))
  ([property value]
     (set-pref! (session/current-user) property value)))

;; ## User Permissions

(defn set-permission!
  ([user perm]
     (modify-model! user {:$addToSet {:permissions perm}
                          :$inc {:updates 1}}))
  ([perm]
     (set-permission! (session/current-user) perm)))

(defn has-permission? [perm]
  ((set (:permissions (session/current-user))) (name perm)))

(defn is-admin? []
  (has-permission? "admin"))
  
(defn site-admins []
  (list (get-user "eslick")))

(defn site-admin-refs []
  (map as-dbref (site-admins)))
  
;; Generate Test Users
;; ------------------------

(defn gen-first [] (rand-nth ["Joe" "Larry" "Curly" "Mo"]))
(defn gen-last [] (rand-nth ["Smith" "Carvey" "Kolluri:" "Kramlich"]))
(defn gen-gender [] (rand-nth ["M" "F"]))
(defn gen-weight [] (+ 100 (rand-int 150)))
(defn gen-yob [] (+ 1940 (rand-int 54)))

(defn gen-user []
  {:type :user
   :name (str (gen-first) " " (gen-last))
   :bio "I have no bio, I am a computer generated character"
   :gender (gen-gender)
   :country "USA"
   :state "CA"
   :weight (gen-weight)
   :yob (gen-yob)})

(defn gen-users [count]
  (dotimes [i count]
    (create-model! (gen-user))))


