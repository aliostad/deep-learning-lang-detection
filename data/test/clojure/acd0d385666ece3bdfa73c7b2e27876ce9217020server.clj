(ns code-dispatch-web.server
  (:require [compojure.core :refer [defroutes GET POST ANY]]
            [compojure
             [route :as route]]
            [ring.util.response :as response]
           [code-dispatch-web.views.common :as common]
           [code-dispatch-web.views.dispatch :as dispatch]
           [compojure.handler :as handler]
           [ring.middleware.params :as ring-params]
           ;; [ring.middleware.params.wrap-params :as wrap-params]
           )
)


(defroutes my-routes
           (GET "/" req (dispatch/do-show))
           (POST "/" {params :params} (dispatch/do-format params))
          ;; (POST "/" {params :params} (println "hello: " (params :code)))
           (route/resources "/")
           (route/not-found "Not Found"))


(def handler 
  (-> my-routes handler/api))
