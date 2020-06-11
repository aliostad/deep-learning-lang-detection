(ns wfeditor.io.util.thread
  (:require
   [wfeditor.io.util.const :as io-const]))

(defn do-and-sleep-repeatedly-bg-thread
  "a function that takes an input fn (and optionally a time, in millisecs) and returns a future that is also a running, newly-created background thread.   do-and-sleep-repeatedly takes the same inputs as the input fn.  the future is initialized with an anonymous function that performs the input fn (with the provided args) and sleeps for the given amount of time, repeatedly"
  ;; based on SO posts
  ;; http://stackoverflow.com/questions/5291436/idiomatic-clojure-way-to-spawn-and-manage-background-threads and http://stackoverflow.com/questions/5397955/sleeping-a-thread-inside-an-executorservice-java-clojure
  ;; passed up on what seems possible but less suitable ways to do it
  ;; that were mentioned in another SO post http://stackoverflow.com/questions/1768567/how-does-one-start-a-thread-in-clojure
  ([sleep-time f & args]
     (future
       (dorun
         (repeatedly
          (fn []
            (apply f args)
            (Thread/sleep sleep-time)))))))

(defn do-and-sleep-repeatedly-bg-thread-try-catch
  "similar to do-and-sleep-repeatedly-bg-thread, but handles exceptions/errors with a try/catch.  cfn is one-arg function run in the catch clause, where the one arg is the exception/error in the catch clause. ffn is the no-arg function in the finally clause"
  ([cfn ffn sleep-time f & args]
     (future
       (dorun
         (repeatedly
          (fn []
            (try
              (apply f args)
              (catch Throwable t (cfn t))
              (finally (ffn)))
            (Thread/sleep sleep-time)))))))