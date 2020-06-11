(ns crypto-square-be.handler
  (:require [compojure.core :refer [defroutes routes]]
            [ring.middleware.resource :refer [wrap-resource]]
            [ring.middleware.file-info :refer [wrap-file-info]]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [ring.middleware.logger :refer [wrap-with-logger]]
            [compojure.handler :as handler]
            [prometheus.core :as prometheus]
            [compojure.route :as route]
            [crypto-square-be.models.middleware :refer [handle-correlation-ids]]
            [crypto-square-be.routes.home :refer [home-routes]]))

(defn init []
  (println "crypto-square-be is starting")
  (prometheus/init! "crypto_square-be"))

(defn destroy []
  (println "crypto-square-be is shutting down"))

(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (-> (routes home-routes app-routes)
      (handler/site)
      (prometheus/instrument-handler)
      (wrap-with-logger)
      (wrap-json-body)
      ; (handle-correlation-ids)
      (wrap-json-response)))
