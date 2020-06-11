(ns com.sixsq.slipstream.ssclj.app.server
  (:require
    [clojure.tools.logging :as log]

    [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
    [ring.middleware.params :refer [wrap-params]]
    [ring.middleware.keyword-params :refer [wrap-keyword-params]]
    [ring.middleware.nested-params :refer [wrap-nested-params]]
    [ring.middleware.cookies :refer [wrap-cookies]]

    [metrics.core :refer [default-registry]]
    [metrics.ring.instrument :refer [instrument]]
    [metrics.ring.expose :refer [expose-metrics-as-json]]
    [metrics.jvm.core :refer [instrument-jvm]]

    [com.sixsq.slipstream.ssclj.app.aleph-container :as aleph]
    [com.sixsq.slipstream.ssclj.middleware.logger :refer [wrap-logger]]
    [com.sixsq.slipstream.ssclj.middleware.base-uri :refer [wrap-base-uri]]
    [com.sixsq.slipstream.ssclj.middleware.exception-handler :refer [wrap-exceptions]]
    [com.sixsq.slipstream.ssclj.middleware.authn-info-header :refer [wrap-authn-info-header]]
    [com.sixsq.slipstream.ssclj.middleware.cimi-params :refer [wrap-cimi-params]]
    [com.sixsq.slipstream.ssclj.app.routes :as routes]
    [com.sixsq.slipstream.ssclj.app.params :as p]
    [com.sixsq.slipstream.ssclj.app.graphite :as graphite]
    [com.sixsq.slipstream.db.impl :as db]
    [com.sixsq.slipstream.db.es.binding :as esb]
    [com.sixsq.slipstream.ssclj.resources.common.dynamic-load :as resources]))

(defn- set-persistence-impl
  []
  (db/set-impl! (esb/get-instance)))

(defn- create-ring-handler
  "Creates a ring handler that wraps all of the service routes
   in the necessary ring middleware to handle authentication,
   header treatment, and message formatting."
  []
  (log/info "creating ring handler")

  (instrument-jvm default-registry)

  (compojure.core/routes)

  (-> (routes/get-main-routes)

      ;;handler/site
      wrap-cimi-params
      wrap-base-uri
      wrap-keyword-params
      wrap-nested-params
      wrap-params
      wrap-exceptions
      wrap-authn-info-header
      (expose-metrics-as-json (str p/service-context "metrics") default-registry {:pretty-print? true})
      (wrap-json-body {:keywords? true})
      (wrap-json-response {:pretty true :escape-non-ascii true})
      (instrument default-registry)
      wrap-logger
      wrap-cookies
      ))

(defn start
  "Starts the server and returns a function that when called, will
   stop the application server."
  ([port]
   (start port "aleph"))
  ([port impl]
   (log/info "=============== SSCLJ START" port "===============")
   (log/info "java vendor: " (System/getProperty "java.vendor"))
   (log/info "java version: " (System/getProperty "java.version"))
   (log/info "java classpath: " (System/getProperty "java.class.path"))

   (esb/set-client! (esb/create-client))

   (set-persistence-impl)
   (resources/initialize)
   (let [handler (create-ring-handler)]
     (graphite/start-graphite-reporter)
     (aleph/start-container handler port))))

(defn stop
  "Stops the application server by calling the function that was
   created when the application server was started."
  [stop-fn]
  (try
    (and stop-fn (stop-fn))
    (log/info "shutdown application container")
    (catch Exception e
      (log/warn "application container shutdown failed:" (.getMessage e)))))
