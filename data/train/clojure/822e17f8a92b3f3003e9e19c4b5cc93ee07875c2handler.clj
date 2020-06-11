(ns atomist.rugs.handler
  (:require
    [atomist.rugs.config-service :as config-service]
    [atomist.rugs.dynamo :as dynamo]
    [atomist.rugs.kafka :refer [kafka-producer]]
    [com.atomist.kafka.client :as kafka]
    [clj-time.coerce :as time.coerce]
    [clj-time.core :as time]
    [clojure.data.json :as json]
    [clojure.pprint :refer :all]
    [clojure.string :as str]
    [clojure.tools.logging :as log]
    [compojure.api.sweet :refer :all]
    [environ.core :refer [env]]
    [ring.util.http-response :refer :all]
    [schema.core :as s]
    [mount.core :refer [defstate start stop]]))

(defmethod compojure.api.meta/restructure-param :producer
  [_ producer acc]
  (update-in acc [:lets] into [{producer :producer} '+compojure-api-request+]))

(def ready (atom true))

(def api-handlers
  (api
    {:swagger
     {:ui   "/api-docs"
      :spec "/swagger.json"
      :data {:info {:title       "Incoming Webhooks"
                    :description "Atomist event Ingestion Service - we are here to take HTTP messages and put the data
                                  on to kafka topics"}
             :tags [{:name "slack", :description "Slack specific Action messages"}
                    {:name "k8-admin", :description "k8 management endpoints"}
                    {:name "webhooks", :description "manage the webhooks exposed to public"}]}}}

    (context "/admin" []
      :tags ["k8-admin"]
      (GET "/health" []
        :tags ["admin"]
        :summary "Returns OK when we are healthy"
        (ok "healthy"))

      (GET "/ready" []
        :tags ["admin"]
        :summary "Returns OK when we are ready to serve requests"
        (if @ready
          (ok "ready")
          (service-unavailable {:status "Shutting down"}))))))

(defn make-handler
  "Wrap a ring handler (e.g. routes from defapi) into middleware which will
   assoc components to each request.
   Handler is used through a var so that changes to routes will take effect
   without restarting the system (e.g. re-evaulating the defapi form)"
  [app]
  (fn [req] (-> req
                (assoc :producer kafka-producer)
                app)))

(defstate handler :start (make-handler api-handlers)
                  :stop (fn [_] (fn [req] nil)))

