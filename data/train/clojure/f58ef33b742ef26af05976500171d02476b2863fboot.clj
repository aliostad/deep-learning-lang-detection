(ns triweb.boot
  (:gen-class)
  (:require [clojure.edn :as edn]
            [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as spec.test]
            [triweb.http :as http]
            [triweb.time :as time]))

(Thread/setDefaultUncaughtExceptionHandler
 (reify Thread$UncaughtExceptionHandler
   (uncaughtException [_ thread ex]
     (locking #'println
       (println "uncaught exception on" (.getName thread) "at" (time/now))
       (println ex)
       (when-let [data (ex-data ex)]
         (when (:die data)
           (flush)
           (shutdown-agents)
           (System/exit 1)))))))

(defn -main [& [conf]]
  (when (System/getenv "DEV")
    (spec.test/instrument))
  (println "starting web server")
  (http/run
    (merge
     {}
     (when conf
       (println "using local config" conf)
       (-> conf slurp edn/read-string)))))
