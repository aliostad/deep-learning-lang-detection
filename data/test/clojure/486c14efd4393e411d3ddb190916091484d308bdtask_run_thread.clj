(ns wfeditor.io.status.task-run-thread
  (:require
   [wfeditor.io.util.thread :as thread-util]
   [wfeditor.io.util.const :as io-const]
   [wfeditor.io.status.task-run :as task-status]
   [wfeditor.ui.gui.left.general-tab :as general-tab]))


;;
;; futures - background threads (declarations here, initial bindings below)
;;

;; using futures to handle execution of repeating background threads
;; in Clojure as suggested by these Stackoverflow posts
;; http://stackoverflow.com/questions/5291436/idiomatic-clojure-way-to-spawn-and-manage-background-threads
;; http://stackoverflow.com/questions/5397955/sleeping-a-thread-inside-an-executorservice-java-clojure
;; http://stackoverflow.com/questions/1768567/how-does-one-start-a-thread-in-clojure

(declare status-updater-thread)

(declare status-output-thread)

(declare status-from-server-updater-thread)


;;
;; futures - background threads - initial bindings, related fn's
;;


;; status-updater-thread - server

(defn- create-bg-thread-status-updater-thread
  "return a future that encapsulates an auto-repeating background thread that updates the global job statuses"
  []
  (thread-util/do-and-sleep-repeatedly-bg-thread io-const/DEFAULT-REPEATED-BG-THREAD-SLEEP-TIME task-status/update-global-statuses "SGE"))

(defn init-bg-thread-status-updater-thread
  "initialize the var with a future containing the background thread that updates the global job statuses"
  []
  (def status-updater-thread (create-bg-thread-status-updater-thread)))

(defn stop-bg-thread-status-updater-thread
  "stop the future that encapsulates the background thread for updating global job statuses"
  []
  (future-cancel status-updater-thread))


;; status-output-thread - server & client

(defn- create-bg-thread-status-output-thread
  "return a future that encapsulates an auto-repeating background thread that saves the global job statuses to disk"
  []
  (thread-util/do-and-sleep-repeatedly-bg-thread (* 60 1000) task-status/statuses-to-file))

(defn init-bg-thread-status-output-thread
  "initialize the var with a future containing the background thread that saves the global job statuses to disk"
  []
  (def status-output-thread (create-bg-thread-status-output-thread)))

(defn stop-bg-thread-status-output-thread
  "stop the future that encapsulates the background thread that saves the global job statuses to disk"
  []
  (future-cancel status-output-thread))


;; status-from-server-updater-thread - client

(defn- create-bg-thread-status-from-server-updater-thread
  "return a future that encapsulates an auto-repeating background thread that updates the global job statuses from status info on the server"
  []
  (thread-util/do-and-sleep-repeatedly-bg-thread-try-catch #(do ( println "error in status from server updater bg thread: " (.getMessage %))) (fn [] ) (* 30 1000) general-tab/update-job-statuses-from-server))

(defn init-bg-thread-status-from-server-updater-thread
  "initialize the var with a future containing the background thread that updates the global job statuses from status info on the server"
  []
  (def status-from-server-updater-thread (create-bg-thread-status-from-server-updater-thread)))

(defn stop-bg-thread-status-from-server-updater-thread
  "stop the future that encapsulates the background thread that updates the global job statuses from status info on the server"
  []
  (future-cancel status-from-server-updater-thread))