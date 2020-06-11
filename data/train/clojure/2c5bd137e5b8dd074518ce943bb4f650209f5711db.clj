(ns solr-loader3.db
  "db functions for loader to manage connection pools and execute SQL"
  (:import com.mchange.v2.c3p0.ComboPooledDataSource)
  (:require
   [taoensso.timbre :as timbre]
   [clojure.java.jdbc :as j]
   [clojure.tools.cli :refer [parse-opts]])
  )

(timbre/refer-timbre)
;; global db-ds atoms
(def db-spec (atom nil))
(def db-pool (atom nil))

(defn pool
  "creates a database connection pool for in put spec"
  [spec]
  (let [cpds (doto (ComboPooledDataSource.)
               (.setDriverClass (:classname spec)) 
               (.setJdbcUrl (str "jdbc:" (:subprotocol spec) ":" (:subname spec)))
               (.setUser (:user spec))
               (.setPassword (:password spec))
               ;; expire excess connections after 30 minutes of inactivity:
               (.setMaxIdleTimeExcessConnections (* 30 60))
               ;; expire connections after 3 hours of inactivity:
               (.setMaxIdleTime (* 3 60 60)))] 
    {:datasource cpds}))

(defn initialize-db
  "initializes db spec for config; currently hardwired to oracle DB"
  [config]
  (let [{:keys [host port user password service-name]} config
        subname (str "@//" host ":" port "/" service-name)
        spec     {:classname "oracle.jdbc.OracleDriver"
                  :subprotocol "oracle:thin"
                  :subname subname
                  :user user
                  :password password}]
    (debug "spec:" spec)
    (reset! db-spec spec)
    (reset! db-pool (pool @db-spec))
    spec))

(defn close-db
  "closes all connections"
  []
  (.close (:datasource @db-pool)))

(defn test-connection
  "tests connection parameters in config file"
  []
  (let [test-sql "select count(*) as tabcount from tab"
        tcount (-> (j/query @db-pool [test-sql])
                   first
                   :tabcount)]
    (println tcount "tables in database"))
  )

(defn sample-entity
  "reads entity in configuration and returns first 5 records"
  [entity]
  (let [{:keys [name sql]} entity
        num-sample-records 5
        rs-fn #(into [] (take num-sample-records %))]
    (j/query @db-pool sql
             :result-set-fn rs-fn)))

(defn print-entity-records
  "prints entity records"
  [records]
  (doseq [rec records]
    (println rec)))

(defn process-entity-rows
  "processes entity records using the supplied row function;
   entities are processed as side effects, the function returns nil"
  [row-fn entity]
  (let [{:keys [name sql]} entity]
    (j/query @db-pool sql
             :result-set-fn dorun
             :row-fn row-fn)))
