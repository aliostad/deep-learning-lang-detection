(ns policyj.application
  (:use [clojure.tools.cli :refer (parse-opts)])
  (:require [policyj.config :as cfg]
            [policyj.server :as server]
            [policyj.policies.pass-through  :as p-passthrough]
            [policyj.policies.dns.blacklist :as p-dns-blacklist]
            [policyj.policies.db.cache      :as cache]
            [policyj.policies.db.blacklist  :as p-db-blacklist]
            [policyj.policies.db.whitelist  :as p-db-whitelist]
            [policyj.policies.unknown       :as p-unknown]
            [policyj.policies :as p]
            [policyj.monitoring.server :as monitoring]
            [policyj.logging.logger :as log])
  (:import (java.io File))
  (:gen-class :main true))

(def cli-options
  [["-c" "--config FILE" "Load configuration file from this path" :default "/etc/policyj.conf"]
   ["-h" "--help" "Show this help" :flag true :default false]
   ["-n" "--noop" "Allways returns dunno, while logging which response would've been given." :flag true :default false]
   ["-d" "--debug" "Debug mode" :flag true :default false]])

(defn usage [option-summary]
  (->> ["Policyj - Postfix policy server"
        ""
        "Usage: policyj [options]"
        ""
        "Options:"
        option-summary
        ""]
       (clojure.string/join \newline)))

(defn error-msg [errors]
  (str "Your command line arguments contained errors: \n\n"
       (clojure.string/join \newline errors)))

(defn exit [status msg]
  (println msg)
  (System/exit status))

(defn expand-path [path]
  (.getCanonicalPath (File. path)))

(defn file-exists? [path]
  (.exists (File. path)))

(defn setup-policies [policies config]
  (doseq [policy policies]
    (let [setup-fn (:setup policy)
          policy-cfg (cfg/get config [(:id policy)] {})]
      (when setup-fn
        (log/jot :info { :event :policy-setup :policy-id  (:id policy) })
        (setup-fn policy-cfg)))))

(defn start-monitoring-server [config]
  (.start
   (Thread.
    (fn []
      (monitoring/start (get config :address "127.0.0.1")
                        (get config :port 1338))))))

(defn start [options summary]
  (try
    (let [configfile (:config options)]
      (when-not configfile
        (exit 1 "You must supply the configuration file argument"))

      (let [configfile (expand-path configfile)]
        (when-not (file-exists? configfile)
          (exit 2 (str "The configfile-file doesn't seem to exist at: " configfile))))

      (let [app-config (cfg/load-configuration-from configfile)]
        ;;verify config
        (log/jot :debug (str "Configuration loaded from: " configfile))

        (let [policies [p-db-whitelist/policy p-db-blacklist/policy p-dns-blacklist/policy]]
          ;;run self test
          (setup-policies policies (cfg/get app-config [:policies] {}))

          ;; start control connection to manage the server

          ;; start monitoring server
          (start-monitoring-server (cfg/get app-config [:monitoring] {}))

          ;; start server
          (server/start (cfg/get app-config [:server :address] "127.0.0.1")
                        (cfg/get app-config [:server :port] 1337)
                        (cfg/get app-config [:server :backlog] 50)
                        (p/compile-handler policies (cfg/get app-config [:policies] {}) :noop (options :noop))))))

    (catch Exception e
      (log/jot :error { :event :application-start } e)
      (.printStackTrace e)
      (exit 3 (.getMessage e)))))

(defn -main [& args]
  (let [{ :keys [options arguments errors summary]} (parse-opts args cli-options)]
    (cond
     (:help options) (exit 0 (usage summary))
     errors (exit 1 (error-msg errors)))
    (start options summary)))
