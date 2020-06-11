(ns web-service.client
  (:use [ring.util.response]
        [web-service.db]
        [web-service.session]
        [web-service.user-helpers])
  (:require [clojure.java.jdbc :as sql]
            [web-service.constants :as constants]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                INTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; get the specified client
(defn get-client
  [client-name]
  (first
    (sql/query (db) ["select * from public.client where name=?" client-name])))


; get the locations for the specified client
(defn get-client-locations
  [client-name]
  (sql/query
    (db)
    [(str "select distinct cl.description "
          "from public.client_location cl "
          "inner join public.client c "
          "  on cl.client_id=c.id "
          "where c.name=?") client-name]
    :row-fn :description))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                EXTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; possible buffer overflow on client name or email address in client-get
; recommend fuzzing with large inputs in test environment to confirm vulnerability
; easily fixed with front- and back-end length maximums and white-list filtering

; get the specified client, as an HTTP response
(defn client-get
  [email-address client-name]

  ; log the activity to the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-get-client " " client-name))

  ; users who can view or manage clients can see information about a client
  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/view-clients)
                       (contains? access constants/manage-clients))]
    (if can-access
      (let [client (get-client client-name)]
        (if client
          (response {:response client})
          (not-found "Client not found"))) ; inconceivable!
      (access-denied constants/view-clients))))


; list the clients in the database, as an HTTP response
(defn client-list
  [email-address]

  ; log the activity to the session
  (log-detail email-address
              constants/session-activity
              constants/session-list-clients)

  ; users who can view or manage clients can see the list of clients
  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/view-clients)
                       (contains? access constants/manage-clients))]
    (if can-access
      (response {:response (sql/query (db)
                                      ["select * from public.client"]
                                      :row-fn :name)})
      (access-denied constants/view-clients))))


; add a new client by name, as an HTTP response
(defn client-register
  [email-address client-name]

  ; log the activity to the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-add-client " " client-name))

  (let [access (set (get-user-access email-address))]
    (if (contains? access constants/manage-clients)
     (let
       [query "insert into public.client (name) values (?)"
        success (try (sql/execute! (db) [query client-name])
                     true
                     (catch Exception e
                       (println (.getMessage e))
                       false))]
       ; if we successfully created the client, return a "created" status and
       ; invoke client-get
       ; otherwise, return a "conflict" status
       (if success
         (status (client-get email-address client-name) 201)
         (status (response {:response "Client already exists"}) 409)))
      (access-denied constants/manage-clients))))


; list the locations for the specified client, as an HTTP response
(defn client-location-list
  [email-address client-name]

  ; log the activity to the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-list-client-locations " "
                   client-name))

  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/view-clients)
                       (contains? access constants/manage-clients))]
    (if can-access
      (response {:response (get-client-locations client-name)})
      (access-denied constants/view-clients))))


; add the specified location to the client, as an HTTP response
(defn client-location-add
  [email-address client-name description]

  ; log the activity to the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-add-client-location " "
                   client-name " " description))

  (let [access (set (get-user-access email-address))]
    (if (contains? access constants/manage-clients)
     (let
       [query (str "insert into public.client_location "
                   "(client_id, description) values "
                   "((select id from public.client where name=?), ?)")
        success (try (sql/execute! (db) [query client-name description])
                     true
                     (catch Exception e
                       (println (.getMessage e))
                       (println (.getMessage (.getNextException e)))
                       false))]

       ; if we successfully created the client location, return a "created"
       ; status and invoke client-location-get
       ; otherwise, return a "conflict" status
       (if success
         (status (client-location-list email-address
                                       client-name) 201)
         (status (response {:response (str "Client location for " client-name
                                           " already exists: " description)})
                 409)))
     (access-denied constants/manage-clients))))
