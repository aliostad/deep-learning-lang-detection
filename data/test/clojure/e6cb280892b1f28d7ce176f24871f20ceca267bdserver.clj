(ns {{name}}.server
  (:require [buddy.sign.jwt :as jwt]
            [{{name}}.config :refer [jwt-secret]]
            [clojure.tools.logging :as log]
            [compojure.core :refer :all]
            [metrics.core :refer [default-registry]]
            [metrics.counters :refer [inc! counter]]
            [metrics.jvm.core :refer [instrument-jvm]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [ring.middleware.json :refer [wrap-json-response wrap-json-params]]
            [ring.middleware.keyword-params :refer [wrap-keyword-params]]
            [ring.util.response :refer [response content-type]]))

(def unauthorized-request (counter default-registry ["{{name}}" "http" "unauthorized"]))

(defn not-found [message]
  (fn [_]
    (log/info "File not found")
    (-> {:status 404
         :body {:message message}}
        (content-type "application/json; charset=utf-8"))))

(defn wrap-exception-json [handler]
  (fn [req]
    (try
      (handler req)
      (catch Exception e
        {:status 500 :body {:exception (.getMessage e)}}))))

(defn verify-token [token]
  (try
    (jwt/unsign token (jwt-secret))
    (catch Exception e
      false)))

(defn parse-token [req]
  (second (clojure.string/split (get-in req [:headers "authentication"]) #" ")))

;; TODO - Determine if a shared secret is okay, or if this should reach out to the authentication microservice to verify token
(defn wrap-jwt-verification [handler]
  (fn [req]
    (if (verify-token (parse-token req))
      (handler req)
      (do
        (inc! unauthorized-request)
        (log/error "Unauthorized request")
        {:status 401 :body {:message "Unauthorized"}}))))

(defroutes handler
  (GET "/" [] (response {:message "{{sanitized}} microservice"}))
  (not-found "Page not found"))

(def app
  (-> handler
      wrap-exception-json
      wrap-jwt-verification
      wrap-keyword-params
      wrap-json-params
      wrap-json-response
      expose-metrics-as-json
      instrument))

(instrument-jvm default-registry)
