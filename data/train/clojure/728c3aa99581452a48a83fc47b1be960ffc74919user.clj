(ns web-service.user
  (:use [ring.util.response]
        [web-service.authentication]
        [web-service.db]
        [web-service.session]
        [web-service.user-helpers])
  (:require [clojure.java.jdbc :as sql]
            [web-service.constants :as constants]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                INTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; moved to user_helpers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                EXTERNAL APIS                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; get the specified user, as an HTTP response
(defn user-get
  [email-address target-user-email-address]

  ; let a user view their own information but not the information of others,
  ; unless they have the Manage Users access
  (let [access (set (get-user-access email-address))
        can-access (or (= target-user-email-address email-address)
                       (contains? access constants/manage-users))]
    (if can-access
      (let [user (get-user target-user-email-address)]
        ; log the activity in the session
        (log-detail email-address
                    constants/session-activity
                    (str constants/session-get-user " "
                         target-user-email-address))
        (if user
          (response {:response user})
          (not-found "User not found"))) ; inconceivable!
      (access-denied constants/manage-users))))


; list the users in the database, as an HTTP response
(defn user-list
  [email-address]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              constants/session-list-users)

  (let [access (set (get-user-access email-address))]
    (if (contains? access constants/manage-users)
      (response {:response (sql/query
                             (db)
                             ["select * from public.user"]
                             :row-fn :email_address)})
      (access-denied constants/manage-users))))


; list the access levels for the specified user, as an HTTP response
(defn user-access-list
  [email-address target-email-address]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-get-user-access " " target-email-address))

  ; let a user view their own information but not the information of others,
  ; unless they have the Manage Users access
  (let [access (set (get-user-access email-address))
        can-access (or (= email-address target-email-address)
                       (contains? access constants/manage-users))]
    (if can-access
      (response {:response (get-user-access target-email-address)})
      (access-denied constants/manage-users))))


; add the specified permission to the user, as an HTTP response
(defn user-access-add
  [email-address target-email-address access-level]

  ; log the activity in the session
  (log-detail email-address
              constants/session-activity
              (str constants/session-add-user-access " "
                   target-email-address " " access-level))

  (let [access (set (get-user-access email-address))]
    (if (contains? access constants/manage-users)
      (let
        [query (str "insert into public.user_to_user_access_level "
                    "(user_id, access_level_id) "
                    "values ("
                    "(select id from public.user where email_address=?), "
                    "(select id from public.user_access_level where description=?))")
         success (try (sql/execute! (db) [query
                                          target-email-address
                                          access-level])
                      true
                      (catch Exception e
                        (println (.getMessage e))
                        (println (.getMessage (.getNextException e)))
                        false))]

        ; if we successfully created the user access level, return a "created"
        ; status and invoke user-access-list
        ; otherwise, return a "conflict" status
        (if success
          (status (user-access-list email-address target-email-address) 201)
          (status (response {:response (str "User access for "
                                            target-email-address
                                            " already exists: "
                                            access-level)})
                  409)))
      (access-denied constants/manage-users))))
