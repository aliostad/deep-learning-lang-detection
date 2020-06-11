(ns living-colors.core
  (:gen-class)
  (:require [ring.adapter.jetty :refer :all]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [prometheus.core    :as prometheus]))

(defn health-check [request]
  {:status 200
   :headers {"Content-Type" "text/plain"}
   :body  "OK"})

(defroutes app
  (GET "/metrics" request (prometheus/metrics request))
  (GET "/" [] (prometheus/instrument-handler health-check))
  (route/not-found "<h1>Page not found</h1>"))

(defn -main [& args]
  (prometheus/init! "Living Colors")
  (run-jetty  app {:port 3000}))
