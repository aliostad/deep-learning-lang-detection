(ns balrog.executor
  (:import (balrog.hawt.util HawtUtil)
	   (org.fusesource.hawtdispatch Dispatch DispatchQueue DispatchSource)
	   (java.util.concurrent Executor)
	   (java.lang Runnable)))

(set! *warn-on-reflection* true)

(defn create-executor []
  (Dispatch/getGlobalQueue Dispatch/DEFAULT))

;; (defn ^DispatchQueue create-dispatch-queue [name]
;;   (Dispatch/createQueue name))

;; (defn ^DispatchSource create-dispatch-source [dispatch-queue]
;;   (Dispatch/createSource (EventAggregators/linkedList)
;;      ;(reify EventAggregator
;;      ;  (mergeEvent [this prev next] (fn-aggregator prev next))
;;      ;  (mergeEvents [this prev next] (fn-aggregator prev next)))
;;      dispatch-queue))

;; (defn ^DispatchSource create-channel-dispatch-source [channel selector dispatch-queue]
;;   (Dispatch/createSource channel selector dispatch-queue))

(defn execute [^Executor executor ^Runnable f]
  (.execute executor f))

(defn merge-data [^DispatchSource ds event]
  (HawtUtil/merge ds event))

(defn wrap-in-dq [f next]
  (let [dq (HawtUtil/createDispatchQueue "test")
	ds (HawtUtil/createDispatchSource dq)
	handler (if next (comp next f) f)]
    (.setEventHandler ds #(doall (map handler (.getData ds))))
    (.resume ds)
    (partial merge-data ds)))

(defn >>> [& fns]
  (reduce #(wrap-in-dq %2 %1) nil fns))
  