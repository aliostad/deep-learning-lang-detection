(ns cassius.net.command.insert
  (:require [ribol.core :refer [manage on]]
            [cassius.protocols :refer [to-bbuff]]
            [cassius.types.byte-buffer]
            [cassius.types.thrift :as thr]
            [cassius.net.connection :refer [client]]
            [cassius.net.command
             [keyspace :as ksp]
             [column-family :as cf]
              [macros :refer [raise-on-data-error current-time-millis]]])
  (:import [org.apache.cassandra.thrift ColumnParent Column
                                        ConsistencyLevel]))

(defn insert-column
  [conn ks ^ColumnParent cp row ^Column column]
  (ksp/set-keyspace conn ks)
  (raise-on-data-error
    [conn ks :insert {:row row}]
    (.insert (client conn) (to-bbuff row) cp column
             (or (:consistency conn) ConsistencyLevel/ONE))))

(defn insert
  ([conn ks cf row col v]
     (insert conn ks cf row nil col v))
  ([conn ks cf row col subcol v]
     (let [cp (ColumnParent. cf)
           _ (if col (.setSuper_column cp (to-bbuff col)))
           column (thr/map->thrift {:name      subcol :value v
                                    :timestamp (current-time-millis conn)}
                                   Column)]
       (manage (insert-column conn ks cp row column)
               (on :column-family-not-found e
                   (cf/add-column-family conn ks {:name        cf
                                                  :column_type (if col "Super" "Standard")})
                   (insert-column conn ks cp row column))))))
