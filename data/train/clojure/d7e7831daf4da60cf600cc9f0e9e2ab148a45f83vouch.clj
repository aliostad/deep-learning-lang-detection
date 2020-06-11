;; Provides functions used throughout the project to determine if a user can
;; perform tasks based on their roles and the context of the request.
(ns org.healthsciencessc.consent.services.vouch
  (:require [org.healthsciencessc.consent.services.data :as data]
            [org.healthsciencessc.consent.services.session :as session]
            [org.healthsciencessc.consent.common.roles :as roles]
            [org.healthsciencessc.consent.common.tenancy :as tenancy]
            [org.healthsciencessc.consent.common.types :as types]))

;; Vouching that returns true or false
(defn admins-org?
  [ctx]
  (let [user (session/current-user ctx)
        org-id (get-in ctx [:query-params :organization])]
    (roles/can-admin-org-id? user org-id)))

(defn designs-org?
  [ctx]
  (let [user (session/current-user ctx)
        org-id (get-in ctx [:query-params :organization])]
    (roles/can-design-org-id? user org-id)))

(defn manages-org?
  [ctx]
  (let [user (session/current-user ctx)
        org-id (get-in ctx [:query-params :organization])]
    (roles/can-design-org-id? user org-id)))

(defn collects-org?
  [ctx]
  (let [user (session/current-user ctx)
        org-id (get-in ctx [:query-params :organization])]
    (roles/can-collect-org-id? user org-id)))

(defn admins-location?
  [ctx]
  (let [user (session/current-user ctx)
        loc-id (get-in ctx [:query-params :location])
        location (data/find-record types/location loc-id) ]
    (roles/can-admin-org? user (:organization location))))

(defn designs-location?
  [ctx]
  (let [user (session/current-user ctx)
        loc-id (get-in ctx [:query-params :location])]
    (roles/can-design-location-id? user loc-id)))

(defn manages-location?
  [ctx]
  (let [user (session/current-user ctx)
        loc-id (get-in ctx [:query-params :location])]
    (roles/can-manage-location-id? user loc-id)))

(defn collects-location?
  [ctx]
  (let [user (session/current-user ctx)
        loc-id (get-in ctx [:query-params :location])]
    (roles/can-collect-location-id? user loc-id)))


;; Vouching that returns the targeted record
(defn views-type
  [ctx type type-id rolefn]
  (let [user (session/current-user ctx)
        record (data/find-record type type-id)]
    (if (and (rolefn user)
             (or (tenancy/belongs-to-base? record)
                 (tenancy/only-my-org? user [record])))
      record)))

(defn views-type-as-designer
  [ctx type type-id]
  (views-type ctx type type-id roles/protocol-designer?))


(defn designs-type
  [ctx type type-id]
  (let [user (session/current-user ctx)
        record (data/find-record type type-id)]
    (if (roles/can-design-org? user (:organization record))
      record)))

(defn designs-location
  ([ctx] (designs-location ctx (get-in ctx [:query-params :location])))
  ([ctx location-id]
    (let [user (session/current-user ctx)
          location (data/find-record types/location location-id)]
      (if (roles/can-design-location? user location)
        location))))

(defn designs-protocol
  ([ctx] (designs-protocol ctx (get-in ctx [:query-params :protocol])))
  ([ctx protocol-id]
    (let [user (session/current-user ctx)
          protocol (data/find-record types/protocol protocol-id)]
      (if (roles/can-design-location? user (:location protocol))
        protocol))))

(defn designs-protocol-version
  ([ctx] (designs-protocol-version ctx (get-in ctx [:query-params :protocol-version])))
  ([ctx protocol-version-id]
    (let [user (session/current-user ctx)
          protocol-version (data/find-record types/protocol-version protocol-version-id)]
      (if (roles/can-design-location? user (:location (:protocol protocol-version)))
        protocol-version))))

;;
(defn collects-location
  ([ctx] (collects-location ctx (get-in ctx [:query-params :location])))
  ([ctx location-id]
    (let [user (session/current-user ctx)
          location (data/find-record types/location location-id)]
      (if (roles/can-collect-location? user location)
        location))))

(defn collects-encounter
  ([ctx] (collects-encounter ctx (get-in ctx [:query-params :encounter])))
  ([ctx encounter-id]
    (let [user (session/current-user ctx)
          encounter (data/find-record types/encounter encounter-id)]
      (if (roles/can-collect-location? user (:location encounter))
        encounter))))

;;
(defn manages-location
  ([ctx] (manages-location ctx (get-in ctx [:query-params :location])))
  ([ctx location-id]
    (let [user (session/current-user ctx)
          location (data/find-record types/location location-id)]
      (if (roles/can-manage-location? user location)
        location))))

(defn manages-encounter
  ([ctx] (manages-encounter ctx (get-in ctx [:query-params :encounter])))
  ([ctx encounter-id]
    (let [user (session/current-user ctx)
          encounter (data/find-record types/encounter encounter-id)]
      (if (roles/can-manage-location? user (:location encounter))
        encounter))))

(defn collects-or-manages
  ([ctx] (collects-or-manages ctx (get-in ctx [:query-params :organization])))
  ([ctx organization-id]
    (let [user (session/current-user ctx)
          organization (data/find-record types/organization (or organization-id (get-in user [:organization :id])))]
      (if (or (roles/can-collect-org? user organization) (roles/can-manage-org? user organization))
        organization))))

(defn collects-or-manages-location
  ([ctx] (collects-or-manages-location ctx (get-in ctx [:query-params :location])))
  ([ctx location-id]
    (let [user (session/current-user ctx)
          location (data/find-record types/location location-id)]
      (if (or (roles/can-collect-location? user location) (roles/can-manage-location? user location))
        location))))

(defn collects-or-manages-encounter
  ([ctx] (collects-or-manages-encounter ctx (get-in ctx [:query-params :encounter])))
  ([ctx encounter-id]
    (let [user (session/current-user ctx)
          encounter (data/find-record types/encounter encounter-id)
          location (:location encounter)]
      (if (or (roles/can-collect-location? user location) (roles/can-manage-location? user location))
        encounter))))

(defn collects-or-manages-consenter
  ([ctx] (collects-or-manages-consenter ctx (get-in ctx [:query-params :consenter])))
  ([ctx consenter-id]
    (let [user (session/current-user ctx)
          consenter (data/find-record types/consenter consenter-id)
          organization (:organization consenter)]
      (if (or (roles/can-collect-org? user organization) (roles/can-manage-org? user organization))
        consenter))))

(defn collects-or-designs-location
  ([ctx] (collects-or-designs-location ctx (get-in ctx [:query-params :location])))
  ([ctx location-id]
    (let [user (session/current-user ctx)
          location (data/find-record types/location location-id)]
      (if (or (roles/can-collect-location? user location) (roles/can-design-location? user location))
        location))))

(defn collects-or-designs-protocol-versions
  ([ctx] (collects-or-designs-protocol-versions ctx (get-in ctx [:query-params :protocol-version])))
  ([ctx protocol-version-ids]
    (let [user (session/current-user ctx)
          ids (if (coll? protocol-version-ids) (distinct protocol-version-ids) [protocol-version-ids])
          protocol-versions (for [id ids] (data/find-record types/protocol-version id))
          authed-versions (filter #(or (roles/can-collect-protocol-version? user %)
                                       (roles/can-design-protocol-version? user %)) protocol-versions)]
      (if (= (count protocol-versions) (count authed-versions))
        protocol-versions))))
