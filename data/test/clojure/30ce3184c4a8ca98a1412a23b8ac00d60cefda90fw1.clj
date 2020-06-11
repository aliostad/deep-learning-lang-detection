(ns leiningen.fw1
  (:require [leiningen.fw1.new :as nnew])
  (:use [leiningen.help :only (help-for)]))

(defn new [& [proj-name]]
  (if-not proj-name
    (println "No project name given:\r\n~    lein fw1 new my-website")
    (nnew/create proj-name)))

(defn fw1
  "Create and manage FW/1 projects."
  {:help-arglists '([new])
   :subtasks [#'new]}
  ([]
     (println (help-for "fw1")))
  ([subtask & args]
     (case subtask
       "new"     (apply leiningen.fw1/new args)
       (println (help-for "fw1"))
       )))
