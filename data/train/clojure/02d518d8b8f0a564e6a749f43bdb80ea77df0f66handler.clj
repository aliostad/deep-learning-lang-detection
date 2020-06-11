(ns square-sizer.handler
  (:require [compojure.core :refer [defroutes routes]]
            [ring.middleware.resource :refer [wrap-resource]]
            [ring.middleware.file-info :refer [wrap-file-info]]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [ring.middleware.logger :refer [wrap-with-logger]]
            [compojure.handler :as handler]
            [prometheus.core :as prometheus]
            [compojure.route :as route]
            [square-sizer.routes.home :refer [home-routes]]))

(defn init []
  (println "square-sizer is starting")
  (prometheus/init! "square_sizer"))

(defn destroy []
  (println "square-sizer is shutting down"))

(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (-> (routes home-routes app-routes)
      (handler/site)
      (wrap-json-body)
      (wrap-with-logger)
      (prometheus/instrument-handler)
      (wrap-json-response)))
