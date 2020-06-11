(ns helloworld.web
  (:require [cheshire.core :as json]
            [compojure
                [core :refer [defroutes GET]]
                [route :as route]]
            [environ.core :refer [env]]
            [metrics.ring
             [expose :refer [expose-metrics-as-json]]
             [instrument :refer [instrument]]]
            [radix
             [error :refer [error-response wrap-error-handling]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [reload :refer [wrap-reload]]
             [setup :as setup]]
            [ring.middleware
             [format-params :refer [wrap-json-kw-params]]
             [json :refer [wrap-json-response]]
             [params :refer [wrap-params]]]))

(def version
  (setup/version "helloworld"))


(defn healthcheck
  []
  (let [body {:name "helloworld"
              :version version
              :success true
              :dependencies []}]
    {:headers {"content-type" "application/json"}
     :status (if (:success body) 200 500)
     :body body}))

(defn- hello
  [{:keys [query-params]}]
  (let [name (get query-params "name")]
    {:status 200
     :body (json/generate-string
            {:message (if (empty? name)
                        "What is your name?"
                        (str "Hello " name))})}))

(defroutes routes

  (GET "/healthcheck"
       [] (healthcheck))

  (GET "/ping"
       [] "pong")

  (GET "/hello" req
       (hello req))


  (route/not-found (error-response "Resource not found" 404)))

(def app
  (-> routes
      (wrap-reload)
      (instrument)
      (wrap-error-handling)
      (wrap-ignore-trailing-slash)
      (wrap-json-response)
      (wrap-json-kw-params)
      (wrap-params)
      (expose-metrics-as-json)))
