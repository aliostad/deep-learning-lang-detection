;   Copyright (c) Shantanu Kumar. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.


(ns preflex.instrument.jdbc-test
  (:require
    [clojure.test :refer :all]
    [clojure.java.io    :as io]
    [clojure.edn        :as edn]
    [asphalt.core       :as asphalt]
    [clj-dbcp.core      :as dbcp2]
    [preflex.instrument.jdbc :as instru])
  (:import
    [java.sql  Connection]
    [javax.sql DataSource]))


(def config (->> (io/resource "database.edn")
              slurp
              edn/read-string))


(def orig-ds (dbcp2/make-datasource config))


(deftest test-instrument-datasource
  (let [wrapper-state (atom {:conn-create 0
                             :stmt-create 0
                             :sql-execute 0})
        inc-wrapstate (fn [k] (swap! wrapper-state update k inc))
        instru-ds (instru/instrument-datasource orig-ds
                    {:conn-creation-wrapper (fn [context f] (inc-wrapstate :conn-create) (f))
                     :stmt-creation-wrapper (fn [context f] (inc-wrapstate :stmt-create) (f))
                     :sql-execution-wrapper (fn [context f] (inc-wrapstate :sql-execute) (f))})]
    (with-open [^Connection conn (.getConnection ^DataSource instru-ds)]
      (is (= {:conn-create 1
              :stmt-create 0
              :sql-execute 0}
            @wrapper-state) "After connection obtain")
      (asphalt/update instru-ds (:create-ddl config) [])
      (is (= {:conn-create 2
              :stmt-create 1
              :sql-execute 1}
            @wrapper-state) "After DDL Create")
      (asphalt/update instru-ds (:drop-ddl   config) [])
      (is (= {:conn-create 3
              :stmt-create 2
              :sql-execute 2}
            @wrapper-state) "After DDL Drop"))))
