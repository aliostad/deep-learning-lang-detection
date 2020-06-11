;; -*- coding: utf-8 -*-
;;

;; Author: Howard Zhao
;;
;; Component to manage the worker instances including
;; checking for expired workers.

(ns flock.worker
  (:require [clojure.java.jdbc :as jdbc]
            [clojure.tools.logging :as log]
            [clojure.string :refer [join]]
            [base.util :as util]
            [component.scheduler :refer [schedule-fixed-delay]]
            [flock.environment :refer [get-env-by-id get-env-by-name]]
            [component.database :refer [mydb get-conn get-single-row insert-row]]
            [component.core :refer [get-config-int]]
            [com.stuartsierra.component :as component]))

(defn- convert-heartbeat [worker]
  (if-let [hb (:heartbeat worker)]
    (assoc worker :heartbeat (. hb getTime))
    worker))

(defn get-worker-by-id
  [comp wid]
  (-> (get-single-row (mydb comp) :worker :wid (util/to-int wid "wid"))
      (convert-heartbeat)))

(defn get-worker-by-ip-pid
  [comp ip pid]
  (-> (jdbc/query (mydb comp) ["select * from worker where ip=? and pid=?" ip pid])
      (first)
      (convert-heartbeat)))

(defn start-worker
  "Called when a new worker starts.
  Create a worker record using ip address and process pid which is unique.
  returns worker created"
  [comp ip pid env]
  (assert (some? ip) "Invalid ip")
  (assert (some? env) "Invalid env")
  (let [eid (get-env-by-name (get comp :env-comp) env)
        _ (assert (some? eid) (str "Invalid eid"))
        pid (util/to-int pid "pid")
        worker (get-worker-by-ip-pid comp ip pid)]
    (if worker
      (assoc worker :msg "worker already registered")
      (->> (insert-row (mydb comp) :worker {:ip ip :pid pid :eid eid})
           (get-single-row (mydb comp) :worker :wid)
           (convert-heartbeat)
           (util/log-time-info #(str "registered new worker " %))))))

(defn set-admin-cmd
  "update worker admin command"
  [comp wid cmd]
  (let [db (mydb comp)]
    (if (= '(0) (jdbc/update! db :worker {:admin_cmd cmd} ["wid=?" wid]))
     {:msg (str "worker " wid " is not found")}
     (let [worker (get-single-row db :worker :wid wid)]
       (log/info "Worker " wid " new admin cmd=" cmd)
       (convert-heartbeat worker)))))

(defn update-heartbeat
  "update worker heartbeat and status.
  returns updated worker, including admin_cmd"
  [comp wid wstatus]
  (if (= '(0) (jdbc/update! (mydb comp) :worker {:wstatus wstatus} ["wid=?" wid]))
    {:msg (str "worker " wid " is not found")}
    (do (log/info "Worker" wid "updated wstatus " wstatus " and heartbeat")
        (get-worker-by-id comp wid))))

(defn cleanup-worker
  "Called when worker shutdown or presumed dead (indicated by event).
  Release reserved tasks and remove worker row.
  returns (1) for worker is clean up, (0) for worker is not active"
  [comp event worker]
  (let [db (mydb comp)
        {wid :wid} worker]
    ; reset wid to 0 for this worker
    (->> (jdbc/update! db :schedule {:wid 0} ["wid=?" wid])
         (util/log-time-info
           #(str "cleanup worker " wid event " task count=" %)))
    (jdbc/delete! db :worker ["wid=?" wid])
    (jdbc/update! db :schedule {:wid 0} ["wid in (?, ?)" wid (- 0 wid)])))

(defn stop-worker [comp wid]
  (let [db (mydb comp)]
    (if-let [worker (get-single-row db :worker "wid" wid)]
      (do (cleanup-worker comp "SHUTDOWN" worker)
          {:msg (str "worker " wid " stopped")})
      {:msg "worker is already dead"})))

(defn- check-dead-workers
  "check for dead workers and clean them up if any."
  [comp]
  (try
    (let [db (mydb comp)
          heartbeat (get-config-int comp "flock.worker.heartbeat" 5)
          max-skip (get-config-int comp "flock.worker.max.skipped.heartbeats" 4)
          allowance (* heartbeat max-skip)]
      (log/info "checking for dead worker with heartbeat older than" allowance "secs")
      (doall
        (->> ["select * from worker where heartbeat < now() - INTERVAL ? SECOND" allowance]
             (jdbc/query db)
             (map #(cleanup-worker comp "EXPIRED" %)))))
    (catch Exception ex
      (log/error ex "check dead worker error"))))

(defn start-monitor
  "start monitor thread that look for dead workers."
  [comp]
  (log/info "start monitoring worker using scheduler")
  (let [monitor-cycle (get-config-int comp "flock.worker.monitor.cycle.sec" 10)
        scheduler (get comp :scheduler)]
    (->> (fn [] (check-dead-workers comp))
         (assoc {:delay monitor-cycle :msg "worker monitor"} :command)
      (schedule-fixed-delay scheduler)))
  comp)

(defrecord WorkerComponent [core scheduler flock-db env-comp]
  component/Lifecycle
  (start [this]
    (start-monitor this))

  (stop [this]
    this))

(defn new-worker-comp
  []
  (map->WorkerComponent {}))
