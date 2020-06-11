;; Provides the reusable runnable? functions that work off the domain functions.
(ns org.healthsciencessc.consent.common.runnable
  (:require [org.healthsciencessc.consent.common.roles :as roles]))

;; Helper functions to check if a location is accessible for a user.
(defn can-collect-location-id
  [user location-id]
  (roles/consent-collector? user :location {:id location-id}))

(defn can-collect-location
  [user location]
  (can-collect-location-id user (:id location)))

;; Helper functions to check if a protocol/version/location is accessible for a user.
(defn can-design-org-id
  [user org-id]
  (roles/protocol-designer? user :organization {:id org-id}))

(defn can-design-location-id
  [user location-id]
  (roles/protocol-designer? user :location {:id location-id}))

(defn can-design-location
  [user location]
  (can-design-location-id user (:id location)))

(defn can-design-protocol
  [user protocol]
  (can-design-location user (:location protocol)))

(defn can-design-protocol-version
  [user protocol-version]
  (can-design-protocol user (:protocol protocol-version)))

;; Helper functions to check if an organization is accessible for an admin.
(defn can-admin-org-id
  [user org-id]
  (or (roles/superadmin? user) (roles/admin? user :organization {:id org-id})))

;; Helper functions to check if a protocol/version/location is accessible for a user.
(defn can-manage-org-id
  [user org-id]
  (roles/consent-manager? user :organization {:id org-id}))

(defn can-manage-location-id
  [user location-id]
  (roles/consent-manager? user :location {:id location-id}))

(defn can-manage-location
  [user location]
  (can-manage-location-id user (:id location)))

;; Functions that generate functions used in runnable statements.
(defn gen-designer-check
  "Creates a runnable? function that checks if a user is a protocol designer for a specific location."
  [userfn]
  (fn [ctx]
    (let [user (userfn ctx)]
      (roles/protocol-designer? user))))

(defn gen-collector-check
  "Creates a runnable? function that checks if a user is a consent collector for a specific location."
  [userfn]
  (fn [ctx]
    (let [user (userfn ctx)]
      (roles/consent-collector? user))))

(defn gen-designer-location-check
  "Creates a runnable? function that checks if a user is a protocol designer for a specific location."
  [userfn lookup-fn]
  (fn [ctx]
    (let [user (userfn ctx)
          location-id (lookup-fn ctx)]
      (can-design-location-id user location-id))))

(defn gen-designer-org-check
  "Creates a runnable? function that checks if a user is a protocol designer within an organization."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          org-id (lookupfn ctx)]
      (can-design-org-id user org-id))))

(defn gen-designer-record-check
  "Creates a runnable? function that checks if a user is a protocol designer within an organization."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          record (lookupfn ctx)
          org-id (get-in record [:organization :id])]
      (can-design-org-id user org-id))))

(defn gen-designer-protocol-check
  "Creates a runnable? function that checks if a user is a protocol designer for a specific protocol."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          record (lookupfn ctx)]
      (can-design-protocol user record))))

(defn gen-collector-location-check
  "Creates a runnable? function that checks if a user is a consent collector for a specific location."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          location-id (lookupfn ctx)]
      (can-collect-location-id user location-id))))

(defn gen-super-or-admin
  "Creates a runnable? function that checks if a user is a super admin or an admin"
  [userfn]
  (fn [ctx]
    (let [user (userfn ctx)]
      (or (roles/superadmin? user) (roles/admin? user)))))

(defn gen-super-or-admin-by-org
  "Creates a runnable? function that checks if a user is a super admin or an admin for an optional organziation."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          org-id (lookupfn ctx)
          user-org-id (get-in user [:organization :id])]
      (or (roles/superadmin? user)
          (and (roles/admin? user) 
               (or (nil? org-id)
                   (= org-id user-org-id)))))))

(defn gen-admin-record-check
  "Creates a runnable? function that checks if a user is a protocol designer within an organization."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)
          record (lookupfn ctx)
          org-id (get-in record [:organization :id])]
      (roles/admin? user :organization {:id org-id}))))

(defn gen-super-or-admin-record-check
  "Creates a runnable? function that checks if a user is a protocol designer within an organization."
  [userfn lookupfn]
  (fn [ctx]
    (let [user (userfn ctx)]
      (or (roles/superadmin? user)
          (let [record (lookupfn ctx)
                org-id (get-in record [:organization :id])]
            (roles/admin? user :organization {:id org-id}))))))
