;   Copyright (c) Shantanu Kumar. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.


(ns preflex.instrument-test
  (:require
    [clojure.test :refer :all]
    [preflex.core       :as core]
    [preflex.instrument :as instru]
    [preflex.internal   :as in])
  (:import
    [java.util.concurrent ExecutorService]
    [preflex.instrument.concurrent FutureWrapper SharedContextFuture]))


(defmacro with-active-thread-pool
  [[thread-pool-sym thread-pool] & body]
  (in/expected symbol? "a symbol to bind the thread-pool to" thread-pool-sym)
  `(let [~thread-pool-sym ~thread-pool]
     (try
       (do ~@body)
       (finally
         (.shutdownNow ~thread-pool-sym)))))


(deftest test-instrument-thread-pool
  (testing "default instrumentation"
    (with-active-thread-pool [^ExecutorService thread-pool (core/make-bounded-thread-pool 10 10)]
      (doseq [pool [thread-pool (:thread-pool thread-pool)]]
        (let [instru-pool (instru/instrument-thread-pool pool {})]
          (is (nil?
                @(.submit ^ExecutorService instru-pool ^Runnable #(do 10))))
          (is (= 10
                @(.submit ^ExecutorService instru-pool ^Callable #(do 10))))))))
  (testing "shared context instrumentation"
    (with-active-thread-pool [^ExecutorService thread-pool (core/make-bounded-thread-pool 10 10)]
      (let [instru-pool (instru/instrument-thread-pool thread-pool
                          instru/shared-context-thread-pool-task-wrappers-millis)]
        (let [^FutureWrapper fut (.submit ^ExecutorService instru-pool ^Runnable #(do 10))
              ^SharedContextFuture scf (.getOrig fut)
              shared-context (.getContext scf)]
          (is (instance? FutureWrapper fut))
          (is (instance? SharedContextFuture scf))
          (is (contains? @shared-context :submit-begin-ms))
          (is (contains? @shared-context :submit-end-ms))
          (is (nil? @fut))
          (is (contains? @shared-context :execute-begin-ms))
          (is (contains? @shared-context :execute-end-ms))
          (is (contains? @shared-context :result-begin-ms))
          (is (contains? @shared-context :result-end-ms))
          (is (contains? @shared-context :duration-queue-ms))
          (is (contains? @shared-context :duration-execute-ms))
          (is (contains? @shared-context :duration-response-ms)))
        (let [^FutureWrapper fut (.submit ^ExecutorService instru-pool ^Callable #(do 10))
              ^SharedContextFuture scf (.getOrig fut)
              shared-context (.getContext scf)]
          (is (instance? FutureWrapper fut))
          (is (instance? SharedContextFuture scf))
          (is (contains? @shared-context :submit-begin-ms))
          (is (contains? @shared-context :submit-end-ms))
          (is (= 10 @fut))
          (is (contains? @shared-context :execute-begin-ms))
          (is (contains? @shared-context :execute-end-ms))
          (is (contains? @shared-context :result-begin-ms))
          (is (contains? @shared-context :result-end-ms))
          (is (contains? @shared-context :duration-queue-ms))
          (is (contains? @shared-context :duration-execute-ms))
          (is (contains? @shared-context :duration-response-ms))))))
  (testing "invoker with shared context instrumentation"
    (with-active-thread-pool [^ExecutorService thread-pool (core/make-bounded-thread-pool 10 10)]
      (let [invoker (fn [g context-atom] (swap! context-atom assoc :added-by-invoker 20) (g))
            instru-pool (instru/instrument-thread-pool thread-pool
                          (-> instru/shared-context-thread-pool-task-wrappers-nanos
                            (assoc
                              :callable-decorator  (instru/make-shared-context-callable-decorator invoker)
                              :runnable-decorator  (instru/make-shared-context-runnable-decorator invoker))))]
        (let [^FutureWrapper fut (.submit ^ExecutorService instru-pool ^Runnable #(do 10))
              ^SharedContextFuture scf (.getOrig fut)
              shared-context (.getContext scf)]
          (is (instance? FutureWrapper fut))
          (is (instance? SharedContextFuture scf))
          (is (contains? @shared-context :submit-begin-ns))
          (is (contains? @shared-context :submit-end-ns))
          (is (= 20 (get @shared-context :added-by-invoker)))
          (is (nil? @fut))
          (is (contains? @shared-context :execute-begin-ns))
          (is (contains? @shared-context :execute-end-ns))
          (is (contains? @shared-context :result-begin-ns))
          (is (contains? @shared-context :result-end-ns))
          (is (contains? @shared-context :duration-queue-ns))
          (is (contains? @shared-context :duration-execute-ns))
          (is (contains? @shared-context :duration-response-ns)))
        (let [^FutureWrapper fut (.submit ^ExecutorService instru-pool ^Callable #(do 10))
              ^SharedContextFuture scf (.getOrig fut)
              shared-context (.getContext scf)]
          (is (instance? FutureWrapper fut))
          (is (instance? SharedContextFuture scf))
          (is (contains? @shared-context :submit-begin-ns))
          (is (contains? @shared-context :submit-end-ns))
          (is (= 20 (get @shared-context :added-by-invoker)))
          (is (= 10 @fut))
          (is (contains? @shared-context :execute-begin-ns))
          (is (contains? @shared-context :execute-end-ns))
          (is (contains? @shared-context :result-begin-ns))
          (is (contains? @shared-context :result-end-ns))
          (is (contains? @shared-context :duration-queue-ns))
          (is (contains? @shared-context :duration-execute-ns))
          (is (contains? @shared-context :duration-response-ns)))))))
