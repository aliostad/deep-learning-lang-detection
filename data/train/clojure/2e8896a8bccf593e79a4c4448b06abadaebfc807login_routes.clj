(ns leugeme.routes.login-routes
  (:require [leugeme.layout :as layout]
            [ring.util.response :refer [response]]
            [ring.util.http-response :refer [found]]
            [compojure.core :refer [defroutes GET POST]]
            [leugeme.db.core :as db]))

(defn show-login []
  (layout/render "login.html"))

(defn login [id password {session :session}]
  (let [user (db/get-user {:userid id :password password})]
    (if (not-empty user) 
      (-> (found "/home")
          (assoc :session  (assoc session :user (first user))))
      (layout/render "login.html" {:invalid true}))))

(defn show-home [{session :session}]
  (let [all-jobs (db/get-all-idol-jobs {:userid (:id (:user session))})]
    (layout/render "user-feeds.html" {:jobs all-jobs :user (:user session)})))

(defn manage-my-jobs [{session :session}]
  (let [userid (:id (:user session))
    employee (db/get-employee {:id userid})
    jobs (db/get-available-jobs-by-employee {:employeeid userid})]
    (layout/render "my_job_listing.html" {:jobs (group-by :employer_name jobs) :employee (:user session)})))

(defroutes login-routes
  (GET "/login" [] (show-login))
  (GET "/home" [:as req] (show-home req))
  (GET "/jobs" [:as req] (manage-my-jobs req))
  (POST "/login" [id password :as req] (login id password req)))
