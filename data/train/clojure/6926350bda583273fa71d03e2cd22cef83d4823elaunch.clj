(ns dev-helpers.launch
  (:require [org.httpkit.server :as server]
            [clojure.tools.logging :as log]
            [dev-helpers.profiling :as profiling]
            [objective8.core :as core]
            [objective8.config :as config]
            [objective8.back-end.storage.database :as db]))

;; Launching / relaunching / loading
(defonce the-system nil)

(defn- start-back-end-server [system]
  (let [api-port (:api-port system)
        server (server/run-server (core/back-end-handler) {:port api-port :thread 4})]
    (prn "Starting api server on port: " api-port)
    (assoc system :back-end-server server)))

(defn- stop-back-end-server [system]
  (when-let [srv (:back-end-server system)]
    (srv))
  (dissoc system :back-end-server))

(defn- start-front-end-server [system]
  (let [conf (:config system)
        front-end-port (:front-end-port system)
        server (server/run-server (core/front-end-handler conf) {:port front-end-port :thread 4})]
    (prn "Starting front-end server on port: " front-end-port)
    (assoc system :front-end-server server)))

(defn- stop-front-end-server [system]
  (when-let [srv (:front-end-server system)]
    (srv))
  (dissoc system :front-end-server))

(defn- init
  ([system]
   (init system {:app-config core/app-config}))

  ([system {:keys [app-config profile?] :as conf}]
   (let [db-connection (db/connect!)]
     (core/initialise-api)
     (assoc system
            :config app-config
            :profiling profile?
            :front-end-port (:front-end-port config/environment)
            :api-port (:api-port config/environment)
            :db-connection db-connection))))

(defn- instrument [system]
  (when (:profiling system)
    (profiling/instrument (:profiling system)))
  system)

(defn- clear-profiling [system]
  (when (:profiling system)
    (profiling/clear (:profiling system)))
  system)

(defn- make-launcher [config-name launcher-config]
  (fn []
    (alter-var-root #'the-system #(-> %
                                      (init launcher-config)
                                      instrument
                                      start-front-end-server
                                      start-back-end-server))
    (log/info (str "Objective8 started\nfront-end on port: " (:front-end-port the-system)
                   "\napi on port:" (:api-port the-system)
                   " in configuration " config-name))))

(defn stop []
  (alter-var-root #'the-system #(-> %
                                    stop-back-end-server
                                    stop-front-end-server
                                    clear-profiling))
  (log/info "Objective8 server stopped."))

(defn make-launcher-map [configs]
  (doall 
   (apply merge
          (for [[config-kwd config] configs]
            (let [config-name (name config-kwd)
                  launcher-name (str "start-" config-name)]

              (intern *ns* 
                      (symbol launcher-name) 
                      (make-launcher config-name config))

              {config-kwd (symbol (str "user/" launcher-name))})))))
