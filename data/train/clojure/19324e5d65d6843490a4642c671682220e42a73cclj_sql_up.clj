(ns leiningen.clj-sql-up
  (:require [cemerick.pomegranate :as pome]
            [clj-sql-up.create  :as create]
            [clj-sql-up.migrate :as migrate]))

(defn get-database
  "fetch database connection info given project.clj options hash"
  [opts]
  (let [db-env (System/getenv "ENV")
        db-str (if db-env (str "database-" db-env) "database")]
    ((keyword db-str) opts)))

(defn clj-sql-up
  "Simply manage sql migrations with clojure/jdbc

Commands:
create name      Create migration (eg: migrations/20130712101745082-<name>.clj)
migrate          Run all pending migrations
rollback n       Rollback last n migrations (n defaults to 1)"

  ([project] (println (:doc (meta #'clj-sql-up))))
  ([project command & args]
     (let [opts (:clj-sql-up project)
           db   (get-database opts)
           repos (merge {"central" "http://repo1.maven.org/maven2/"}
                        {"clojars" "http://clojars.org/repo"}
                        (:repos opts))]
       (pome/add-dependencies :coordinates (:deps opts)
                              :repositories repos)
       (cond
        (= command "create")   (create/create args)
        (= command "migrate")  (migrate/migrate  db)
        (= command "rollback") (migrate/rollback db (first args))))))
