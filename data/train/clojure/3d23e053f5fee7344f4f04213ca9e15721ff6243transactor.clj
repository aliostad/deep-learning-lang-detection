(ns pregres.transactor
  "Protocols and helpers to manage data with transactions"
  (:require
   [clojure.java.jdbc :as jdbc]
   [clojure.string :as str]
   [pregres.core.utils :as utils]
   [pregres.db :as db]
   [clj-time.jdbc])
  (:import
   [java.sql Timestamp]
   [java.util Date UUID]))

(defmacro with-transaction
  "(with-db-transaction [txn db-config]
    ... txn ...)"
  [binding & body]
  `(jdbc/with-db-transaction ~binding ~@body))

(defmacro with-read-only-transaction
  "(with-db-transaction [txn db-config]
    ... txn ...)"
  [binding & body]
  `(jdbc/with-db-transaction ~(into binding [:read-only? true]) ~@body))

(defmacro with-test-transaction
  "Tests in a Transaction block., but rolls back after txns.
   Useful for tests and ad-hoc reports"
  [[txn maybe-spec] & body]
  (let [spec (or maybe-spec (db/connect))]
    `(jdbc/with-db-transaction [~txn ~spec]
       (try
         ~@body
         (finally
           (reset! (:rollback ~txn) true))))))


