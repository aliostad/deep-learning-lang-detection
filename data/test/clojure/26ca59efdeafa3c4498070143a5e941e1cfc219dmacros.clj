(ns cassius.net.command.macros
  (:require [ribol.core :refer [raise raise-on option default manage on]])
  (:import
    [org.apache.cassandra.thrift InvalidRequestException]
    [org.apache.thrift.transport TTransportException]))

(defmacro current-time-millis [conn]
  `(if (:t-fn ~conn)
     ((:t-fn ~conn))
     (System/currentTimeMillis)))

(defmacro raise-on-invalid-request [[conn ks cf & msgs] & body]
  (cons 'try
        (concat body
                [(list 'catch org.apache.cassandra.thrift.NotFoundException 'e
                       (list 'ribol.core/raise
                             (-> (apply vector :abortable msgs)
                                 (conj {:conn          conn
                                        :error         'e
                                        :keyspace      ks
                                        :column-family cf}))
                             '(ribol.core/option :abort [] nil)
                             '(ribol.core/default :abort)))
                 (list 'catch org.apache.cassandra.thrift.InvalidRequestException 'e
                       (list 'ribol.core/raise
                             (-> (apply vector :abortable msgs)
                                 (conj {:conn          conn
                                        :error         'e
                                        :keyspace      ks
                                        :column-family cf}))
                             '(ribol.core/option :abort [] nil)
                             '(ribol.core/default :abort)))
                 (list 'catch org.apache.thrift.transport.TTransportException 'e
                       (list 'ribol.core/raise [:cannot-connect {:conn conn :error 'e}]))])))

(defmacro raise-on-data-error [[conn ks op-name info] & body]
  (cons 'try
        (concat body
                [(list 'catch org.apache.cassandra.thrift.InvalidRequestException 'e
                       (list 'let '[why (.getWhy e)
                                    r1 #"^unconfigured columnfamily (.*)"
                                    r2 #"^supercolumn parameter is not optional for super CF (.*)"
                                    r3 #"^supercolumn parameter is invalid for standard CF (.*)"]
                             (list 'cond
                                   '(re-find r1 why)
                                   (list 'ribol.core/raise
                                         [op-name :column-family-not-found
                                          (merge {:conn          conn
                                                  :error         'e
                                                  :keyspace      ks
                                                  :column-family '(second (re-find r1 why))}
                                                 info)])
                                   '(re-find r2 why)
                                   (list 'ribol.core/raise
                                         [op-name :invalid-supercolumn-input
                                          (merge {:conn          conn
                                                  :error         'e
                                                  :keyspace      ks
                                                  :column-family '(second (re-find r2 why))}
                                                 info)])
                                   '(re-find r3 why)
                                   (list 'ribol.core/raise
                                         [op-name :invalid-column-input
                                          (merge {:conn          conn
                                                  :error         'e
                                                  :keyspace      ks
                                                  :column-family '(second (re-find r3 why))}
                                                 info)])

                                   :else
                                   (list 'ribol.core/raise
                                         [op-name (merge {:conn     conn
                                                          :error    'e
                                                          :keyspace ks}
                                                         info)]))))
                 (list 'catch org.apache.thrift.transport.TTransportException 'e
                       (list 'ribol.core/raise [:cannot-connect {:conn conn :error 'e}]))])))
