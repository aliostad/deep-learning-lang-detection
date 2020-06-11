(ns carbonite.core
  (:gen-class
   :name carbonite.BytecodeVault
   :methods [^{:static true} [agentmain [String java.lang.instrument.Instrumentation] void]
             ^{:static true} [getBytecode [Class] "[B" ]])
  (:require [clojure.string :refer [join]]
            [clojure.java.io :refer [input-stream output-stream]])
  (:import [java.io.File]
           [java.util.jar.Manifest]))

(def the-instrumentation)

(defn -agentmain [agent-args inst]
  (alter-var-root #'the-instrumentation (constantly inst))
  (System/setProperty "carbonite.agent.installed" "true"))

(defn -installAgent []
  #_(let [path (-> (.getClass carbonite.BytecodeVault)
                 (.getProtectionDomain)
                 (.getCodeSource)
                 (.getLocation)
                 (.getPath)
                 (.toURI))
        pid (-> (java.lang.management.ManagementFactory/getRuntimeMXBean)
                (.getName)
                (.split "@")
                (get 0))
        vm (com.sun.tools.attach.VirtualMachine/attach pid)]
    (prn pid)
    (.loadAgent vm path)))

(defn find-bytecode [class]
  (with-local-vars [bytecode nil]
    (let [cft (reify java.lang.instrument.ClassFileTransformer
                (transform [_ loader class-name class-being-redefined
                            protection-domain classfile-buffer]
                  (var-set bytecode classfile-buffer)
                  classfile-buffer))]
      (try
        (.addTransformer the-instrumentation cft true)
        (.retransformClasses the-instrumentation (into-array [class]))
        (var-get bytecode)
        (finally (.removeTransformer the-instrumentation cft))))))

(def -getBytecode (memoize find-bytecode))

