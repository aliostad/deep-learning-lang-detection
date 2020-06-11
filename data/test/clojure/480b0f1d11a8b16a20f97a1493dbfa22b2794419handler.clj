(ns ku-expo.handler
  "Server routes handler"
  (:gen-class)
  (:use compojure.core
        ring.adapter.jetty
        environ.core)
  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [cemerick.friend :as friend]
            (cemerick.friend [workflows :as workflows]
                             [credentials :as creds])
            [ring.util.response :refer [response redirect resource-response]]
            [ring.middleware.params :as wrap-params]
            [ring.middleware.json :as middleware]
            [ring.middleware.cors :as cors]
            [ku-expo.auth :as auth]
            [ku-expo.teachers.manage :as teacher]
            [ku-expo.groups.manage :as group]
            [ku-expo.admins.manage :as admin]
            [ku-expo.utils.db :as db]
            [ku-expo.utils.nametags :refer [get-nametags]]))

(derive ::admin ::user)
(derive ::teacher ::user)
(derive ::group ::user)

;; TODO
;; 1  Consider refactoring of CRUD routes into four functions that take the
;;    object to change as a parameter
;; 2  Implement Group scoring
;; 3  Implement Admin control
(defroutes teacher-routes
  (GET "/" request (teacher/manage-teacher request))

  (GET "/profile" request (teacher/get-profile request))
  
  (GET "/schools" request (teacher/get-schools request))
  (PUT "/schools" request (teacher/create-school request))
  (POST "/schools" request (teacher/update-school request))
  (DELETE "/schools" request (teacher/delete-school request))

  (GET "/students" request (teacher/get-students request))
  (GET "/students-division" request (teacher/get-students-by-division request))
  (PUT "/students" request (teacher/create-student request))
  (POST "/students" request (teacher/update-student request))
  (DELETE "/students" request (teacher/delete-student request))

  (GET "/teams" request (teacher/get-teams request))
  (GET "/teams-table" request (teacher/get-teams-table request))
  (PUT "/teams" request (teacher/create-team request))
  (POST "/teams" request (teacher/update-team request))
  (DELETE "/teams" request (teacher/delete-team request))
  
  (GET "/logistics" request (teacher/get-logistics request))
  (PUT "/logistics" request (teacher/create-logistics request))
  (POST "/logistics" request (teacher/update-logistics request))
  (DELETE "/logistics" request (teacher/delete-logistics request)))

(defroutes group-routes
  (GET "/" request (group/manage-group request))
  (GET "/profile" request (group/get-profile request))
  (GET "/scores" request (group/get-scores request))
  (POST "/score" request (group/post-score request)))

(defroutes admin-routes
  (GET "/" request (admin/manage-admin request))
  (GET "/logistics-summary" request (admin/get-logistics-summary request))
  (GET "/teachers-summary" request (admin/get-teachers-summary request))
  (GET "/nametags/:division" [division] (get-nametags division))

  (GET "/scorers-summary" request (admin/get-scorers-summary request))
  (GET "/scores" [& params] (admin/get-score-report params))
  (POST "/register-scorer" [& params] (auth/register-scorer params))
  (POST "/update-scorer" [& params] (admin/update-scorer params))
  
  (GET "/schools-summary" request (admin/get-schools-summary request))
  (GET "/schools-teacher" request (admin/get-schools-by-teacher request))
  (PUT "/school" request (admin/create-school request))
  (POST "/school" request (admin/update-school request))
  (DELETE "/school" request (admin/delete-school request))

  (GET "/students-summary" request (admin/get-students-summary request))
  (GET "/students-teacher-division" request (admin/get-students-by-teacher-division request))
  (PUT "/student" request (admin/create-student request))
  (POST "/student" request (admin/update-student request))
  (DELETE "/student" request (admin/delete-student request))

  (GET "/teams-summary" request (admin/get-teams-summary request))
  (PUT "/team" request (admin/create-team request))
  (POST "/team" request (admin/update-team request))
  (DELETE "/team" request (admin/delete-team request)))

(defroutes api-routes
  (GET "/valid-teamname" request (admin/teamname-valid? request))
  (GET "/competitions" request (admin/get-competitions))
  (GET "/orgs" request (admin/get-orgs))
  (GET "/teachers" request (admin/get-teachers)))

(defroutes app-routes
  (route/resources "/")
  (context "/teacher" request 
           (friend/wrap-authorize teacher-routes #{::teacher}))
  (context "/group" request
           (friend/wrap-authorize group-routes #{::group}))
  (context "/admin" request
           (friend/wrap-authorize admin-routes #{::admin}))
  (context "/api" request
           (friend/wrap-authorize api-routes #{::user}))

  (GET "/" [] (resource-response "index.html" {:root "public/html"}))
  (GET "/login" [] (auth/login))
  (GET "/register" [] (auth/registration))
  (GET "/new-password" [] (auth/new-password))
  (GET "/valid-username" [& params] (auth/username-valid? params))
  (POST "/register" [& params] (auth/register-user params))
  (POST "/new-password" [& params] (auth/change-password params))
  (friend/logout (ANY "/logout" request (redirect "/"))))

(defn wrap-headers
  [handler]
  (fn [request]
    (let [response (handler request)]
      (assoc-in response [:headers "Cache-Control"] "no-cache, no-store, must-revalidate"))))

(def app
  (-> (handler/site
        (friend/authenticate app-routes
                             {:login-uri "/login"
                              :default-landing-uri "/"
                              :credential-fn #(creds/bcrypt-credential-fn db/get-user %)
                              :workflows [(workflows/interactive-form
                                            :login-failure-handler (fn [req] (auth/wrong-login)))]}))
      (wrap-headers)
      (cors/wrap-cors identity))) ; TODO improve security here i.e. limit to site URL

(defn -main [& args]
  (run-jetty #'app {:port 3000}))
