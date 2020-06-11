(ns clj-gearman.pool
  "Gearman job server connection pool functions."
  (:import (java.net ConnectException))
  (:require [clj-gearman.socket :as s]))

(defn- conn-socket [meta retry]
  (fn [conn] (try (s/connect conn meta retry) (catch ConnectException ex nil))))

(defn- conn-slow [servers meta]
  (if-let [socket (some (conn-socket meta 10) (butlast servers))]
    socket
    (s/connect (last servers) meta 10)))

(defn- conn-fast [servers meta]
  (some (conn-socket meta 0) servers))

(defn connect-first
  "Loop through a list of servers and return first one available"
  [servers conn-meta]
  ; First try each server without retries.
  (if-let [socket (conn-fast servers conn-meta)]
    socket
    ; If that fails, loop them again and throw exception if we still can't connect.
    (conn-slow servers conn-meta)))


(defn- worker-thread [running worker connect work]
  (Thread. (fn []
             (while @running
               (try
                 (with-open [socket (connect worker)]
                   (while @running (work socket)))
                 (catch Throwable _ (Thread/sleep 5000)))))))


(defn worker-pool
  "Create and manage worker pools. Used via worker/pool function."
  [worker-def connect work]
  (let [running (atom true)
        workers (map #(assoc worker-def :job-servers [%]) (:job-servers worker-def))
        server-pool (fn [worker]
                      (map (fn [_] (worker-thread running worker connect work))
                           (range (get worker-def :nthreads 1))))
        server-pools (map server-pool workers)]
    (doseq [pool server-pools]
      (doseq [^Thread th pool]
        (.start th)))
    (fn []
      (reset! running false)
      (doseq [pool server-pools]
        (doseq [^Thread th pool]
          (.join th))))))
