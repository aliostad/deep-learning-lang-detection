;   Copyright (c) Shantanu Kumar. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.


(ns preflex.instrument.jdbc
  (:require
    [preflex.task      :as task])
  (:import
    [java.sql Connection]
    [javax.sql DataSource]
    [preflex.instrument.jdbc
     ConnectionWrapper
     DataSourceWrapper
     JdbcEventFactory]
    [preflex.instrument.task
     Wrapper]))


(defn make-jdbc-event-factory
  "Make a preflex.instrument.jdbc.JdbcEventFactory instance from given event generator options:
  :connection-create     - (fn []) -> event
  :statement-create      - (fn []) -> event
  :prepared-create       - (fn [sql]) -> event
  :callable-create       - (fn [sql]) -> event
  :statement-sql-execute - (fn [sql]) -> event
  :statement-sql-query   - (fn [sql]) -> event
  :statement-sql-update  - (fn [sql]) -> event
  :prepared-sql-execute  - (fn [sql]) -> event
  :prepared-sql-query    - (fn [sql]) -> event
  :prepared-sql-update   - (fn [sql]) -> event"
  ([]
    (make-jdbc-event-factory {}))
  ([{:keys [connection-create
            statement-create
            prepared-create
            callable-create
            statement-sql-execute
            statement-sql-query
            statement-sql-update
            prepared-sql-execute
            prepared-sql-query
            prepared-sql-update]
     :or {connection-create     (fn []    {:jdbc-event :connection-create})
          statement-create      (fn []    {:jdbc-event :statement-create})
          prepared-create       (fn [sql] {:jdbc-event :prepared-create :sql sql})
          callable-create       (fn [sql] {:jdbc-event :callable-create :sql sql})
          statement-sql-execute (fn [sql] {:jdbc-event :sql-execute :prepared? false :sql sql})
          statement-sql-query   (fn [sql] {:jdbc-event :sql-query   :prepared? false :sql sql})
          statement-sql-update  (fn [sql] {:jdbc-event :sql-update  :prepared? false :sql sql})
          prepared-sql-execute  (fn [sql] {:jdbc-event :sql-execute :prepared? true  :sql sql})
          prepared-sql-query    (fn [sql] {:jdbc-event :sql-query   :prepared? true  :sql sql})
          prepared-sql-update   (fn [sql] {:jdbc-event :sql-update  :prepared? true  :sql sql})}}]
    (reify JdbcEventFactory
      (jdbcConnectionCreationEvent                 [_]     (connection-create))
      (jdbcStatementCreationEvent                  [_]     (statement-create))
      (jdbcPreparedStatementCreationEvent          [_ sql] (prepared-create       sql))
      (jdbcCallableStatementCreationEvent          [_ sql] (callable-create       sql))
      (sqlExecutionEventForStatement               [_ sql] (statement-sql-execute sql))
      (sqlQueryExecutionEventForStatement          [_ sql] (statement-sql-query   sql))
      (sqlUpdateExecutionEventForStatement         [_ sql] (statement-sql-update  sql))
      (sqlExecutionEventForPreparedStatement       [_ sql] (prepared-sql-execute  sql))
      (sqlQueryExecutionEventForPreparedStatement  [_ sql] (prepared-sql-query    sql))
      (sqlUpdateExecutionEventForPreparedStatement [_ sql] (prepared-sql-update   sql)))))


(def default-jdbc-event-factory (make-jdbc-event-factory))


(defn instrument-connection
  "Given a java.sql.Connection instance, make an instrumented wrapper using the given options:
  :jdbc-event-factory    - a preflex.instrument.jdbc.JdbcEventFactory instance (see `make-jdbc-event-factory`)
  :stmt-creation-wrapper - a preflex.instrument.task.Wrapper instance or argument to `preflex.task/make-wrapper`
  :sql-execution-wrapper - a preflex.instrument.task.Wrapper instance or argument to `preflex.task/make-wrapper`"
  [^Connection connection {:keys [jdbc-event-factory
                                  stmt-creation-wrapper
                                  sql-execution-wrapper]
                           :or {jdbc-event-factory default-jdbc-event-factory
                                stmt-creation-wrapper Wrapper/IDENTITY
                                sql-execution-wrapper Wrapper/IDENTITY}}]
  (ConnectionWrapper. connection jdbc-event-factory
    (if (fn? stmt-creation-wrapper)
      (task/make-wrapper stmt-creation-wrapper)
      stmt-creation-wrapper)
    (if (fn? sql-execution-wrapper)
      (task/make-wrapper sql-execution-wrapper)
      sql-execution-wrapper)))


(defn instrument-datasource
  "Given a javax.sql.DataSource instance, make an instrumented wrapper using the given options:
  :jdbc-event-factory    - a preflex.instrument.jdbc.JdbcEventFactory instance (see `make-jdbc-event-factory`)
  :conn-creation-wrapper - a preflex.instrument.task.Wrapper instance or argument to `preflex.task/make-wrapper`
  :stmt-creation-wrapper - a preflex.instrument.task.Wrapper instance or argument to `preflex.task/make-wrapper`
  :sql-execution-wrapper - a preflex.instrument.task.Wrapper instance or argument to `preflex.task/make-wrapper`"
  [^DataSource datasource {:keys [jdbc-event-factory
                                  conn-creation-wrapper
                                  stmt-creation-wrapper
                                  sql-execution-wrapper]
                           :or {jdbc-event-factory default-jdbc-event-factory
                                conn-creation-wrapper Wrapper/IDENTITY
                                stmt-creation-wrapper Wrapper/IDENTITY
                                sql-execution-wrapper Wrapper/IDENTITY}}]
  (DataSourceWrapper. datasource jdbc-event-factory
    (if (fn? conn-creation-wrapper)
      (task/make-wrapper conn-creation-wrapper)
      conn-creation-wrapper)
    (if (fn? stmt-creation-wrapper)
      (task/make-wrapper stmt-creation-wrapper)
      stmt-creation-wrapper)
    (if (fn? sql-execution-wrapper)
      (task/make-wrapper sql-execution-wrapper)
      sql-execution-wrapper)))
