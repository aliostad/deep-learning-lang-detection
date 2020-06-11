(ns malbum.handler
  (:require [compojure.core :refer [defroutes routes]]
            [ring.middleware.resource :refer [wrap-resource]]
            [ring.middleware.file-info :refer [wrap-file-info]]
            [hiccup.middleware :refer [wrap-base-url]]
            [compojure.handler :as handler]
            [compojure.route :as route]
            [malbum.routes.home :refer [home-routes]]
            [malbum.routes.auth :refer [auth-routes]]
            [malbum.routes.upload :refer [upload-routes]]
            [malbum.routes.album :refer [album-routes]]
            [malbum.routes.photoview :refer [photoview-routes]]
            [malbum.routes.manage :refer [manage-routes]]
            [malbum.routes.api :refer [api-routes]]
            [noir.session :as session]
            [noir.util.middleware :as noir-middleware]
            ))

(defn init []
  (println "malbum is starting"))

(defn destroy []
  (println "malbum is shutting down"))

(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))

(defn user-page [_]
  (session/get :user))

(def app  (noir-middleware/app-handler
            [auth-routes   ;; user-login routes
             home-routes   ;; home-page rendering routes
             upload-routes ;; file-upload routes
             album-routes ;; user album routes
             photoview-routes ;; single image display route
             api-routes
             manage-routes
             app-routes]
            :access-rules [user-page])) ;; lib-noir checks to see if user is logged in

;(def app
;  (-> (routes auth-routes home-routes app-routes)
;      (handler/site)
;      (wrap-base-url)))
