(ns com.creeaaakk.dtm-dispatch.executor
  (:require [clojure.core.match :refer [clj-form]]

            [com.creeaaakk.dtm-dispatch.protocols
             [dispatch :as dsp]
             [producer :as p]
             [daemon :as dmn]]
            
            [datomic.api :as d])
  (:import [java.util.concurrent
            ThreadPoolExecutor ThreadPoolExecutor$DiscardPolicy
            TimeUnit SynchronousQueue BlockingQueue]))

(extend-type datomic.Connection
  p/IProducer
  (start-events
    ([connection]
       (d/tx-report-queue connection))
    ([connection _]
       (throw (Error. "(get-events this queue) not implemented for datomic.Connection"))))
  (stop-events
    ([connection]
       (d/remove-tx-report-queue connection))
    ([connection _]
       (d/remove-tx-report-queue connection))))

(declare pumping-loop)

(deftype DispatchingExecutor
    [disp executor producer ^BlockingQueue txn-queue ^BlockingQueue work-queue stop pumping-thread]

  dmn/IDaemon
  (start [this]
    (if (nil? @pumping-thread)
      (do (reset! pumping-thread (Thread. (pumping-loop txn-queue disp stop executor) "pumping-thread"))
          (.start @pumping-thread))
      (throw (ex-info "Tried to start non-new pumping-thread." {:thread-state (.getState @pumping-thread)}))))
  (stop [_]
    (p/stop-events producer)
    (when-not (or (nil? @pumping-thread)
                  (= (.getState @pumping-thread) Thread$State/TERMINATED))
      (.put txn-queue stop)
      (.join @pumping-thread))
    (.shutdown executor)
    :done))

(defn pumping-loop
  [txn-queue dispatch-table stop-sentinel executor]
  (fn [] (loop [txn (.take txn-queue)]
          (when-not (identical? txn stop-sentinel)
            (if-let [handler (dsp/dispatch dispatch-table (:tx-data txn))]
              (.execute executor (handler txn)))
            (recur (.take txn-queue))))))

(defn executor
  "Given a sequence of txn handlers and a txn-queue, return a
  ThreadPoolExecutor that will run the appropriate handler for each
  txn in the queue."
  ([txn-queue]
     (executor nil txn-queue))
  ([dispatch txn-queue]
     (executor dispatch txn-queue (SynchronousQueue.)))
  ([dispatch txn-queue work-queue]
     (let [num-procs (.availableProcessors (Runtime/getRuntime))]
       (executor (ThreadPoolExecutor. num-procs (* 2 num-procs)
                                      500 TimeUnit/MILLISECONDS
                                      work-queue
                                      (ThreadPoolExecutor$DiscardPolicy.))
                 dispatch
                 txn-queue work-queue)))
  ([executor dispatch producer work-queue]
     (let [txn-queue (p/start-events producer)]
       (->DispatchingExecutor dispatch executor producer
                              txn-queue work-queue
                              (Object.) (atom nil)))))

