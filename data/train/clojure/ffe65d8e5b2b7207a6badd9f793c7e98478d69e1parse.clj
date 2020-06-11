(ns forecast.parse
  (:require [clojure.string :as string]
            [clojure.java.io]
            [clojure.tools.logging :as log]
            [clojure.core.async :refer [go]]

            [forecast.helpers :as h]
            [forecast.repository.manage-repositories :as manage]
            [forecast.metrics :as metrics]
            [forecast.repository.ip-locator :as ip]
            [forecast.repository.location-forecast :as location]
            ))

;; set default repositories
(manage/use-random-services)
(manage/use-memory-storage)

(defn parse-logfile
  [filename f]
  (with-open [rdr (clojure.java.io/reader (str "data/" filename))]
    (doseq [line (line-seq rdr)]
      (h/bump :num-logs)
      (f line))))

(defn log-parser
  [line]
  (->
   line
   (string/split #"\t")
   (nth 23)          ;; ip address
   ip/store-ip
   ))

(defn process-new-ips
  []
  (doseq [ip (ip/new-ips)]
    (ip/find-location ip)))

(defn process-new-locations
  []
  (doseq [loc (location/new-locations)]
    (location/find-forecast loc)))

(def stop-threads? (atom false))

(defn infinite-loop
  ([f] (infinite-loop f nil))
  ([f delay] (infinite-loop f delay nil))
  ([f delay name]
   (go
     (loop []
       (try
         (f)
         (catch Throwable e
           (if (re-find #"(?m)^.*Index not found.*$" (str e))
             (manage/use-aerospike-storage)
             (log/errorf e (str "error in infinite-loop " name)))))
       (if delay (Thread/sleep delay))
       (when-not @stop-threads? (recur))
       ))))

(defn print-metrics []
  (h/log-it "ip metrics: " @(:metrics @ip/ip-repo))
  (h/log-it "location metrics: " @(:metrics @location/location-repo))
  )

(defn sleep-forever []
  (loop []                           ;; prevent program from closing
    (Thread/sleep 1e9)
    (recur)))

(defn daemon
  []
  (infinite-loop #'process-new-ips 1000 "process-new-ips")
  (infinite-loop #'process-new-locations 1000 "process-new-location")
  (infinite-loop #'print-metrics 15000 "print-metrics")
  (sleep-forever))

(defn get-histogram
  [num-bins]
  (let [temps (location/done-temperatures)]
    (if (empty? temps)
      []
      (h/histogram temps num-bins))))

(defn print-histogram
  [num-bins]
  (let [bins (get-histogram num-bins)]
    (if bins
      (do
        (println "\nbucketMin\tbucketMax\tcount")
        (doseq [bin bins]
          (println (clojure.string/join "\t" [(h/round-digits 1 (first bin)) (h/round-digits 1 (second bin)) (int (nth bin 2))]))))
      (println "no temperatures found"))
    )
  )

(defn parse-args
  [params]
  (metrics/reset-metrics)
  (let [args (set params)
        load? (contains? args "--load")
        process? (contains? args "--process")
        num-bins-location (if process? second first)]

    ;; setup
    (when (contains? args "--memory")
      (h/log-it "using memory")
      (manage/use-memory-storage))
    (when (contains? args "--aero")
      (h/log-it "using aerospike")
      (manage/use-aerospike-storage))
    (when (contains? args "--datascript")
      (h/log-it "using datascript")
      (manage/use-datascript-storage))
    (when (contains? args "--live")
      (h/log-it "using live services")
      (manage/use-live-services))

    ;; load logfile
    (when (and (or load? process?)
               (not (= \- (-> params first first))))
      (h/log-it "load file " (first params))
      (parse-logfile (first params) log-parser))

    ;; post processing
    (when process?
      (h/log-it "processing ...")
      (process-new-ips)
      (process-new-locations)
      )
    (when (contains? args "--daemon")
      (println "setting up a daemon")
      (daemon))
    (when (contains? args "--hist")
      (let [num-bins (if (= \- (-> params num-bins-location first))
                       5
                       (read-string (num-bins-location params)))]
        (print-histogram num-bins)))
    ))


;; (parse-logfile "logfile" log-parser)
;; (parse-logfile "logfile-big" log-parser)

;; (process-new-locations)
;; (process-all-locations)
;; (ip/new-ips)
;; (location/new-locations)
;; (location/done-temperatures)
;; (:close! @ip/ip-repo)

;; (process-new-locations)
;; (location/done-temperatures)
;; (get-histogram 5)


;; (manage/use-memory-storage)
;; (manage/use-aerospike-storage)
;; (run "logfile" 5)


