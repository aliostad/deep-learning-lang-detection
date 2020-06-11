(ns crypto-square.handler
  (:require [compojure.core :refer [defroutes routes]]
            [ring.middleware.resource :refer [wrap-resource]]
            [ring.middleware.file-info :refer [wrap-file-info]]
            [ring.middleware.logger :refer [wrap-with-logger]]
            [ring.middleware.json :refer [wrap-json-response]]
            [hiccup.middleware :refer [wrap-base-url]]
            [compojure.handler :as handler]
            [prometheus.core :as prometheus]
            [compojure.route :as route]
            [crypto-square.routes.home :refer [home-routes]]))

(defn init []
  (println "crypto-square is starting")
  (prometheus/init! "crypto_square"))

(defn destroy []
  (println "crypto-square is shutting down"))

(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (-> (routes home-routes app-routes)
      (handler/site)
      (wrap-json-response)
      (wrap-with-logger)
      (wrap-base-url)
      (prometheus/instrument-handler)
      ))
