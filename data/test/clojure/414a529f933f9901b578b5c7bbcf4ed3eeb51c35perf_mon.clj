(ns lupapalvelu.perf-mon
  (:require [taoensso.timbre :as timbre :refer [trace debug info warn error fatal]]
            [noir.core :refer [defpage]]
            [monger.operators :refer :all]
            [lupapalvelu.mongo :as mongo]
            [lupapalvelu.logging :as log]
            [clojure.string :refer [join]]
            [noir.server :as server]
            [sade.env :as env]
            [sade.core :refer :all]))

;;
;; Instrumenting:
;;

(defn instrument [f ^clojure.lang.Var v]
  (alter-var-root v f (str (.ns v) \/ (.sym v))))

(defn instrument-ns [f & namespaces]
  (doseq [n namespaces
          v (->>
              (ns-publics n)
              vals
              (remove (comp :perfmon-exclude meta))
              (filter (comp fn? deref)))]
    (instrument f v)))

;;
;; State:
;;

(defonce db-throttle (atom 0))
(defonce web-throttle (atom 0))
(def ^:dynamic *perf-context* nil)

;;
;; Utils:
;;

(defn- bypass? [request]
  (let [uri (:uri request)]
    (or (get-in request [:query-params "npm"])
        (get-in request [:headers "npm"])
        (re-matches #"^\/api\/alive.*" uri)
        (not (re-matches #"^\/api\/.*" uri)))))

;;
;; Performance monitoring:
;;

(defn wrap-perf-mon [f f-name]
  (fn [& args]
    (if-let [context *perf-context*]
      (let [sub-context (atom [])]
        (binding [*perf-context* sub-context]
          (let [start (System/nanoTime)]
            (try
              (apply f args)
              (finally
                (let [end (System/nanoTime)]
                  (swap! context conj [f-name (- end start) @sub-context])))))))
      (apply f args))))

(defn- get-total-db-call-duration [perf-context]
  (->> perf-context (map second) (reduce +)))

(defn ns->ms [ns] (quot ns 1000000))

(defn log-perf-context [handler request]
  (if (bypass? request)
    (handler request)
    (binding [*perf-context* (atom [])]
      (let [start (System/nanoTime)]
        (try
          (handler request)
          (finally
            (let [end (System/nanoTime)]
              (debug (log/sanitize 200 (get request :uri)) ":"
                (ns->ms (- end start)) "ms,"
                (count @*perf-context*) "db calls took totally"
                (ns->ms (get-total-db-call-duration @*perf-context*)) "ms"))))))))

(defn perf-mon-middleware [handler] (fn [request] (log-perf-context handler request)))

;;
;; Throttling:
;;

(defn wrap-db-throttle [f f-name]
  (fn [& args]
    (Thread/sleep @db-throttle)
    (apply f args)))

(defn throttle-middleware [handler]
  (fn [request]
    (if-not (bypass? request) (Thread/sleep @web-throttle))
    (handler request)))

;;
;; REST API for performance data and throtting control:
;;

(defn get-data [start end]
  (map (fn [row] (dissoc row :_id))
    (mongo/find-maps :perf-mon-timing {$and [{:ts {$gte start}}
                                             {:ts {$lte end}}]})))

(defn to-long ^Long [v]
  (when v
    (if (string? v) (Long/parseLong v) (long v))))

(defn- find-min-max-avg [{:keys [min-val max-val avg cnt] :as m} {duration :duration perfmon :perfmon}]
  (assoc m :min-val (min min-val duration)
           :max-val (max max-val duration)
           :avg (double (/ (+ (* avg cnt) duration) (inc cnt)))
           :cnt (inc cnt)
           :db-cnt (count perfmon)))

(defn find-min-max-avg* [[k v]]
  [k (reduce find-min-max-avg {:min-val Double/MAX_VALUE :max-val Double/MIN_VALUE :avg 0.0 :cnt 0} v)])

;;
;; Initialize: register middlewares and wrap vars:
;;

(defn init []
  (when (env/dev-mode?)
    (server/add-middleware throttle-middleware)
    (instrument-ns wrap-db-throttle 'lupapalvelu.mongo))
  (server/add-middleware perf-mon-middleware)
  (instrument-ns wrap-perf-mon 'lupapalvelu.mongo))
