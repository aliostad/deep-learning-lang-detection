(ns leiningen.worker
  "Build and upload IronWorker .worker files and corresponding uberjar"
  (:require
    [leiningen.worker.internal :refer :all]))

(defn prepare
  "Preapre a workerfile and uberjar"
  [project args]
  (-> project jar-info prepare-worker)
  (println "PREPARE COMPLETE")
  project)

(defn run
  "Run remote worker on IronWorker"
  [project args]
  (prn "not implemented yet")
  project)

(defn
  ^{:help-arglists '([payload])}
  run-local
  "Run the worker locally"
  [project args]
  (->> project jar-info (run-local-worker args))
  project)

(defn upload
  "Upload uberjar to IronWorker"
  [project args]
  (-> project jar-info upload-worker)
  (println "DONE\nManage your worker at https://hud.iron.io/dashboard")
  project)

(defn default
  [project args]
  (prepare project args)
  (upload project args))

(defn missing-subtask
  [sub]
  (fatal
    "lein worker does not have a `%s` subtask.\nRun `lein help worker` to see all available subtasks"
    sub))

(defn
  ^{:subtasks [#'run #'prepare #'upload #'run-local]
    :help-arglists '[[run] [prepare] [upload] [run-local]]
    :doc "Default behavior for `lein worker` will prepare a workerfile and uberjar then upload it to IronWorker.
Use available subtasks for more fine-grained control."}
  worker
  [project & [sub & args]]
  (if (:root project)
    (if sub
      (let [f (case sub
                "run-local" run-local
                "run" run
                "upload" upload
                "prepare" prepare
                (missing-subtask sub))]
        (f project args))
      (default project args))
    (fatal "Must be run in the root of a Leiningen project.")))
