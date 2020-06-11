(ns cassius.net.command.keyspace
  (:require [ribol.core :refer [raise raise-on option default manage on]]
            [cassius.schema.outline :as ol]
            [cassius.common :refer :all]
            [cassius.net.connection :refer [client]]
            [cassius.net.command.macros :refer [raise-on-invalid-request]])
  (:import
    [org.apache.cassandra.thrift KsDef InvalidRequestException]
    [org.apache.thrift.transport TTransportException]))

(defn describe-keyspace
  [conn ks]
  (raise-on-invalid-request [conn ks nil :describe :keyspace-not-found]
    (.describe_keyspace (client conn) ks)))

(defn describe-keyspaces
  [conn]
  (try
    (.describe_keyspaces (client conn))
    (catch TTransportException e
      (raise [:cannot-connect {:conn conn :error e}]))))

(def system-keyspace-names
  #{"system" "system_auth" "system_traces"})

(defn user-keyspaces [conn]
  (->> (describe-keyspaces conn)
       (filter (fn [x] (-> (.name x) system-keyspace-names not)))))

(defn drop-keyspace
  [conn ks]
  (raise-on-invalid-request [conn ks nil :drop :keyspace-not-found]
    (.system_drop_keyspace (client conn) ks)
    ks))

(defn drop-all-keyspaces
  [conn]
  (doseq [k (mapv (fn [x] (.name x))
                  (user-keyspaces conn))]
    (drop-keyspace conn k)))

(defn prepare-keyspace [ks]
  (cond (string? ks)
        (ol/string->keyspacedef ks)

        (instance? KsDef ks) ks

        :else (raise [:invalid-keyspace {:definition ks}])))

(defn add-keyspace
  [conn ks]
  (raise-on-invalid-request [conn ks nil :add :keyspace-exists]
    (.system_add_keyspace (client conn) (prepare-keyspace ks))
    ks))

(defn set-keyspace
  [conn ks]
  (try
    (.set_keyspace (client conn) ks)
    ks
    (catch InvalidRequestException e
      (raise [:abortable :set :keyspace-not-found
              {:conn     conn
               :error    e
               :keyspace ks}]
             (option :abort [] nil)
             (option :create-and-set []
                     (add-keyspace conn ks)
                     (set-keyspace conn ks))
             (default :create-and-set)))
    (catch TTransportException e
      (raise [:cannot-connect {:conn conn :error e}]))))

(defn has-keyspace?
  [conn ks]
  (if (describe-keyspace conn ks) true false))
