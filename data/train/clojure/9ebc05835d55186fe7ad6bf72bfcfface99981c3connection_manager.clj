(ns witan.gateway.components.connection-manager
  (:require [com.stuartsierra.component :as component]
            [taoensso.timbre            :as log]
            [clj-time.core              :as t]
            [clojure.spec               :as s]
            [witan.gateway.protocols    :as p :refer [ManageConnections]]
            [zookeeper                  :as zk]))

(defonce channels (atom #{}))
(defonce receipts (atom {}))

(defrecord ConnectionManager []
  ManageConnections
  (process-event! [{:keys [receipts]} event]
    (when-let [id (or (:kixi.comms.command/id event)
                      (:kixi.command/id event))]
      (try
        (when-let [{:keys [cb ch]} (get @receipts id)]
          (log/info "Sending event" (or (:kixi.comms.event/id event)
                                        (:kixi.event/id event)) "back to client")
          (cb ch id event)
          nil)
        (catch Exception e
          (log/error "Error whilst processing an event:" event e)))))
  (add-connection! [{:keys [channels]} connection]
    (swap! channels conj connection)
    (log/info "Added connection. Total:" (count @channels)))
  (remove-connection! [{:keys [channels receipts]} connection]
    (swap! channels #(remove #{connection} %))
    (swap! receipts #(reduce-kv (fn [a k v] (if (= connection (:ch v))
                                              a
                                              (assoc a k v))) {} %))
    (log/info "Removed connection. Total:" (count @channels)))
  (add-receipt! [{:keys [receipts]} channel receipt-id callback]
    (swap! receipts assoc (str receipt-id) {:cb callback
                                            :ch channel
                                            :at (t/now)}))

  component/Lifecycle
  (start [{:keys [events] :as component}]
    (log/info "Starting Connection Manager")
    (let [c (assoc component
                   :channels  (atom #{})
                   :receipts  (atom {}))
          cmfn (partial p/process-event! c)]
      (p/register-event-receiver! events cmfn)
      (assoc c :cmfn cmfn)))

  (stop [{:keys [events] :as component}]
    (log/info "Stopping Connection Manager")
    (p/unregister-event-receiver! events (:cmfn component))
    (dissoc component
            :cmfn
            :channels
            :receipts)))

(defn new-connection-manager [_]
  (map->ConnectionManager {}))
