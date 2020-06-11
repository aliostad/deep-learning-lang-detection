(ns compojure-swag.handler
  (:require 
    [swag.core :refer (swagger-routes GET- POST- PUT- DELETE- defroutes- errors set-base)]
    [swag.model :refer (defmodel wrap-swag)]
    [ring.middleware [multipart-params :as mp] ]
    [compojure.handler :as handler :refer (site)]
    [ring.middleware.format :refer (wrap-restful-format)]
    [compojure.core :refer (defroutes routes)] 
    [ring.adapter.jetty :refer (run-jetty)] 
    [compojure.route :as route]
    [metrics.ring.expose :refer [expose-metrics-as-json]]
    [metrics.ring.instrument :refer [instrument]]))

(set-base "http://localhost:3000")

(defroutes- messages {:path "/messages" :description "Messages managment"}
  (GET- "/messages/:name" [^:string name] {:nickname "getMessages" :summary "Get message"}
      {:body {:message (str "Hello World" " " name)}})
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (-> (routes (swagger-routes "0.0.1") messages)
      (handler/api)
      (wrap-swag)
      (wrap-restful-format :formats [:json-kw :edn])))

(def app (expose-metrics-as-json (instrument app) "/stats/"))

(defn -main [& args]
  (run-jetty app {:port 3000 :join? false }))