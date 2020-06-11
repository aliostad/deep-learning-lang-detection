(ns leiningen.pedestal
  (:require [leiningen.help :as help]
            [leiningen.pedestal.war :refer (war)]
            [leiningen.pedestal.uberwar :refer (uberwar)]))

;; [leinjacker.deps :as deps]
;; (deps/add-if-missing project '[ring/ring-servlet "1.1.6"]) ;; we can auto create a jetty starter

(defn pedestal
  "Manage auxiliary tasks for Pedestal projects."
   {:help-arglists '([war uberwar])
    :subtasks  [#'war #'uberwar]}
  ([project]
   (println (help/help-for "pedestal")))
  ([project subtask & args]
   (case subtask
     "war"      (apply war project args)
     "uberwar"  (apply uberwar project args)
                (println "Subtask not found:" subtask "\n"
                  (help/subtask-help-for *ns* #'pedestal)))))

