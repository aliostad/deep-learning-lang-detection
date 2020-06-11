(ns clj-momo.ring.middleware.metrics
  "Middleware to control all metrics of the server"
  (:require [clout.core :as clout]
            [metrics
             [core :refer [default-registry remove-metric] :as mc]
             [meters :refer [mark! meter]]
             [timers :refer [time! timer]]]
            [metrics.jvm.core :as jvm]
            [metrics.ring.instrument :refer [instrument]]
            [slugger.core :refer [->slug]]))

(def new-registry mc/new-registry)

(defn add-jvm-metrics
  [registry]
  (jvm/register-memory-usage-gauge-set registry)
  (jvm/register-garbage-collector-metric-set registry)
  (jvm/register-thread-state-gauge-set registry))

(def ^:private add-default-metrics
  (let [done? (volatile! false)
        lock (Object.)]
    (fn [registry]
      "This should only ever be done once"
      (locking lock
        (when-not @done?
          (add-jvm-metrics registry)
          (vreset! done? true))))))

(defn match-route? [[compiled-path _ verb] request]
  (if (= (name (:request-method request)) verb)
    (some? (clout/route-matches compiled-path request))
    false))

(defn matched-route [routes request]
  (first (filter #(match-route? % request) routes)))

(defn gen-metrics-for [handler reg routes prefix]
  (let [time-str (str prefix "-time")
        req-str (str prefix "-req")
        ;; Time by swagger route
        times (reduce (fn [acc [_ path verb]]
                        (assoc-in acc [path verb]
                                  (timer reg
                                         [time-str path verb])))
                      {:unregistered (timer reg
                                            [time-str "_" "unregistered"])}
                      routes)
        ;; Meter by swagger route
        meters (reduce (fn [acc [_ path verb]]
                         (assoc-in acc [path verb]
                                   (meter reg [req-str path verb])))
                       {:unregistered (meter reg [req-str "_" "unregistered"])}
                       routes)]
    (fn [request]
      (let [route (or (matched-route routes request)
                      [:place_holder :unregistered])]
        (mark! (get-in meters (drop 1 route)))
        (time! (get-in times (drop 1 route)) (handler request))))))


;; The get-routes-fn probably comes form compojure.api.routes, but we
;; want to avoid adding that dependancy to clj-momo.

(defn exposed-routes
  [routes]
  (map (fn [l] [(clout/route-compile (first l))
                (->slug (first l))
                (name (second l))])
       routes))

(defn wrap-metrics
  ([prefix get-routes-fn]
   (wrap-metrics prefix get-routes-fn default-registry true))
  ([prefix get-routes-fn registry add-jvm-metrics?]
   (fn [handler]
     (let [routes (get-routes-fn handler)
           exp-routes (exposed-routes routes)]
       (when add-jvm-metrics?
         (add-default-metrics registry))
       (-> handler
           (instrument registry)
           (gen-metrics-for registry exp-routes prefix))))))
