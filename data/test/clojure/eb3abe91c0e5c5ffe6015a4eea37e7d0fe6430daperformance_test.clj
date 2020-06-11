(ns overseer.performance-test
  (:require [clojure.test :refer :all]
            [clj-time.format :as f]
            [clojure.java.shell :as sh]
            [goat.core :as goat]
            [clj-time.local :as l]
            [clj-time.core :as t]
            [clj-time.coerce :as c]
            [clojure.tools.trace :as trace]
            [overseer.database.connection :as conn]
            [overseer.db :as d]
            [overseer.queries :as queries]
            [overseer.attendance :as att]
            [overseer.helpers :as h]
            [overseer.helpers-test :as testhelpers]
            [overseer.dates :as dates]
            [overseer.database.connection :refer [pgdb]]
            [overseer.database.users :as users]
            [overseer.migrations :as migrations]
            [overseer.db :as db]
            [overseer.commands :as cmd]
            [clojure.java.jdbc :as jdbc]
            [clojure.pprint :refer :all]
            ))

(defn migrate-test-db []
  ;;(jdbc/execute! @pgdb [(str "DELETE FROM schema_migrations where 1=1; ")])
  (jdbc/execute! @pgdb [(str "DROP TABLE schema_migrations")])
  (migrations/migrate-db @pgdb)
  (jdbc/execute! @pgdb [(str "DELETE FROM users where 1=1; ")])
  (users/init-users))

(defn collect-timing []
  (goat/clear-perf-data!)
  (let [x (att/get-student-with-att 1)
        stu (first x)
        perf (goat/get-fperf-data)]
    (testing "days all came back" (is (= 199 (count (:days stu)))))
    (:total-time (get perf 'overseer.queries/get-student-page))))

(defn ^:performance massive-timing []
  (conn/init-pg)
  (users/drop-all-tables)
  (sh/sh "make" "load-massive-dump")
  (migrate-test-db)
  (cmd/make-year (str (t/date-time 2014 6)) (str (t/plus (t/now) (t/days 9))))
  (let [students (queries/get-students)]
    (doall (map #(cmd/add-student-to-class (:_id %) 1)
                students)))
  (let [students (time (att/get-student-list))]
    (testing "found all students" (is (= 80 (count students)))))

  (goat/reset-instrumentation!)
  (goat/instrument-functions! 'overseer.attendance)
  (goat/instrument-functions! 'overseer.db)
  (goat/instrument-functions! 'overseer.queries)
  (goat/instrument-functions! 'overseer.database)

  #_(goat/get-top-fperf 15 )

  (let [run-size 50
        runs (map (fn [x] (collect-timing)) (range run-size))
        average-time (int (/ (apply + (trace/trace "runs" runs)) run-size))]
    (testing "its fast too"
      (is (> 250 average-time))))

  (goat/reset-instrumentation!)

  )

