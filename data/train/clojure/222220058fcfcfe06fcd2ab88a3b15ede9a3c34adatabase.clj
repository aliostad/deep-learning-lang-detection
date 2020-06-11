(ns cdc-util.components.database
  "A component to manage (pooled) database connections using HikariCP.

  Defaults to using the Oracle Thin driver for connections with a
  min/max pool size of 2/20 connections."
  (:require [com.stuartsierra.component :as component]
            [hikari-cp.core :as hk]
            [cdc-util.env :refer [env->config]]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defaults

(def default-options
  (merge
   hk/default-datasource-options
   {:auto-commit true
    :read-only false
    :minimum-idle 2
    :maximum-pool-size 20
    :adapter "oracle"
    :driver-type "thin"
    :port-number 1521
    :implicit-caching-enabled true
    :max-statements 200}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Component

(defrecord Database [options]
  component/Lifecycle
  (start [this]
    (let [o (merge default-options options)
          ds (hk/make-datasource o)]
      (assoc this :options o :datasource ds)))
  (stop [this]
    (if-let [ds (:datasource this)]
      (hk/close-datasource ds))
    (dissoc this :datasource)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public

(defn new-database
  "Returns a new, un-started, database component.

  Must be provided with a map of datasource options specifying, at a
  minimum, the:

  * `:database-name`
  * `:server-name`
  * `:username`
  * `:password`"
  [opts]
  (component/using (->Database opts) []))

(defn env->database-opts
  "Returns a map of component options derived from the given
  environment variable map.

  The supported env variables are:

  * `:db-name` (`DB_NAME`)
  * `:db-server` (`DB_SERVER`)
  * `:db-user` (`DB_USER`)
  * `:db-password (`DB_PASSWORD`)"
  [env]
  (env->config env [[:db-name :database-name]
                    [:db-server :server-name]
                    [:db-user :username]
                    [:db-password :password]]))

(defn new-database-from-env
  "Returns a new, un-started, database component initialized with
  options from the given map of environment variables (per
  `env->database-opts`.)"
  [env]
  (new-database (env->database-opts env)))
