(ns thread-load.streams
  (:import (java.util.concurrent ArrayBlockingQueue Executors ExecutorService TimeUnit))
  (:require [clojure.tools.logging :refer [error info]]))

;; Scale the reading of N streams by splitting the logic of reading from the streams from the logic of processing the data.
;; N_a threads should read from a stream-queue in which a data piece is read from the stream and pushed on the data queue

;; USAGE
;; (def processor (create-streams-processor ... )
;; on app shutdown:
;; (shutdown! processor)

(defn- ^ArrayBlockingQueue create-queue [n]
  (ArrayBlockingQueue. n))

(defn- queue-get! [^ArrayBlockingQueue q]
  (.take q))

(defn- queue-put! [^ArrayBlockingQueue q data]
  (.put q data))

(defn- put-stream-loop! [stream-queue init-state f]
  (let [[state stream] (f init-state)]
    (queue-put! stream-queue stream)
    (recur stream-queue state f)))

(defn- read-stream-loop! [stream-queue data-queue init-state stream-read-f]
  (let [stream (queue-get! stream-queue)
        state (try
                (let [[state data] (stream-read-f init-state stream)]
                  (if data
                    (queue-put! data-queue data))
                  state)
                (finally (queue-put! stream-queue stream)))]
    (recur stream-queue data-queue state stream-read-f)))

(defn- process-data-loop! [data-queue init-state f]
  (recur data-queue (f init-state (queue-get! data-queue)) f))

(defn- ^Runnable asRunnable [f]
  (fn []
    (try
      (f)
      (catch InterruptedException i (.interrupt (Thread/currentThread)))
      (catch Exception e (error e e)))))


(defn- submit! [^ExecutorService service f]
  (.submit service (asRunnable f)))

(defn create-stream-processor
  "stream-load-f : load only new streams f [state] -> [state stream], (f) -> intial-data
   stream-read-f : read data from a stream  f [state stream] -> [state data], (f) -> initial-state
   data-process-f: process data from any stream f [state data] -> state, (f) -> initial-state"
  [stream-load-f
   stream-read-f
   data-process-f & {:keys [stream-read-threads data-threads
                            streams-limit data-limit ] :or {stream-read-threads 2
                                                            data-threads 4
                                                            streams-limit 5000 data-limit 100}}]
  (let [stream-queue (create-queue streams-limit)
        data-queue (create-queue data-limit)
        stream-load-executor (Executors/newSingleThreadExecutor)
        stream-executor (Executors/newFixedThreadPool stream-read-threads)
        data-executor (Executors/newFixedThreadPool data-threads)]
    (dotimes [_ data-threads]
      (submit! data-executor #(process-data-loop! data-queue (data-process-f) data-process-f)))

    (dotimes [_ stream-read-threads]
      (submit! stream-executor #(read-stream-loop! stream-queue data-queue (stream-read-f) stream-read-f)))

    (submit! stream-load-executor #(put-stream-loop! stream-queue (stream-load-f) stream-load-f))

    {:data-queue data-queue :stream-queue stream-queue :data-executor data-executor :stream-executor stream-executor :stream-load-executor stream-load-executor}))


(defn- shutdown-service! [^ExecutorService service ^Long timeout]
  (.shutdown service)
  (.awaitTermination service timeout TimeUnit/MILLISECONDS)
  (.shutdownNow service))

(defn shutdown! [{:keys [stream-executor data-executor stream-load-executor]} & {:keys [timeout-ms] :or {timeout-ms 2000}}]
  (shutdown-service! stream-load-executor timeout-ms)
  (shutdown-service! stream-executor timeout-ms)
  (shutdown-service! data-executor timeout-ms))

