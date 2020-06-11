(ns web-service.data
  (:use [ring.util.response]
        [web-service.db]
        [web-service.session]
        [web-service.user-helpers]
        [web-service.authentication])
  (:require [clojure.java.jdbc :as sql]
            [clojure.string :as string]
            [clojure.tools.logging :as log]
            [cheshire.core :refer :all]
            [web-service.amqp :as amqp]
            [web-service.constants :as constants])
  (:import java.sql.SQLException
           org.apache.commons.lang.RandomStringUtils))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                INTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defn- get-attachment-data
  [data-set-id]
  (let [query (str "select 'attachment' as type, filename, "
                   "  octet_length(contents) as bytes "
                   "from public.data_set_attachment "
                   "where data_set_id=? "
                   "and date_deleted is null")]
    (sql/query (db) [query data-set-id])))


(defn- get-primitive-data
  [type data-set-id]
  (let [query (str "select '" type "' as type, description, value "
                   "from public.data_set_" type " "
                   "where data_set_id=? "
                   "and date_deleted is null")]
    (sql/query (db) [query data-set-id])))


; format the specified row from the data_set table
(defn- format-data-set [row]
  {:uuid (:uuid row)
   :date_created (:date_created row)
   :created_by (:email_address row)
   :location (:location row)
   :client (:client row)
   :data (flatten [(get-attachment-data (:id row))
                   (get-primitive-data "boolean" (:id row))
                   (get-primitive-data "date" (:id row))
                   (get-primitive-data "integer" (:id row))
                   (get-primitive-data "real" (:id row))
                   (get-primitive-data "text" (:id row))])})


; format the specified row from the data_set_attachment table
(defn- format-data-set-attachment [row]
  {:filename (:filename row)
   :mime_type (:mime_type row)
   :bytes (:bytes row)
   :date_created (:date_created row)
   :created_by (:created_by row)
   :client (:client row)
   :location (:location row)
   :data_set_uuid (:data_set_uuid row)})


; format the specified row from the data_set_attachment for info display
(defn- format-attachment-info [row]
  {:filename (:filename row)
   :mime_type (:mime_type row)
   :bytes (:bytes row)
   :date_created (:date_created row)
   :created_by (:created_by row)
   :data_set_uuid (:data_set_uuid row)
   :primitive_text_data (get-primitive-data "text" (:data_set_id row))})


; format the specified attachment from the data_set_attachment for download
(defn- format-attachment-get [row]
  (->
    {:body (java.io.ByteArrayInputStream. (:contents row))}
    (content-type (:mime_type row))
    (header "Content-Length" (:bytes row))
    (header "Content-Disposition" (str "attachment;filename='"
                                       (:filename row)
                                       "'"))))

(def data-set-query
  (str "select "
       "  ds.id, "
       "  ds.uuid, "
       "  ds.date_created as date_created, "
       "  u.email_address as email_address, "
       "  cl.description as location, "
       "  c.name as client "
       "from public.data_set ds "
       "inner join public.user u "
       "  on u.id = ds.created_by "
       "left join public.client_location cl "
       "  on ds.client_location_id = cl.id "
       "left join public.client c "
       "  on c.id = cl.client_id "
       "where ds.date_deleted is null "))

(def data-set-attachment-query
  (str "select distinct on (data_set_attachment_id) "
       "  dsa.id as data_set_attachment_id, "
       "  dsa.filename as filename, "
       "  dsa.mime_type as mime_type, "
       "  octet_length(dsa.contents) as bytes, "
       "  dsa.date_created as date_created, "
       "  u.email_address as created_by, "
       "  c.name as client, "
       "  cl.description as location, "
       "  ds.id as data_set_id, ",
       "  ds.uuid as data_set_uuid "
       "from data_set_attachment as dsa "
       "inner join data_set as ds "
       "  on ds.id = dsa.data_set_id "
       "left join ( "
       "  select "
       "    data_set_id, "
       "    string_agg(value, ', ') as tag_values, "
       "    string_agg(description, ', ') as tag_names "
       "  from data_set_text "
       "  where date_deleted is null "
       "  group by data_set_id "
       ") as dst on ds.id = dst.data_set_id "
       "left join public.user as u "
       "  on u.id = ds.created_by "
       "left join public.client_location as cl "
       "  on ds.client_location_id = cl.id "
       "left join public.client as c "
       "  on cl.client_id = c.id "
       "where ds.date_deleted is null "
       "  and dsa.date_deleted is null "))


(def data-set-attachment-query-count
  (str "select "
       "  count(distinct dsa.id) "
       "from data_set_attachment as dsa "
       "inner join data_set as ds "
       "  on ds.id = dsa.data_set_id "
       "left join ( "
       "  select "
       "    data_set_id, "
       "    string_agg(value, ', ') as tag_values, "
       "    string_agg(description, ', ') as tag_names "
       "  from data_set_text "
       "  where date_deleted is null "
       "  group by data_set_id "
       ") as dst on ds.id = dst.data_set_id "
       "left join public.user as u "
       "  on u.id = ds.created_by "
       "left join public.client_location as cl "
       "  on ds.client_location_id = cl.id "
       "left join public.client as c "
       "  on cl.client_id = c.id "
       "where ds.date_deleted is null "
       "  and dsa.date_deleted is null "))


(def data-set-attachment-query-get
  (str "select "
       "  dsa.filename as filename, "
       "  dsa.mime_type as mime_type, "
       "  octet_length(dsa.contents) as bytes, "
       "  dsa.contents as contents, "
       "  ds.uuid as data_set_uuid "
       "from data_set_attachment as dsa "
       "inner join data_set as ds "
       "  on ds.id = dsa.data_set_id "
       "left join public.user as u "
       "  on u.id = ds.created_by "
       "where ds.date_deleted is null "
       "  and dsa.date_deleted is null "))


; semi-internal API for renaming attachments directly (used by child services)
(defn do-rename-attachment
  [uuid filename new-filename]
  (let [query (str "update public.data_set_attachment "
                   "set filename=? "
                   " where data_set_id=("
                   "  select id from public.data_set "
                   "  where uuid::character varying=?) "
                   "and filename=? "
                   "and date_deleted is null")]
    (println (format "Renaming '%s' to '%s' in data-set '%s'"
                     filename
                     new-filename
                     uuid))
    (try (if (sql/execute! (db) [query new-filename uuid filename])
           true)
         (catch Exception e
           (log/error e (format (str "There was an error renaming "
                                     "attachment '%s' to '%s' in data-set "
                                     "'%s'")
                                filename
                                new-filename
                                uuid))
           (if (instance? SQLException e)
             (log/error (.getCause e) "Caused by: "))
           false))))


; semi-internal API for deleting attachment directly (may be used by child
; services)
(defn do-delete-attachment
  [email-address uuid filename & {:keys [transaction?
                                         conn]
                                  :or {transaction? true
                                       conn         (db)}}]

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        query (str "update public.data_set_attachment "
                   "set date_deleted=now(), deleted_by="
                   "(select id from public.user where email_address=?) "
                   "where data_set_id="
                   "(select id from public.data_set where uuid::character varying=? ) "
                   "and filename=? "
                   "and date_deleted is null")]
    (if can-access
      (if (try (sql/execute! conn [query email-address uuid filename]
                             :transaction? transaction?)
               (catch Exception e
                 (log/error e (format (str "There was an error deleting "
                                           "attachment '%s' from data-set '%s' "
                                           "by user %s")
                                      filename
                                      uuid
                                      email-address))
                 (if (instance? SQLException e)
                   (log/error (.getCause e) "Caused by: "))
                 false))
        true
        false))))


; semi-internal API for getting attachment info directly (may be used by child
; services)
(defn do-get-attachment-info
  [email-address uuid filename]

  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/manage-data)
                       (contains? access constants/view-attachments))
        query (str data-set-attachment-query
                   "and uuid::character varying=? "
                   "and dsa.filename=? "
                   "order by data_set_attachment_id ")
        query-own (str data-set-attachment-query
                       "and uuid::character varying=? "
                       "and dsa.filename=? "
                       "and u.email_address=? "
                       "order by data_set_attachment_id ")]
    (if can-access
      (first (sql/query (db) [query uuid filename]
                  :row-fn format-attachment-info))
      ; if the user cannot access all data, try to at least show them their
      ; own data instead
      (first (sql/query (db) [query-own uuid filename email-address]
                        :row-fn format-attachment-info)))))


; semi-internal API for replacing attachment contents directly (may be used by
; child services)
(defn do-replace-attachment
  [email-address uuid filename new-contents attachment-info]

  ; mark the old file as deleted, and create a new one with exactly the same
  ; properties but the new
  (let [conn (db)
        query (str "insert into public.data_set_attachment "
                   "(data_set_id, date_created, created_by,"
                   " filename, mime_type, contents"
                   ") values ("
                   " ("
                   "   select id from public.data_set "
                   "   where uuid::character varying=? "
                   " ),"
                   " ?::timestamp with time zone, "
                   " ("
                   "   select id from public.user "
                   "   where email_address=? "
                   " ), ?, ?, decode(?, 'base64'))")]
    (if (nil? attachment-info)
      false
      (sql/with-db-transaction
        [conn db-spec]
        (println (format "Replacing '%s' with new contents in data-set '%s'"
                         filename
                         uuid))
        (try
          (let [is-deleted (do-delete-attachment email-address
                                                 uuid
                                                 filename
                                                 :transaction? false
                                                 :conn conn)]
            (if (sql/execute! conn [query
                                    uuid
                                    (:date_created attachment-info)
                                    (:created_by attachment-info)
                                    filename
                                    (:mime_type attachment-info)
                                    new-contents]
                              :transaction? false)
              true))
          (catch Exception e
            (log/error e (format (str "There was an error replacing "
                                      "attachment '%s' in data-set "
                                      "'%s'")
                                 filename
                                 uuid))
            (if (instance? SQLException e)
              (log/error (.getCause e) "Caused by: "))
            false))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                EXTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; get the specified data_set set by date
(defn data-set-get
  [email-address uuid]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-get-dataset " " uuid))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        query (str data-set-query " and uuid::character varying=?")
        query-own (str data-set-query
                       " and uuid::character varying=?"
                       " and u.email_address=?")]
    (if can-access
      (response {:response (first (sql/query (db)
                                             [query uuid]
                                             :row-fn format-data-set))})
      ; if the user cannot access all data, try to at least show them their own
      ; data instead
      (response {:response (first (sql/query (db)
                                             [query-own uuid email-address]
                                             :row-fn format-data-set))}))))


; delete the specified data_set by date
(defn data-set-delete
  [email-address uuid]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-delete-dataset " " uuid))
  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        delete-data-set-query (str
                                "update public.data_set ds "
                                "set date_deleted=now(), deleted_by="
                                "  (select id from public.user "
                                "   where email_address=?) "
                                "where uuid::character varying=? "
                                "and ds.date_deleted is null")
        delete-associations-query (str
                                    "set date_deleted=now(), deleted_by="
                                    "  (select id from public.user "
                                    "   where email_address=?) "
                                    "where data_set_id="
                                    "  (select id from public.data_set "
                                    "   where uuid::character varying=? ) "
                                    "and date_deleted is null" )]
    (if can-access
      (let [delete-data-set-success
            (sql/execute! (db) [delete-data-set-query email-address uuid])

            delete-associations-success
            (every? (fn [type]
                      (sql/execute! (db) [(str "update public.data_set_" type " "
                                               delete-associations-query)
                                          email-address uuid]))
                    ["attachment" "boolean" "date" "integer" "real" "text"])]
        (if (and delete-data-set-success delete-associations-success)
          (status (response {:response "OK"}) 200 )
          (status (response {:response "Failure"}) 409)))
      (do
        (log/debug
          (format ("User %s tried to delete data-set '%s' but lacks access")
                  email-address
                  uuid))
        (access-denied constants/manage-data)))))


; submit data
(defn data-set-submit
  [email-address uuid date-created created-by data]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-add-dataset " " uuid))

  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/create-data)
                       (contains? access constants/manage-data))
        conn (db)
        query (str "insert into public.data_set "
                   "(uuid, date_created, created_by) values "
                   "(?::uuid, ?::timestamp with time zone, ("
                   " select id from public.user where email_address=?"
                   "))")
        json-data (try
                    (parse-string data true)
                    (catch Exception e
                      (println (str "Failed to parse 'data' as JSON string"))
                      ; return an empty data-set
                      []))]
    (if can-access
      (if (empty? json-data)
        (status (response {:response "Cannot record empty data-set"}) 409)
        (let [success
          (sql/with-db-transaction
           [conn db-spec]
           (try
             (let [keys (sql/db-do-prepared-return-keys conn
                                                        false ; no transaction
                                                        query
                                                        [uuid
                                                         date-created
                                                         created-by])
                   id (:id keys)]
               ; iterate child elements of 'data' and add to the database also
               (doseq [data-element json-data]
                 (let [type (:type data-element)]
                   ; treat attachments and primitive data differently
                   (if (= type "attachment")
                     ; TODO refactor this and data-set-attachment-submit to use
                     ; same shared private function
                     (let [filename (:filename data-element)
                           mime-type (:mime_type data-element)
                           contents (:contents data-element)
                           query (str "insert into public.data_set_attachment "
                                      "(data_set_id, date_created, created_by, "
                                      "filename, mime_type, contents) "
                                      "values (?,?::timestamp with time zone, ("
                                      " select id from public.user where email_address=?"
                                      "),?,?,decode(?, 'base64'))")
                           success (sql/execute! conn [query
                                                       id
                                                       date-created
                                                       created-by
                                                       filename
                                                       mime-type
                                                       contents]
                                                 :transaction? false)]
                       (if (not success)
                         (throw Exception "Failed to insert new attachment!")))
                     ; TODO -- refactor this and data-set-primitive-submit to use
                     ; same shared private function
                     (let [type (:type data-element)
                           description (:description data-element)
                           value (:value data-element)
                           query (str "insert into public.data_set_" type " "
                                      "(data_set_id, date_created, created_by, "
                                      "description, value) values "
                                      "(?,?::timestamp with time zone,("
                                      " select id from public.user where email_address=?"
                                      "),?,?"
                                      (if (= type "date") ; cast dates correctly
                                        "::timestamp with time zone"
                                        "")
                                      ")")
                           success (sql/execute! conn [query
                                                       id
                                                       date-created
                                                       created-by
                                                       description
                                                       value]
                                                 :transaction? false)]
                       (if (not success)
                         (throw Exception "Failed to insert new child row!"))))))
               true)
             (catch Exception e
               (log/error e (format (str "There was an error submitting a "
                                         "data-set for user %s")
                                    email-address))
               ; rollback the transaction
               (sql/db-set-rollback-only! conn)
               (if (instance? SQLException e)
                 (log/error (.getNextException e) "Caused by: ")
                 false))))]

          (if success
            (let [data-saved (data-set-get email-address uuid)]
              ; broadcast the dataset including attachment binary data to
              ; listeners
              (let [with-attachments (merge (:response (:body data-saved))
                                            {:data json-data})]
                (amqp/broadcast "text/json"
                                "dataset"
                                (generate-string with-attachments)))
              (status data-saved 201))
            (status (response {:response "Failure"}) 409))))
      (do
        (log/warn
          (format "User %s tried to submit data-set but lacks %s permission."
                  email-address
                  constants/create-data))
        (access-denied constants/create-data)))))

(defn data-set-attachment-submit
  [email-address data-set-uuid data-element]

  (log-detail email-address constants/session-activity
              (str constants/session-add-dataset-attachment
                   " to dataset(" data-set-uuid ")"))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        filename (:filename data-element)
        mime-type (:mime_type data-element)
        contents (:contents data-element)
        query (str "insert into public.data_set_attachment "
                   "(data_set_id, filename, mime_type, contents) "
                   "values ("
                   "(select id from data_set where uuid::character varying=?)"
                   ",?,?,decode(?, 'base64'))")]
    (if can-access
      (if (sql/execute! (db) [query data-set-uuid filename mime-type contents])
        (status (response {:response "OK"}) 200 )
        (status (response {:response "Failure"}) 409))
      (access-denied constants/manage-data))))

(defn data-set-primitive-submit
  [email-address data-set-uuid type description value]

  (log-detail email-address constants/session-activity
              (str constants/session-add-dataset-primitive
                   "(" type ") to dataset(" data-set-uuid ")"))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        query (str "insert into public.data_set_" type " ( "
                   "  data_set_id, created_by, description, value) "
                   "values( "
                   "  (select id from data_set where uuid::character varying=?), "
                   "  (select id from public.user where email_address=?), "
                   "  ?,? "
                   (if (= type "date") ; cast dates correctly
                     "::timestamp with time zone"
                     "")
                   ")")]
    (if can-access
      (if (sql/execute! (db)
                        [query data-set-uuid email-address description value])
        (status (response {:response "OK"}) 200 )
        (status (response {:response "Failure"}) 409))
      (access-denied constants/manage-data))))

(defn data-set-primitive-update
  [email-address data-set-uuid type description value]

  (log-detail email-address constants/session-activity
              (str constants/session-update-dataset-primitive
                   "(" type ") from dataset(" data-set-uuid ")"))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        query (str "update into public.data_set_" type " "
                   "set value=? "
                   "where data_set_id= "
                   "  (select id from data_set where uuid::character varying=?) "
                   "and description=?")]

    (if can-access
      (if (sql/execute! (db) [query value data-set-uuid description])
        (status (response {:response "OK"}) 200 )
        (status (response {:response "Failure"}) 409))
      (access-denied constants/manage-data))))

(defn data-set-primitive-delete
  [email-address data-set-uuid type description]

  (log-detail email-address constants/session-activity
              (str constants/session-delete-dataset-primitive
                   "(" type ") from dataset(" data-set-uuid ")"))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        query (str "update public.data_set_" type " "
                   "set "
                   "  date_deleted=now(), "
                   "  deleted_by=( "
                   "    select id from public.user where email_address=?) "
                   "where data_set_id=( "
                   "  select id from data_set where uuid::character varying=?) "
                   "and description=?")]
    (if can-access
      (sql/with-db-transaction
        [conn db-spec]
        (try
          (sql/execute! (db) [query email-address data-set-uuid description])
          (status (response {:response "OK"}) 200 )

          (catch Exception e
            (log/error e (format (str "There was an error submitting a "
                                      "data-set for user %s")
                                 email-address))
            ; rollback the transaction
            (sql/db-set-rollback-only! conn)
            (if (instance? SQLException e)
                  (log/error (.getNextException e) "Caused by: "))
                (status (response {:response "Failure"}) 409))))
      (access-denied constants/manage-data))))

; list up data_sets in the database, as an HTTP response
(defn data-set-list
  ([email-address]
   ; log the activity in the session
   (log-detail email-address
               constants/session-activity
               constants/session-list-datasets)

   (let [access (set (get-user-access email-address))
         can-access (or (contains? access constants/manage-data))
         query (str data-set-query
                   "order by ds.date_created desc ")
         query-own (str data-set-query
                        "and u.email_address=? "
                        "order by ds.date_created desc ")]
     (if can-access
       (response {:response (sql/query (db) [query] :row-fn format-data-set)})
       ; if the user cannot access all data, try to at least show them their own
       ; data instead
       (response {:response (sql/query (db)
                                       [query-own email-address]
                                       :row-fn format-data-set)}))))
  ([email-address search-params]
   ; log the activity in the session
   (log-detail email-address
               constants/session-activity
               constants/session-list-datasets)

   (let [access (set (get-user-access email-address))
         can-access (or (contains? access constants/manage-data))

         order (:order_by search-params)
         order-by-query (if (:orderBy search-params)
                          (str "order by " (:order_by search-params)
                               (if (order)
                                 (str (order) " ")
                                 "desc "))
                          "order by ds.date_created desc ")

         limit-query (if (:limit search-params)
                       (str "limit " (:limit search-params) " ")
                       " ")

         offset-query (if (:offset search-params)
                        (str "offset " (:offset search-params) " ")
                        " ")

         query (str data-set-query
                    order-by-query
                    limit-query
                    offset-query)
         query-own (str data-set-query
                        "and u.email_address=? "
                        order-by-query
                        limit-query
                        offset-query)]
     (if can-access
       (response {:response (sql/query (db) [query] :row-fn format-data-set)})
       ; if the user cannot access all data, try to at least show them their own
       ; data instead
       (response {:response (sql/query (db)
                                       [query-own email-address]
                                       :row-fn format-data-set)})))))

(defn data-set-attachment-list
  [email-address search-params]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              constants/session-list-datasets)

  (let [wrap (fn [x wrapper] (str wrapper x wrapper))
        dollar-quote (wrap (RandomStringUtils/randomAlphabetic 5) "$")
        escape (fn [x] (wrap x dollar-quote))
        fuzzy (fn [x] (wrap x "%"))
        access (set (get-user-access email-address))
        can-access (or (contains? access constants/manage-data))
        json-search-params (try
                             (parse-string search-params true)
                             (catch Exception e
                               (println (str "Failed to parse 'search-params' as JSON string"))
                               ; return an empty data-set
                               []))

        or-search-string-query
        (if-not (empty? (:or_search_strings json-search-params))
          (let [or-search-string-list (:or_search_strings json-search-params)
                or-search-string-query-list
                (map
                  (fn [search-string]
                    (let [escaped (escape (fuzzy search-string))]
                      (str "or dsa.filename ilike " escaped " "
                           "or u.email_address ilike " escaped " "
                           "or cl.description ilike " escaped " "
                           "or c.name ilike " escaped " "
                           "or to_char(ds.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "or to_char(dsa.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "or dst.tag_values ilike " escaped " ")))
                  or-search-string-list)]
            (str "and ( false " (clojure.string/join or-search-string-query-list) ") "))
          " ")

        and-search-string-query
        (if-not (empty?  (:and_search_strings json-search-params))
          (let [and-search-string-list (:and_search_strings json-search-params)
                and-search-string-query-list
                (map
                  (fn [search-string]
                    (let [escaped (escape (fuzzy search-string))]
                      (str "and ( false "
                           "  or dsa.filename ilike " escaped " "
                           "  or u.email_address ilike " escaped " "
                           "  or cl.description ilike " escaped " "
                           "  or c.name ilike " escaped " "
                           "  or to_char(ds.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "  or to_char(dsa.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "  or dst.tag_values ilike " escaped " "
                           ") ")))
                  and-search-string-list)]
            (str (clojure.string/join and-search-string-query-list) " "))
          " ")

        not-search-string-query
        (if-not (empty?  (:not_search_strings json-search-params))
          (let [not-search-string-list (:not_search_strings json-search-params)
                not-search-string-query-list
                (map
                  (fn [search-string]
                    (let [escaped (escape (fuzzy search-string))]
                      (str "and not ( false "
                           "  or dsa.filename ilike " escaped " "
                           "  or u.email_address ilike " escaped " "
                           "  or (cl.description is not null and cl.description ilike " escaped ") "
                           "  or (c.name is not null and c.name ilike " escaped ") "
                           "  or to_char(ds.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "  or to_char(dsa.date_created, 'YYYY-MM-DD') ilike " escaped " "
                           "  or (dst.tag_values ilike " escaped " and dst.tag_values is not null) "
                           ") ")))
                  not-search-string-list)]
            (str (clojure.string/join not-search-string-query-list) " "))
          " ")

        search-string-query (str
                              or-search-string-query
                              and-search-string-query
                              not-search-string-query)

        tag-name-query
        (if (:tag_name json-search-params)
          (str "and dst.tag_names ilike " (escape (:tag_name json-search-params)) " ")
          " ")

        order-by-query
        (if (:order_by json-search-params)
          (let [order (if (and (:order json-search-params)
                               (= (:order json-search-params) "asc"))
                        "asc"
                        "desc")]
            (str "order by \"" (string/replace (:order_by json-search-params)
                                               "\""
                                               "")
                 "\" " order " "))
          "order by date_created desc")

        limit-query (if (:limit json-search-params)
                      (str "limit " (escape (:limit json-search-params)) " ")
                      " ")

        offset-query (if (:offset json-search-params)
                       (str "offset " (escape (:offset json-search-params)) " ")
                       " ")

        query (str "select * from ("
                   data-set-attachment-query
                   search-string-query
                   tag-name-query
                   "order by data_set_attachment_id "
                   " ) as dsa_table "
                   order-by-query
                   limit-query
                   offset-query)

        query-result-count (str data-set-attachment-query-count
                                search-string-query
                                tag-name-query)

        query-own (str "select * from ("
                       data-set-attachment-query
                       search-string-query
                       tag-name-query
                       "and u.email_address=? "
                       "order by data_set_attachment_id "
                       ") as dsa_table "
                       order-by-query
                       limit-query
                       offset-query)

        query-own-result-count (str data-set-attachment-query-count
                                    "and u.email_address=? "
                                    search-string-query
                                    tag-name-query)]
    (try
      (if can-access
        (response {:response
                   {:attachments (sql/query (db) [query] :row-fn format-data-set-attachment)
                    :result_count (:count (first (sql/query (db) [query-result-count])))}})
        ; if the user cannot access all data, try to at least show them their own
        ; data instead
        (response {:response
                   {:attachments (sql/query (db) [query-own email-address] :row-fn format-data-set-attachment)
                    :result_count (:count (first (sql/query (db) [query-own-result-count email-address])))}}))
      (catch Exception e
        (log/error e (str "There was an error listing attachments"))
        (status (response {:response "Failure"}) 400)))))

; get data_set_attachment info
(defn data-set-attachment-info-get
  [email-address uuid filename]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              constants/session-list-datasets)

  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/manage-data)
                       (contains? access constants/view-attachments))]
    (if can-access
      ; FIXME -- this shouldn't be returning a list, but I don't want to break
      ; compatibility with the front-end
      (response {:response [(do-get-attachment-info email-address
                                                   uuid
                                                   filename)]})
      (access-denied constants/manage-data))))


; get the specified attachment to a data set, by date and filename
(defn data-set-attachment-get
  [email-address uuid filename]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-get-dataset-attachment " "
                   uuid " " filename))

  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/manage-attachments)
                       (contains? access constants/view-attachments))
        query (str data-set-attachment-query-get
                   "and uuid::character varying=? "
                   "and dsa.filename=? ")
        query-own (str data-set-attachment-query-get
                       "and uuid::character varying=? "
                       "and dsa.filename=? "
                       "and u.email_address=? ")
        attachment (first (sql/query (db)
                                     [query uuid filename]
                                     :row-fn format-attachment-get))
        attachment-own (first (sql/query (db)
                                         [query-own uuid filename email-address]
                                         :row-fn format-attachment-get))
        attachment-count (count (:headers attachment))
        attachment-own-count (count (:headers attachment-own))]
    (if can-access
      (if (> attachment-count 0)
        attachment
        (status (response {:response "File not found."}) 404))
      (if (> attachment-own-count 0)
        attachment-own
        (if (= attachment-count attachment-own-count 0)
          (status (response {:response "File not found."}) 404)
          (do
            (log/debug (format (str "User %s tried to download attachment '%s' "
                                    "from data-set '%s' but lacks access")
                               email-address
                               filename
                               uuid))
          (access-denied constants/manage-data)))))))


; delete the specified data set attachment by dataset uuid and filename
(defn data-set-attachment-delete
  [email-address uuid filename]
  ;TODO check if uuid and filename exits otherwise throw exception

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-delete-dataset-attachment " " uuid))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)]
    (if can-access
      (if (do-delete-attachment email-address uuid filename)
        (status (response {:response "OK"}) 200 )
        (status (response {:response "Failure"}) 409))
      (do
        (log/debug (format (str "User %s tried to delete attachment '%s' "
                                "from data-set '%s' but lacks access")
                           email-address
                           filename
                           uuid))
        (access-denied constants/manage-data)))))


; rename the specified data set attachment filename
(defn data-set-attachment-filename-rename
  [email-address uuid filename new-filename]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-rename-dataset-attachment " " uuid))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)]
    (if can-access
      (if (do-rename-attachment uuid filename new-filename)
        (status (response {:response "OK"}) 200 )
        (status (response {:response "Failure"}) 409))
      (access-denied constants/manage-data))))

; replace the contents of the specified data set attachment, changing nothing
; else about it
(defn data-set-attachment-file-replace
  [email-address uuid filename new-contents]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-replace-dataset-attachment " " uuid))

  (let [access (set (get-user-access email-address))
        can-access (contains? access constants/manage-data)
        attachment-info (do-get-attachment-info email-address
                                                uuid
                                                filename)]
    (if can-access
      (if (nil? attachment-info)
        (status (response {:reponse "File not found."}) 404)
        (if (do-replace-attachment email-address
                                   uuid
                                   filename
                                   new-contents
                                   attachment-info)
          (status (response {:response "OK"}) 200)
          (status (response {:response "Failure"}) 409)))
      (access-denied constants/manage-data))))

(defn data-set-attachment-sharable-download-link
  [email-address uuid filename exp-date]
  (log-detail email-address
              constants/session-activity
              (str constants/session-generate-sharable-download-link " "
                   uuid " " filename))
  (let [access (set (get-user-access email-address))
        can-access (or (contains? access constants/manage-attachments)
                       (contains? access constants/view-attachments))
        query (str data-set-attachment-query-get
                   "and uuid::character varying=? "
                   "and dsa.filename=? ")
        query-own (str data-set-attachment-query-get
                       "and uuid::character varying=? "
                       "and dsa.filename=? "
                       "and u.email_address=? ")
        attachment (first (sql/query (db)
                                     [query uuid filename]
                                     :row-fn format-attachment-get))
        attachment-own (first (sql/query (db)
                                         [query-own uuid filename email-address]
                                         :row-fn format-attachment-get))
        attachment-count (count (:headers attachment))
        attachment-own-count (count (:headers attachment-own))]
    (if can-access
      (if (> attachment-count 0)
        (generate-sharable-download-link email-address uuid filename exp-date)
        (status (response {:response "File not found."}) 404))
      (if (> attachment-own-count 0)
        (generate-sharable-download-link email-address uuid filename exp-date)
        (if (= attachment-count attachment-own-count 0)
          (status (response {:response "File not found."}) 404)
          (do
            (log/debug (format (str "User %s tried to create a sharable "
                                    "download link for '%s' from data-set '%s' "
                                    "but lacks access")
                               email-address
                               filename
                               uuid))
          (access-denied constants/manage-data)))))))

