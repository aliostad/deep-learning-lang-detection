(ns ku-expo.admins.manage
  (:require [ring.util.response :refer [response resource-response]]
            [ring.util.json-response :refer [json-response]]
            [cemerick.friend :as friend]
            [ku-expo.utils.db :as db]))

(defn manage-admin
  [req]
  (resource-response "admin.html" {:root "public/html"}))

(defn get-logistics-summary
  [req]
  (json-response
    (db/get-logistics-summary)))

(defn get-teachers-summary
  [req]
  (json-response
    (db/get-teachers-summary)))

(defn get-scorers-summary
  [req]
  (json-response
    (db/get-scorers-summary)))

(defn get-score-report
  [params]
  (let [{:keys [comp_id]} params]
    (json-response
      (db/get-score-report comp_id))))

(defn update-scorer
  [params]
  (let [{:keys [id org]} params]
    (json-response [(db/delete-user-to-org id)
                    (db/create-user-to-org id org)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; School Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-schools-summary
  [req]
  (json-response
    (db/get-schools-summary)))

(defn get-schools-by-teacher
  [req]
  (let [{:keys [teacher_id]} (:params req)]
    (json-response (db/get-schools teacher_id))))

(defn create-school
  [req]
  (let [{:keys [name teacher_id address]} (:params req)]
    (json-response (db/create-school teacher_id name address))))

(defn update-school
  [req]
  (let [{:keys [id teacher_id name address]} (:params req)]
    (json-response (db/update-school name address id teacher_id))))

(defn delete-school
  [req]
  (let [{:keys [id]} (:params req)]
    (json-response (db/delete-school id))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Student Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-students-summary
  [req]
  (json-response
    (db/get-students-summary)))

(defn get-students-by-teacher-division
  [req]
  (let [{:keys [teacher_id division]} (:params req)]
    (json-response (db/get-students-by-division teacher_id division))))

(defn create-student
  [req]
  (let [{:keys [name division teacher_id]} (:params req)]
    (json-response (db/create-student teacher_id name division))))

(defn update-student
  [req]
  (let [{:keys [id teacher_id name division]} (:params req)]
    (json-response [(db/delete-student-to-teams id)
                    (db/update-student name division id teacher_id)])))

(defn delete-student
  [req]
  (let [{:keys [id]} (:params req)]
    (json-response [(db/delete-student-to-teams id)
                    (db/delete-student id)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Team Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-teams-summary
  [req]
  (json-response
    (db/get-teams-summary)))

(defn create-team
  [req]
  (let [{:keys [name teacher_id division school]} (:params req)]
    (json-response (db/create-team teacher_id name division school))))

(defn update-team
  [req]
  (let [{:keys [id teacher_id name division school]} (:params req)
        students (get-in req [:params :students])
        competitions (get-in req [:params :competitions])]
    (json-response [(db/update-team name division school id teacher_id)
                    (db/update-students-to-team id students)
                    (db/update-competitions-to-team id competitions)])))

(defn delete-team
  [req]
  (let [{:keys [id]} (:params req)]
    (json-response [(db/delete-team id)
                    (db/delete-students-to-team id)
                    (db/delete-competitions-to-team id)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; API Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-competitions
  []
  (json-response (db/get-competitions)))

(defn get-orgs
  []
  (json-response (db/get-groups)))

(defn get-teachers
  []
  (json-response (db/get-teachers)))

(defn teamname-valid?
  "Checks that a given teamname is not already registered. If not, returns JSON
  with a value of true"
  [req]
  (let [teamname (get-in req [:params :name])]
    (json-response {:valid
                    (if (= (db/teamname-exists? teamname) false)
                      true
                      false)})))
