(ns clj-metrics.ring
  (:gen-class)
  (:require [clj-metrics.core :refer :all]))

(defn- mark-in! [metric-map k]
  (when-let [metric (metric-map k (metric-map :other))]
    (mark! metric)))

(defn instrument
  "Instrument a ring handler.

  This middleware should be added as late as possible (nearest to the outside of
  the \"chain\") for maximum effect.
  "
  ([handler]
   (let [active-requests (counter ["ring" "requests" "active"])
         requests (meter ["ring" "requests" "rate"])
         responses (meter ["ring" "responses" "rate"])
         statuses {2 (meter ["ring" "responses" "rate.2xx"])
                   3 (meter ["ring" "responses" "rate.3xx"])
                   4 (meter ["ring" "responses" "rate.4xx"])
                   5 (meter ["ring" "responses" "rate.5xx"])}
         times {:get     (timer ["ring" "handling-time" "GET"])
                :put     (timer ["ring" "handling-time" "PUT"])
                :post    (timer ["ring" "handling-time" "POST"])
                :head    (timer ["ring" "handling-time" "HEAD"])
                :delete  (timer ["ring" "handling-time" "DELETE"])
                :options (timer ["ring" "handling-time" "OPTIONS"])
                :trace   (timer ["ring" "handling-time" "TRACE"])
                :connect (timer ["ring" "handling-time" "CONNECT"])
                :other   (timer ["ring" "handling-time" "OTHER"])}
         request-methods {:get     (meter ["ring" "requests" "rate.GET"])
                          :put     (meter ["ring" "requests" "rate.PUT"])
                          :post    (meter ["ring" "requests" "rate.POST"])
                          :head    (meter ["ring" "requests" "rate.HEAD"])
                          :delete  (meter ["ring" "requests" "rate.DELETE"])
                          :options (meter ["ring" "requests" "rate.OPTIONS"])
                          :trace   (meter ["ring" "requests" "rate.TRACE"])
                          :connect (meter ["ring" "requests" "rate.CONNECT"])
                          :other   (meter ["ring" "requests" "rate.OTHER"])}]
     (fn [request]
       (inc! active-requests)
       (try
         (let [request-method (:request-method request)]
           (mark! requests)
           (mark-in! request-methods request-method)
           (let [resp (time! (times request-method (times :other))
                             (handler request))
                 status-code (get resp :status 404)]
             (mark! responses)
             (mark-in! statuses (int (/ status-code 100)))
             resp))
         (finally (dec! active-requests)))))))


