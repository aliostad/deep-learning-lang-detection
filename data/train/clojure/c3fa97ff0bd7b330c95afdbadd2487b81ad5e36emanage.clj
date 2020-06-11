(ns ku-expo.groups.manage
  (:require [ring.util.response :refer [resource-response]]
            [ring.util.json-response :refer [json-response]]
            [cemerick.friend :as friend]
            [ku-expo.utils.db :as db]))

(defn manage-group
  [req]
  (resource-response "group.html" {:root "public/html"}))

(defn get-profile
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response 
      (db/get-group-profile user-id))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Scoring Operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn get-scores
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])]
    (json-response
      (db/get-scores-by-group user-id))))

(defn post-score
  [req]
  (let [session (friend/identity req)
        user-id (get-in session [:authentications (session :current) :id])
        {:keys [id score]} (:params req)]
    (do
      (db/update-competition-to-team-score id score)
      (json-response {:result "success"}))))  

