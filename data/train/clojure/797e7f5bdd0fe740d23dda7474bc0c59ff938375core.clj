(ns telemetry.core
  (:gen-class :prefix "-"
              :methods [^{:static true}
  [premain [String java.lang.instrument.Instrumentation] void]]
              :name telemetry.core.TelemetryAgent)
  (:require [telemetry.intercept])
  (:import (java.lang.instrument Instrumentation ClassFileTransformer)
           (telemetry.interceptor GeneralInterceptor)
           (telemetry.intercept GenInt)))

(defn class-transformer []
  (reify ClassFileTransformer
    (transform [this loader className classBeingRedefined protectionDomain classfileBuffer]
      (println (str "Class: " className))
      classfileBuffer)))

(defn setup-bbuddy [instr]
  )

(comment
  (defn -premain
    "Invoked by JVM instrumentation agent machinery"
    [^String args ^Instrumentation instr]
    (println "premain invoked")
    (.addTransformer instr (class-transformer))))

(defn -premain
  "Invoked by JVM instrumentation agent machinery"
  [^String args ^Instrumentation instr]
  (println "premain invoked")
  (GeneralInterceptor/configAgent instr GenInt))

(defn -main
  ""
  [& args]
  (println "main invoked"))
