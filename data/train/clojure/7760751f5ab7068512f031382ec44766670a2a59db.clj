(ns bluemoon.component.db
  (:refer-clojure :exclude [update])
  (:require [com.stuartsierra.component :as component]
            [korma.core :refer :all]
            [korma.config :refer :all]
            [korma.db :refer [create-db]]
            [camel-snake-kebab.core :refer :all])
  (:import [com.zaxxer.hikari HikariConfig HikariDataSource]))

;; Entities
;; TODO: Manage entities as component.
(defentity project)
(defentity member)
(defentity project_member)
(defentity task)
(defentity calendar_date)
(defentity member_calendar_date)

(defn- make-config
  [{:keys [uri username password auto-commit? conn-timeout idle-timeout
           max-lifetime conn-test-query min-idle max-pool-size pool-name]}]
  (let [cfg (HikariConfig.)]
    (when uri                  (.setJdbcUrl cfg uri))
    (when username             (.setUsername cfg username))
    (when password             (.setPassword cfg password))
    (when (some? auto-commit?) (.setAutoCommit cfg auto-commit?))
    (when conn-timeout         (.setConnectionTimeout cfg conn-timeout))
    (when idle-timeout         (.setIdleTimeout cfg conn-timeout))
    (when max-lifetime         (.setMaxLifetime cfg max-lifetime))
    (when max-pool-size        (.setMaximumPoolSize cfg max-pool-size))
    (when min-idle             (.setMinimumIdle cfg min-idle))
    (when pool-name            (.setPoolName cfg pool-name))
    cfg))

(defn- make-spec [component]
  (let [datasource (HikariDataSource. (make-config component))]
    {:datasource datasource
     :kormadb (create-db {:datasource datasource
                          :make-pool? false})}))

(defrecord DbComponent [uri]
  component/Lifecycle
  (start [component]
         ;; TODO: Manage korma.config/option as component.
         (set-naming {:keys ->kebab-case
                      :fields ->snake_case})
         (if (:spec component)
           component
           (assoc component :spec (make-spec component))))
  (stop [component]
        (if-let [spec (:spec component)]
          (do (.close (:datasource spec))
            (dissoc component :spec))
          component)))

(defn db-component [options]
  {:pre [(:uri options)]}
  (map->DbComponent options))
