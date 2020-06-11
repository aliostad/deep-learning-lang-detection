(ns cljreplagent.core
  (:require [clojure.tools.nrepl.server :refer [start-server stop-server]])
  (:import [java.lang.instrument Instrumentation])
  (:gen-class
   :prefix "-"
   :methods [^{:static true} [premain [String java.lang.instrument.Instrumentation] void]]
   :name cljreplagent.core.CljReplAgent))

(def server (atom nil))

(defn -premain
  "Start a remote repl server on jvm startup"
  [^String _ ^Instrumentation _]
  (let [port (System/getProperty "nrepl-port" "4567")]
    (reset! server (start-server :port (Integer/parseInt port)))
    (println (str "NREPL is listening on port " port))))
