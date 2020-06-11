(ns oauth-toy.web
  (:require [compojure
             [core :refer [defroutes context GET PUT POST DELETE]]
             [route :as route]]
            [metrics.ring
             [expose :refer [expose-metrics-as-json]]
             [instrument :refer [instrument]]]
            [radix
             [error :refer [wrap-error-handling error-response]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [setup :as setup]
             [reload :refer [wrap-reload]]]
            [ring.middleware
             [format-params :refer [wrap-json-kw-params]]
             [json :refer [wrap-json-response]]
             [params :refer [wrap-params]]]
            [oauth-toy.oauth :as o]))

(def version
  (setup/version "oauth-toy"))

(defn healthcheck
  []
  (let [body {:name         "oauth-toy"
              :version      version
              :success      true
              :dependencies []}]
    {:headers {"content-type" "application/json"}
     :status  (if (:success body) 200 500)
     :body    body}))

(defroutes routes

           (GET "/healthcheck"
                [] (healthcheck))

           (GET "/ping"
                [] "pong")

           (GET "/user/age"
                {{code "authorization-code"} :params}
             (if code
               (if (o/is-authorisation-code-valid? code "age")
                 {:status 200}
                 {:status 403})
               {:status  302
                :headers {"location" "http://localhost:8080/o/oauth2/auth?redirect_uri=http%3A%2F%2Flocalhost:8080%2Fuser%2Fage&client_id=123&scope=age&access_type=offline"}}))

           (GET "/user/name"
                {{code "authorization-code"} :params}
             (if code
               (if (o/is-authorisation-code-valid? code "name")
                 {:status 200}
                 {:status 403})
               {:status  302
                :headers {"location" "http://localhost:8080/o/oauth2/auth?redirect_uri=http%3A%2F%2Flocalhost:8080%2Fuser%2Fname&client_id=123&scope=name&access_type=offline"}}))

           (GET "/o/oauth2/auth"
                {{redirect-uri "redirect_uri" scope "scope"} :params}
             (if redirect-uri
               {:status  302
                :headers {"location" (str redirect-uri "?authorization-code=" (o/generate-new-authorisation-code scope))}}
               {:status 200
                :body {:authorization-code (o/generate-new-authorisation-code scope)}}))

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
