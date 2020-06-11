(ns td-bot.metrics
  (:require [clojure.test :refer :all]
            [td-bot.stats :as stats]
            [clojure.pprint :refer [pprint]]
            [metrics.meters :as meters]
            [metrics.gauges :as gauges]
            [metrics.reporters.graphite :as graphite]
            [metrics.reporters.csv :as csv]
            [environ.core :refer [env]])
  (:import [java.util.concurrent TimeUnit]))

;; We aren't being smart about how many data points to keep,
;; so keeping this on in production would eventually exhaust the heap
(def instrument? (atom false))
(def metrics (atom {}))
(def CR (delay (csv/reporter (env :td-bot-log-dir) {})))
(def GR (graphite/reporter {:host "localhost"
                            :rate-unit TimeUnit/SECONDS
                            :duration-unit TimeUnit/MILLISECONDS}))

(defn with-gauge [title val]
  (let [gauge (or (get-in @metrics [:gauges title])
                  (get-in (swap! metrics
                                 (fn [m]
                                   (let [backing-atom (atom nil)]
                                     (update-in m [:gauges]
                                                #(assoc % title {:gauge (gauges/gauge-fn title (fn [] @backing-atom))
                                                                 :backing-atom backing-atom})))))
                          [:gauges title]))]
    (reset! (:backing-atom gauge) val)))


(defn mark-meter!
  ([title]
   (mark-meter! title 1))
  ([title n]
   (let [met (or (get-in @metrics [:meters title])
                 (get-in (swap! metrics (fn [m]
                                          (update-in m [:meters]
                                                     #(assoc % title (meters/meter title)))))
                         [:meters title]))]
     (meters/mark! met n))))

(defn reset-metrics! []
  (reset! metrics {})
  (csv/start @CR 5) ;; every 5 seconds
  (graphite/start GR 10)) ;; every 10 seconds

(defn print-metrics []
  (clojure.pprint/pprint
   (sort-by (comp :total second)
            (let [m @metrics]
              (into {}
                    (for [[label times] (:timers m)]
                      [label {:mean (double (stats/mean times))
                              :median (stats/median times)
                              :n (count times)
                              :max (apply max times)
                              :total (reduce + times)}]))))))

;; TODO: Use the Metrics library for this
(defmacro timed
  "Execute body and conj the execution time to the metrics with the given label"
  [label & body]
  `(let [start# (System/currentTimeMillis)
         result# ~@body
         t# (- (System/currentTimeMillis) start#)]
     (when (deref instrument?)
       (do (swap! metrics (fn [m#]
                            (update-in m# [:timers ~label] #(conj % t#))))
           result#))
     result#))
