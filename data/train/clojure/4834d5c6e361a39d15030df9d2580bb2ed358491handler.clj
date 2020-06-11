(ns budget.handler
  (:use compojure.core
        budget.manage-redis
        budget.renderer
        [ring.middleware.cookies        :only [wrap-cookies]]
        [ring.middleware.params         :only [wrap-params]]
        [ring.middleware.keyword-params :only [wrap-keyword-params]]
	(sandbar stateful-session))
  (:require [compojure.handler :as handler]
            [compojure.route :as route]))

(defroutes app-routes
  (GET "/" {{month :month} :params cookies :cookies}
    (println "got:" month cookies) 
    (if (session-get :username)
       {:body    (render-main (session-get :username) month)
        :cookies (assoc-in cookies ["ring-session" :max-age] (* 3600 24 365))}
       (render-login)))
  (POST "/signup" {params :params}
    (let [[message success] (try-signup params)]
      (render-message message 2)))
  (POST "/login" {params :params cookies :cookies}
    (let [[message username]
          (try-login params)]
       (if username
         (session-put! :username username))
         {:body (render-message message 2)}))
  (GET "/logout" []
     (session-delete-key! :username)
     (render-message "logged out" 3))
  (POST "/update" {params :params}
    (let [error (process-transaction params)]
      (if error (render-message error 5)
	    (render-message (random-affirmation) 1))))
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (-> (handler/site app-routes)
     wrap-stateful-session
     wrap-cookies
     wrap-keyword-params
     wrap-params))