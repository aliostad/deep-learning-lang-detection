(ns atom-finder.instrumentation
  (:import [java.lang.instrument Instrumentation])
  (:require [atom-finder.core])
  (:gen-class
   :methods [^:static [premain [String java.lang.instrument.Instrumentation] void]
             ^:static [agentmain [String java.lang.instrument.Instrumentation] void]]))

;; TO BUILD AGENT JAR, RUN: lein with-profile instrumentation uberjar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Code for javaagent jar construction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare ^Instrumentation instrumentation)

(defn -premain [^String args ^Instrumentation instrumentation]
  (println "-premain")
  (def instrumentation instrumentation))

(defn -agentmain [^String args ^Instrumentation instrumentation]
  (println "-agentmain")
    (def instrumentation instrumentation))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Code for runtime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import '(com.sun.tools.attach VirtualMachine) '(java.lang.management ManagementFactory))
(defn pid []
  "PID of the running jvm"
  (re-find #"\d+" (.getName (ManagementFactory/getRuntimeMXBean))))

;; Call from JVM to be instrumented
(defn load-instrumentation
  []
  (def vm  (VirtualMachine/attach (pid)))
  (.loadAgent vm (str (.getCanonicalPath (clojure.java.io/file ".")) "/target/atom-finder-0.1.0-SNAPSHOT.jar")))

;(load-instrumentation)

;(.getObjectSize instrumentation {:a 1 :b 2 :c 3 :d 4})
