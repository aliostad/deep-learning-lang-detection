(ns excimer.btrace
  (:require [clojure.java.io :as io]
            [excimer.btrace.agent :as btagent]
            [excimer.btrace.connection :as btconn]
            [excimer.btrace.commands :as btcom])
  (:import [java.io File]
           [org.apache.commons.io IOUtils]))

(defonce ^{:doc "Refer to [[excimer.btrace.agent/load-agent]]."}
  load-agent btagent/load-agent)

(defonce ^{:doc "Refer to [[excimer.btrace.connection/btrace-connection]]."}
  btrace-connection btconn/btrace-connection)

(defonce ^{:doc "Refer to [[excimer.btrace.connection/new-connection]]."}
  new-btrace-connection btconn/new-connection)

(defonce ^{:doc "Refer to [[excimer.btrace.connection/close-connection]]."}
  close-btrace-connection btconn/close-connection)

(defn instrument-jvm
  "Submit a class to the btrace-agent. The class must be compiled with the
   btrace compiler, `btracec`."
  ([class-file-path]
    (if-some [conn (deref btconn/btrace-connection)]
      (instrument-jvm conn class-file-path)
      (println "Need to create a new connection")))
  ([conn class-file-path]
    (let [class-file (File. class-file-path)]
      (if (.exists class-file)
        (let [{:keys [sock ois oos]} conn
              bytecode (IOUtils/toByteArray (io/input-stream class-file-path))
              ic (btcom/instrument-command bytecode [])]
          (btcom/writebytes ic oos))
        (println class-file-path "doesn't exist or a wrong path is given")))))

(defn stop
  "Stop the instrumentation started by [[instrument-jvm]]."
  []
  (when-some [conn (deref btconn/btrace-connection)]
    (close-btrace-connection conn)))
