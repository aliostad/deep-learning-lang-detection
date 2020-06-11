(ns cassius.net.connection
  (:require [ribol.core :refer [raise raise-on option default manage on]]
            [cassius.protocols :refer [IConnection connect create]])
  (:import
   [org.apache.cassandra.thrift Cassandra$Client]
   [org.apache.thrift.protocol TBinaryProtocol]
   [org.apache.thrift.transport
    TFramedTransport TSocket
    TTransportException]))

(defrecord Connection [host port opts instance]
  IConnection
  (-connect [conn]
    (try
      (let [socket (if-let [timeout (:timeout opts)]
                     (TSocket. host port timeout)
                     (TSocket. host port))
            tr     (doto (TFramedTransport. socket)
                     (.open))
            client (Cassandra$Client. (TBinaryProtocol. tr))]
        (reset! instance {:client client :tr tr}))
      (catch TTransportException e
        (raise [:cannot-connect {:conn  conn :error e}]
               (option :retry [host port opts]
                       (connect conn))))))
  (-disconnect [_]
    (when-let [{:keys [client tr]} @instance]
      (.flush tr)
      (.close tr)
      (reset! instance nil))))

(defn client [conn]
  (if-let [client (-> conn :instance deref :client)]
    client
    (do (connect conn)
        (client conn))))

(defmethod create :connection [m]
  (assoc (map->Connection m) :instance (atom nil)))
