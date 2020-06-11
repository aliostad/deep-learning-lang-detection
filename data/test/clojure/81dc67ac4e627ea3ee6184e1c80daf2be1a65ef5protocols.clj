(ns witan.gateway.protocols)

(defprotocol SendMessage
  (send-message! [this topic message]))

;;;;;;;;;

(defprotocol ManageConnections
  (process-event! [this event])
  (add-receipt! [this channel receipt-id callback])
  (add-connection! [this connection])
  (remove-connection! [this connection]))
;;;;;;;;;

(defprotocol RouteQuery
  (route-query [this user payload]))

;;;;;;;;;

(defprotocol Database
  (drop-table! [this table])
  (create-table! [this table columns])
  (insert! [this table row args])
  (select [this table where]))

;;;;;;;;;

(defprotocol Authenticate
  (authenticate [this time auth-token]))

;;;;;;;;;

(defprotocol ManageDownloads
  (get-download-redirect [this user file-id]))

;;;;;;;;;

(defprotocol AggregateEvents
  (register-event-receiver! [this handler-fn])
  (unregister-event-receiver! [this handler-fn]))
