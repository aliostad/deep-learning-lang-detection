(ns benefix.core
  (:gen-class)
  (:require [clojure.tools.logging :as log]
            [clojure.java.io :as io]
            [benefix.kafka :as k]
            [clojure.edn :as edn]
            [com.stuartsierra.component :as component])
  (:gen-class))


(import java.io.PushbackReader)


;; # Benefix
;; Benefix is a Clojure-based FIX engine, that uses the QuickFix/J library to connect, manage,
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

(defn- system-exit
  "Log a message and exit with the specified status"
  [status message]
  (log/error message)
  (System/exit status))

;; ## Components and systems
;;
;; We're using Stuart Sierra's excellent Component library to do dependency injection, and to demarcate the
;; boundaries between the largest behavioral blocks in our code, in order to facilitate easier unit testing in the
;; future. We here define the "system" that specifies how the dependencies between components should be autowired.

(defn benefix-system
  "This sytem specifies all the component dependencies that comprise Benefix"
  [config-options]
  (let [{:keys [kafka-config]} config-options]
    (component/system-map
     :kafka-consumer (k/new-kafka-consumer kafka-config))))

;; We use Clojure's extensible data notation (EDN) to describe the config options that initialise
;; all the components. That gives us a single central reference point for all config, and pointers
;; from there to any additional config we need, e.g. Quickfix/J config files.

(defn- start-system-from-edn
  "Reads a specified .edn file and uses it to start the system using the read object"
  [config-file]
  (with-open [config-reader (PushbackReader. (io/reader config-file))]
    (log/info "Starting with config options found at" config-file)
    (def system (benefix-system (edn/read config-reader) ))
    (alter-var-root #'system component/start)))

(def shutdown? (promise))

(defn -main
  "Main entrypoint for the app. Begins the process of connecting to ZooKeeper and Storm
  and bootstraps the FIX connections, and logs any messages/events which happen to FIX sessions"
  [& args]
  (when-let [config-file (args 0)]
    (start-system-from-edn config-file))
  (@shutdown?))
