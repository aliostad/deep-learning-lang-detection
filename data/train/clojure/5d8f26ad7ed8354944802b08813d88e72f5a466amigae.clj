(ns leiningen.migae
  "migae - a leiningen plugin for configuring and deploying migae apps.

To create a new migae app, use the standard leiningen 'new' task
with the magic template, like so:

    $ lein new migae <myproj>:<gae-app-id> /path/to-sdk

Once you have created the app, you can use standard leiningen 'compile',
'jar', 'uberjar' to deal with your clojure code.  They use the
standard :target-path to decide where to put the jar.  This plugin also supports subtasks clean, config, libdir, and deploy."
  (:import java.io.File
           ;; com.google.appengine.tools.admin.AppCfg
           ;; [org.apache.commons.exec CommandLine DefaultExecutor]
           )
  (:require [leiningen.migae.clean :as clean]
            [leiningen.migae.config :as config]
            [leiningen.migae.deploy :as deploy]
            ;; [leiningen.migae.gserver :as gserver]
            ;; [leiningen.migae.jetty :as jetty]
            [leiningen.migae.libdir :as libdir]
            [leiningen.migae.mvn :as mvn]
            ;; [leiningen.migae.repl :as repl]
            [leiningen.migae.run :as run]
            [leiningen.migae.version :as version]
            [clojure.tools.cli :as cli]
            [clojure.tools.logging :as log :only [debug info]]))

  ;; (:use [leiningen.new.templates :only [project-name
  ;;                                       renderer multi-segment
  ;;                                       sanitize-ns name-to-path
  ;;                                       year ->files]]))

(try ; Leiningen 2.0 compatibility
  (use '[leiningen.core :only [abort]])
  (catch Exception _
    (use '[leiningen.core.main :only [abort]])))

(defn migae-test [project & args]
  (println "ok"))

;; cribbed from heroku plugin:

(def ^{:private true} cli-options
  ["-a" "--app" "App to use if not in project dir."])

(defn- task-not-found [& _]
  (abort "That's not a task. Use \"lein migae help\" to list all subtasks."))

;; like leiningen.core, but with special subtask handling for colon-grouping
(defn- resolve-task
  ([task not-found]
     (let [task-ns (symbol (str "leiningen.migae." (first (.split task ":"))))
           task (symbol task)]
       (try
         (when-not (find-ns task-ns)
           (require task-ns))
         (or (ns-resolve task-ns task)
             not-found)
         (catch java.io.FileNotFoundException e
           not-found))))
  ([task] (resolve-task task #'task-not-found)))

(defn #^{:subtasks [#'clean/clean
                    #'config/config
                    #'deploy/deploy
                    #'libdir/libdir
                    #'mvn/mvn
                    ;; #'gserver/gserver
                    ;; #'jetty/jetty
                    ;; #'repl/repl
                    #'run/run
                    #'version/version
                    ]}
  migae
  "manage migae app"
  [project cmd & args]
  (let [subtask (resolve-task (or cmd "help"))
        command cmd]
    (try
      ;; (binding [util/*app* nil] ;;(:app opts)]
        (apply subtask project args)
      (catch Exception e
        (abort (or (.getMessage e) (pr e)))))))

;;   [project & args]
;;   (let [parms (map #(read-string %) args)]
;;     (cond
;;      (some #{:config} parms) (config project args)
;;      (some #{:deploy} parms) (deploy/deploy project args)
;;      (some #{:test} parms)    (migae-test project args)
;;       :else (println "Usage: lein migae <subtask>
;;     subtasks: :config, :deploy
;; See 'lein help migae'."))))


