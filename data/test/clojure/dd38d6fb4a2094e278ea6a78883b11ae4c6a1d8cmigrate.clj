(ns clams.migrate
  "Database migrations management alternative main/entry-point.
  This is runnable using `lein run -m clams.migrate` or compiled using
  `java -cp uberjar.jar clams.migrate`. See usage below for more details.

  For SQL migrations:
  - Add a database-url config entry
  - Place migrations in resources/migrations with an `up` and `down`
    migration.  The migrations will be run in the lexical order by file
    name.  Each file should be named `PREFIX.{up,down}.sql`.  For
    example `001-foo.up.sql`
  - The migrations should contain pure SQL.
  - Also see  https://github.com/weavejester/ragtime/wiki/Getting-Started

  For Mongo migrations:
  - Add a mongo-url config entry
  - Place migrations in resources/migrations with an `up` and `down`
    migration.  The migrations will be run in the lexical order by file
    name.  Each file should be named `PREFIX.{up,down}.mongoclj`.  For
    example `001-foo.up.mongoclj`
  - The migrations should contain Clojure code where each migration
    is responsible for connecting to the mongo instance itself.
  - Also see  https://github.com/weavejester/ragtime/wiki/Getting-Started
  "
  (:require
   [conf.core :as conf]
   [clams.util :refer [str->int]]
   [monger.core :as mg]
   monger.ragtime                       ; Force load of Mongo ragtime/Migratable code
   [ragtime.jdbc :as jdbc]
   [ragtime.repl :as repl]
   ragtime.strategy)
  (:import
   [java.io File])
  (:gen-class))

;;; Mongo migration interface
;;;
;;; A replication of the Ragtime jdbc code to support our mongo
;;; migrations.  Mongo migrations are just Clojure files that are
;;; executed by Ragtime.
;;;

(let [pattern (re-pattern (str "([^" File/separator "]*)" File/separator "?$"))]
  (defn- basename [file]
    (second (re-find pattern (str file)))))

(defn- remove-extension [file]
  (second (re-matches #"(.*)\.[^.]*" (str file))))

;; We are using the .mongoclj extension
(defn- mongoclj-file-parts [file]
  (rest (re-matches #"(.*?)\.(up|down)(?:\.(\d+))?\.mongoclj" (str file))))

(defn- gen-load-fn
  "Generate a function the loads the mongo migrations.  The migration
   is responsible for connecting to the mongo instance."
  [urls]
  (fn [_]
    (doseq [u urls]
      (load-string (slurp u)))))

(defmethod jdbc/load-files ".mongoclj" [files]
  (for [[id files] (group-by (comp first mongoclj-file-parts) files)]
    (let [{:strs [up down]} (group-by (comp second mongoclj-file-parts) files)]
      {:scheme :mongo
       :id (basename id)
       :up (gen-load-fn up)
       :down (gen-load-fn down)})))

;;;
;;; Run migrations
;;;

(defn- load-resources []
  (sort-by :id (jdbc/load-resources "migrations"))  )

(defn- mongo-config
  "The config only exists if the database exists and there are
   relevant migrations."
  []
  (when-let [url (conf/get :mongo-url)]
    (let [ms (filter #(= :mongo (:scheme %)) (load-resources))]
      (when (seq ms)
        {:database (:db (mg/connect-via-uri url))
         :migrations ms}))))

;; Convert a Heroku jdbc URL
(defn- format-jdbc-url
  "If it's a Heroku postgres URL, we tweak it to be a format that
   ragtime accepts.  Otherwise we leave it alone."
  [url]
  (let [u (clojure.string/replace url
                                  #"^postgres\w*://([^:]+):([^:]+)@(.*)"
                                  "jdbc:postgresql://$3?user=$1&password=$2")]
    (if (re-find #"[?]" u)
        u
        (str u "?_ignore=_ignore"))))

(defn- sql-config []
  "The config only exists if the database exists and there are
   relevant migrations."
  (when-let [url (conf/get :database-url)]
    (let [ms (remove :scheme (load-resources))] ; No scheme means jdbc
      (when (seq ms)
        {:database (jdbc/sql-database {:connection-uri (format-jdbc-url url)})
         :migrations (sort-by :id ms)
         :strategy ragtime.strategy/apply-new}))))

(defn- run-migrations
  ([f] (run-migrations f nil))
  ([f n]
   (doseq [config [(sql-config) (mongo-config)]]
     (when config
       (if n
           (f config n)
           (f config))))))

(def usage
  "Manage database migrations.

Usage: lein run -m clams.migrate <COMMAND> <ARGS>

Commands:
  migrate           Migrate to the latest version
  rollback [n]      Rollback n versions (defaults to 1)")

(defn -main
  "Run the migrations or rollbacks"
  [& args]
  (println "Running migrations")
  (case (first args)
    "migrate" (run-migrations repl/migrate)
    "rollback" (if-let [n (second args)]
                 (run-migrations repl/rollback (str->int n))
                 (run-migrations repl/rollback))
    (do (println usage)
        (System/exit 1))))
