(ns clojbot.db
  (:require [clojure.java.jdbc     :as db ]
            [java-jdbc.sql         :as sql]
            [clojure.edn           :as edn]
            [clj-time.core         :as   t]
            [clj-time.coerce       :as   c]
            [clojure.tools.logging :as log]
            [clojure.java.io       :as  io]
            [clojbot.utils         :as   u]
            [clojure.java.jdbc :as jdbc]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuring postgres:                                                           ;;
;; ---------------------                                                           ;;
;; sudo apt-get update                                                             ;;
;; sudo -i -u postgres                                                             ;;
;; sudo apt-get install postgresql postgresql-contrib                              ;;
;; createuser --interactive                                                        ;;
;; --> Create a user with the username that you will run the bot as (christophe)   ;;
;; createdb clojbot                                                                ;;
;; psql -d clojbot (as user that runs Clojbot to manage db)                        ;;
;; sudo -i -u postgres                                                             ;;
;; psql -U postgres template1 -c "alter user christophe with password 'pAssword!'" ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;==============================================================================
;;; Inner functions
;;;==============================================================================

(defn read-db-config
  "Reads in the configuration file from the conf/db.edn file. Returns
  a map that can be used with sql."
  []
  (u/read-config "db.edn"))


(defn table-exists?
  "Checks if a table exists, given the keyword name (e.g., :foo)"
  [table-name]
  (:name
   (first
    (db/query (read-db-config)
               ["SELECT name FROM sqlite_master WHERE type='table' AND name=?"
                (name table-name)]))))


(defn create-table
  "Creates table with the given name as keyword and a list of fields
  for the table."
  [name & fields]
  (let [db  (read-db-config)
        ddl (apply (partial  db/create-table-ddl name) fields)]
    (when-not (table-exists? name)
      (db/db-do-commands
       db
       ddl))))


(defn query-db 
  "Runs a query against the database. Expects a simple SQL query."
  [query]
  (jdbc/query (read-db-config) query))
