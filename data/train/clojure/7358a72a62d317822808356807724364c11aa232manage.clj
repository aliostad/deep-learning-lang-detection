(ns ku-expo.teachers.manage
  (:require [ring.util.response :refer [response resource-response]]
            [ring.util.json-response :refer [json-response]]
            [cemerick.friend :as friend]
            [ku-expo.utils.db :as db]))

;; TODO
;; 1  Exchange DO notation in favor of result of functions in JSON response
;;    a. ensures execution
;;    b. useful debuggin information

(defn manage-teacher
  [req]
  (resource-response "teacher.html" {:root "public/html"}))

(defn get-profile
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response 
      (db/get-teacher-profile user-id))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; School Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-schools
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response 
      (db/get-schools user-id))))

(defn create-school
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [name address]} (:params req)]
    (do 
      (db/create-school user-id name address)
      (json-response {:result "success"}))))

(defn update-school
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id name address]} (:params req)]
    (do
      (db/update-school name address id user-id)
      (json-response {:result "success"}))))

(defn delete-school
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id]} (:params req)]
    (do
      (db/delete-school id user-id)
      (json-response {:result "success"}))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Student Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-students
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response (db/get-students user-id))))

(defn get-students-by-division
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [division]} (:params req)]
    (json-response (db/get-students-by-division user-id division))))

(defn create-student
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [name division]} (:params req)]
    (do 
      (db/create-student user-id name division)
      (json-response {:result "success"}))))

(defn update-student
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id name division]} (:params req)]
    (json-response {:result [(db/delete-student-to-teams id)
                             (db/update-student name division id user-id)]})))

(defn delete-student
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id]} (:params req)]
    (json-response {:result [(db/delete-student-to-teams id)
                             (db/delete-student id user-id)]})))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Team Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-teams
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response (db/get-teams user-id))))

(defn get-teams-table
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response (db/get-teams-table user-id))))

(defn create-team
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [name division school]} (:params req)]
    (do 
      (db/create-team user-id name division school)
      (json-response {:result "success"}))))

(defn update-team
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id name division school]} (:params req)
        students (get-in req [:params :students])
        competitions (get-in req [:params :competitions])]
    (json-response {:result [(db/update-team name division school id user-id)
                             (db/update-students-to-team id students)
                             (db/update-competitions-to-team id competitions)]})))

(defn delete-team
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id]} (:params req)]
    (json-response {:result [(db/delete-team id user-id)
                             (db/delete-students-to-team id)
                             (db/delete-competitions-to-team id)]})))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Logistics Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-logistics
  "Get list of registered Logistics. Transform boolean values to human readable
  alternatives"
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        results (db/get-logistics user-id)]
    (json-response 
      (for [result results]
        (cond-> result
          (= false (:attend_opening result)) (assoc :attend_opening "No")
          (= true (:attend_opening result)) (assoc :attend_opening "Yes")
          (= false (:leave_early result)) (assoc :leave_early "No")
          (= true (:leave_early result)) (assoc :leave_early "Yes"))))))

(defn create-logistics
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [num_cars num_buses
                attend_opening leave_early leave_time
                num_lunches
                xsmall_ts small_ts medium_ts large_ts xlarge_ts]} (:params req)]
    (do 
      (db/create-logistics user-id
                           num_cars num_buses
                           attend_opening leave_early leave_time
                           num_lunches
                           xsmall_ts small_ts medium_ts large_ts xlarge_ts)
      (json-response {:result "success"}))))

(defn update-logistics
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id 
                num_cars num_buses
                attend_opening leave_early leave_time
                num_lunches
                xsmall_ts small_ts medium_ts large_ts xlarge_ts]} (:params req)]
    (do
      (db/update-logistics num_cars num_buses
                           attend_opening leave_early leave_time
                           num_lunches
                           xsmall_ts small_ts medium_ts large_ts xlarge_ts
                           id user-id)
      (json-response {:result "success"}))))

(defn delete-logistics
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id]} (:params req)]
    (do
      (db/delete-logistics id user-id)
      (json-response {:result "success"}))))
