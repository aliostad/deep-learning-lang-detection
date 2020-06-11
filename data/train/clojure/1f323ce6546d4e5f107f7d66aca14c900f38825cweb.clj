(ns baker.web
  (:require [baker
             [amis :as amis]
             [awsclient :as awsclient]
             [common :as common]
             [lock :as lock]
             [packer :as packer]
             [scheduler :as scheduler]]
            [baker.builders
             [routes :as builder-routes]]
            [cheshire.core :as json]
            [clojure.string :refer [split replace-first]]
            [clojure.tools.logging :refer [info warn error]]
            [compojure.core :refer [defroutes context GET PUT POST DELETE]]
            [compojure.route :as route]
            [compojure.handler :as handler]
            [environ.core :refer [env]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [ring.middleware.json :refer [wrap-json-body]]
            [ring.middleware.format-response :refer [wrap-json-response]]
            [ring.middleware.params :refer [wrap-params]]
            [ring.middleware.keyword-params :refer [wrap-keyword-params]]
            [overtone.at-at :refer [show-schedule]]
            [radix
             [error :refer [wrap-error-handling error-response]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [reload :refer [wrap-reload]]
             [setup :as setup]]))

(def version
  "The version of the app"
  (setup/version "baker"))

(defn status
  "Returns the service status"
  []
  (common/response {:name "baker" :version version :success true} "application/json" 200))

(defroutes routes

  (GET "/healthcheck" []
       (status))

   (GET "/ping" []
        "pong")

   (GET "/status" []
        (status))

   (POST "/lock" req
         (lock/lock-builders req))

   (DELETE "/lock" []
        (lock/unlock-builders))

   (GET "/amis" []
        (amis/latest-amis))

   (GET "/inprogress" []
        (common/response (with-out-str (show-schedule packer/timeout-pool)) "text/plain"))

   (POST "/clean/:service" [service]
         (if (= service "all")
           (scheduler/kill-amis)
           (scheduler/kill-amis-for-application service)))

   (GET "/amis/active/:service/:environment/:region" [service environment region]
        (common/response (awsclient/active-amis-for-service service (keyword environment) region)))

   (GET "/amis/:service" [service]
        (amis/latest-service-amis service))

   (POST "/make-public/:service" [service]
         (awsclient/allow-prod-access-to-service service))

   (DELETE "/:service-name/amis/:ami" [service-name ami]
           (amis/remove-ami service-name ami))

   (context "/bake" [] builder-routes/route-defs)

  (route/not-found (error-response "Resource not found" 404)))

(defn remove-legacy-path
  "Temporarily redirect anything with /1.x in the path to somewhere without /1.x"
  [handler]
  (fn [request]
    (handler (update-in request [:uri] (fn [uri] (replace-first uri "/1.x" ""))))))

(def app
  (-> routes
      (wrap-reload)
      (remove-legacy-path)
      (instrument)
      (wrap-error-handling)
      (wrap-ignore-trailing-slash)
      (wrap-keyword-params)
      (wrap-params)
      (wrap-json-response)
      (wrap-json-body)
      (expose-metrics-as-json)))
