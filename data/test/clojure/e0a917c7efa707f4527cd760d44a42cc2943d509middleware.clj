(ns the-playground.middleware
  (:require [the-playground.schema :as s]
            [the-playground.util :refer [format-request-method]]
            [bidi.bidi :as b]
            [cheshire.core :refer [generate-string]]
            [clojure.set :as set]
            [clojure.tools.logging :as log]
            [metrics.counters :refer [inc! dec!]]
            [metrics.meters :refer [mark!]]
            [metrics.timers :refer [time!]]
            [schema.core :as sc]
            [slingshot.slingshot :refer [try+]]))


(defn wrap-instrument-request-rates
  [handler metrics]
  (fn [{:keys [handler-key] :as request}]
    (mark! (:request-rate (get-in metrics [:handlers handler-key])))
    (handler request)))


(defn wrap-instrument-response-rates
  [handler metrics]
  (fn [{:keys [handler-key] :as request}]
    (let [handler-metrics (get-in metrics [:handlers handler-key])
          {:keys [status] :as response} (handler request)]

      (cond
        (>= status 500) (mark! (:5xx-response-rate handler-metrics))
        (>= status 400) (mark! (:4xx-response-rate handler-metrics))
        (>= status 300) (mark! (:3xx-response-rate handler-metrics))
        (>= status 200) (mark! (:2xx-response-rate handler-metrics)))

      response)))


(defn wrap-instrument-open-requests
  [handler metrics]
  (fn [{:keys [handler-key] :as request}]
    (let [open-requests (get-in metrics [:handlers handler-key :open-requests])
          _ (inc! open-requests)
          response (handler request)
          _ (dec! open-requests)]
      response)))


(defn wrap-instrument-timer
  [handler metrics]
  (fn [{:keys [handler-key] :as request}]
    (time!
     (:request-processing-time (get-in metrics [:handlers handler-key]))
     (handler request))))


(defn wrap-handler-key
  "Determine the intended handler and associate its key to the request map."
  [handler route-mapping]

  (fn [{:keys [uri request-method] :as request}]
    (let [handler-key (:handler (b/match-route route-mapping uri :request-method request-method))]
      (handler (assoc request :handler-key handler-key)))))


(defn wrap-validate
  "Ensures the the request and response satisfy their schema.
   Return a 400 response for an unsatisfied request schema.
   Throws an exception up for an unsatisfied response schema.
   Don't use this at the top level, only as local handler middleware."
  [handler {:keys [handler-doc]}]

  (let [request-schema (get-in handler-doc [:parameters :body])
        response-schemata (:responses handler-doc)]
    (fn [{:keys [body request-method uri handler-key] :as request}]
      (try+

       (when request-schema (sc/validate request-schema body))

       (let [{:keys [status body] :as response} (handler request)]
         (sc/validate (get-in response-schemata [status :schema]) body)
         response)

       (catch [:type :schema.core/error :schema request-schema] {:keys [error]}
         (log/warn "Validation failed for incoming" (format-request-method request-method)  "request to" uri "-" error)
         {:status 400
          :body error})))))


(defn wrap-collection-json-response
  [handler]
  (fn [request]
    (-> (handler request)
        (update :body generate-string)
        (update :headers assoc "Content-Type" "application/vnd.collection+json"))))


(defn wrap-generic-json-response
  [handler]
  (fn [request]
    (-> (handler request)
        (update :body generate-string)
        (update :headers assoc "Content-Type" "application/json"))))


(defn wrap-docs
  "Associates the docs to the handler's metadata. Don't use this
   at the top level, only as local handler middleware."
  [handler docs]
  (vary-meta handler assoc :docs docs))


(defn wrap-logging
  "Logs the request and response with associated data."
  [handler]

  (fn [{:keys [uri request-method handler-key] :as request}]
    (log/debug "Incoming" (format-request-method request-method) "request to" uri "handled by" handler-key)
    (let [{:keys [status] :as response} (handler request)]
      (log/debug "Outgoing" status "response for" (format-request-method request-method) "request to" uri "handled by" handler-key)
      response)))


(defn wrap-exception-catching
  "Returns a 500 when an exception goes unhandled."
  [handler]

  (fn [request]
    (try+
     (handler request)
     (catch Object o
       (log/error  "Unhandled exception -" o)
       {:status 500}))))
