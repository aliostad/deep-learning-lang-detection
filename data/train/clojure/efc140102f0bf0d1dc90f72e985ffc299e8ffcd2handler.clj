(ns pdf-online.handler
  (:require [compojure.core :refer [defroutes routes]]
            [compojure.handler :as handler]
            [compojure.route :as route]
            [pdf-online.routes.home :refer [home-routes]]
            [pdf-online.routes.auth :refer [auth-routes]]
            [pdf-online.routes.upload :refer [upload-routes]]
            [pdf-online.routes.showpdf :refer [showpdf-routes]]
            [pdf-online.routes.user :refer [user-routes]]
            [pdf-online.routes.categoery-manage :refer 
             [categoery-manage-routes]]
            [pdf-online.util :refer [get-template-path]]
            [noir.util.middleware :as noir-middleware]
            [noir.session :as session]
            [selmer.parser :refer [render render-file]]
            [ring.middleware.anti-forgery :as anti-forgery]
            ;; For template error handle
            [selmer.middleware :refer [wrap-error-page]]
            [environ.core :refer [env]]
            [selmer.filters :refer [add-filter!]])
  (:import [java.io File]))

(defn generate-my-filter []
  (add-filter! :mytimee (fn [x] (first (clojure.string/split (str x) #"\s")))))

(defn init []
  (generate-my-filter) 
  (println "pdf-online is starting"))

(defn user-page [_]
  (session/get :user))

(defn destroy []
  (println "pdf-online is shutting down"))

(defroutes app-routes
  (route/resources "/")
  (route/not-found 
    (render-file (get-template-path "404.html") {})))

(def app
  (noir-middleware/app-handler 
    [categoery-manage-routes showpdf-routes upload-routes 
     user-routes auth-routes home-routes app-routes]
    :access-rules [user-page]
    ;::middleware [anti-forgery/wrap-anti-forgery]
    ))

(#(if (env :dev) (wrap-error-page %) %) app)


