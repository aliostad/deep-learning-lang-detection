(ns malefix.core
  (:gen-class)
  (:require [clojure.tools.logging :as log]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.java.io :as io]
            [malefix.quickfix :as fix]
            [clojure.edn :as edn]
            [com.stuartsierra.component :as component]
            [malefix.kafka-producer :as kafka])
  (:gen-class))


(import java.io.PushbackReader)


;; # Malefix
;; Malefix is a Clojure-based FIX engine, that uses the QuickFix/J library to connect, manage,
;; persist, transform and route FIX messages. We use Apache Storm as the streaming infrastructure to
;; give us automatic horizontal scalability as well as fault tolerance. Because of the slightly ugly
;; nature of the Quickfix API, we try to wrap everything to make it feel more Clojure-y.
;; Dependency injection is handle by the Component library.

(defonce default-config-file "config/acceptor.edn")

(def cli-options
  "Allowed CLI options. Currently only allows a config file."
  [["-f" "--config-file FILE" "config file"
    :default default-config-file
    :validate [#(<= 0 (count %)) "Must be a string of non-zero length"]]])

(defn system-exit
  "Log a message and exit with the specified status"
  [status message]
  (log/error message)
  (System/exit status))

;; ## Components and systems
;;
;; We're using Stuart Sierra's excellent Component library to do dependency injection, and to demarcate the
;; boundaries between the largest behavioral blocks in our code, in order to facilitate easier unit testing in the
;; future. We here define the "system" that specifies how the dependencies between components should be autowired.

(defn malefix-system
  "This sytem specifies all the component dependencies that comprise Malefix"
  [config-options]
  (let [{:keys [qfj-config direction producer-config]} config-options]
    (component/system-map
     :producer (kafka/new-producer producer-config)
     :fix-engine (component/using
                  (fix/new-fix-engine qfj-config direction)
                  [:producer]))))

;; We use Clojure's extensible data notation (EDN) to describe the config options that initialise
;; all the components. That gives us a single central reference point for all config, and pointers
;; from there to any additional config we need, e.g. Quickfix/J config files.

(defn read-config
  [config]
  (with-open [config-reader (PushbackReader. (io/reader config))]
    (edn/read config-reader)))

(defn- start-system-from-edn
  "Reads a specified .edn file and uses it to start the system using the read object"
  [config-file]
  (if-let [config (io/as-file config-file)]
    (do
      (log/info "Reading config options found at" config-file)
      (def system (malefix-system (read-config config)))
      (alter-var-root #'system component/start) )
    (log/info "Config file does not exist.")))

(def shutdown? (promise))

(defn -main
  "Main entrypoint for the app. Begins the process of connecting to ZooKeeper and Storm
  and bootstraps the FIX connections, and logs any messages/events which happen to FIX sessions"
  [& args]
  (let [{:keys [options arguments errors summary]} (parse-opts args cli-options)]
    (when errors
      (system-exit 1 errors))
    (start-system-from-edn (:config-file options)))
  (@shutdown?))
