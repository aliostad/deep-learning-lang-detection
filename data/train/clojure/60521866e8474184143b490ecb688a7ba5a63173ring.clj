(ns outpace.metrics-delivery.ring
  (:require
    [metrics.core :refer [default-registry]]
    [metrics.counters :refer (counter inc! dec!)]
    [metrics.meters :refer (meter mark!)]
    [metrics.timers :refer (timer time!)]
    [clojure.core.memoize :as memo]
    [clout.core :as clout])
  (:import [com.codahale.metrics MetricRegistry]))

(defn instrument-by-uri
  "Instrument a ring handler by uri.
  Beware: a route like /user/123 is an unbounded set of metrics!
  If you have an unbounded route, monitor your routes explicitly (instrument-routes).
  Expells the least recently used uris if more than 1000 are seen."
  ([handler]
   (instrument-by-uri handler default-registry))
  ([handler ^MetricRegistry reg]
   (let [metrics (memo/lru (fn [uri]
                             [(meter reg ["ring" "uri" uri])
                              (timer reg ["ring" "uri-time" uri])])
                           :lru/threshold 2)]
     (fn [{:keys [uri] :as request}]
       (let [[m t] (metrics uri)]
         (mark! m)
         (time! t (handler request)))))))

(def compiled
  (memoize clout/route-compile))

(defn match [routes request]
  (first
    (filter
      (fn [route]
        (clout/route-matches (compiled route) request))
      routes)))

;; TODO: split get/post
;; Make another function that takes {:get [route1 route2] :post [route3]}
(defn instrument-by-routes
  "Instrument a ring handler by a predefined set of pattern matching routes.
  The input routes is a collection of route patterns to match for.
  e.g. [\"/user/:user-id\" \"/add/:user-id/cats\"]
  If you can think of a way to get these from compojure, let me know.
  Instruments by the first match only."
  ([handler routes]
   (instrument-by-routes handler routes default-registry))
  ([handler routes ^MetricRegistry reg]
   (let [routes (distinct routes)
         metrics (into {}
                       (for [route routes]
                         [route
                          [(meter reg ["ring" "route" route])
                           (timer reg ["ring" "route-time" route])]]))]
     (fn [request]
       (if-let [[m t] (some-> (match routes request) metrics)]
         (do
           (mark! m)
           (time! t (handler request)))
         (handler request))))))
