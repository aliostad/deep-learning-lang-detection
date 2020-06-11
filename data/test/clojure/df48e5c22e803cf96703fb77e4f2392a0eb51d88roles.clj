(ns org.healthsciencessc.consent.common.roles
  (:use [org.healthsciencessc.consent.common types]))

(defn- submap-of?
  [smallmap bigmap]
  (= smallmap (select-keys bigmap (keys smallmap))))

(defn- constraint-filter
  "The filter used to reduce mappings with additional constraints."
  [acc [constraint-key constraint-map]]
  (filter #(submap-of? 
             constraint-map 
             (get % constraint-key)) acc))

(defn get-role-mappings
  "Allows you to retrieve role mappings from a user based on constraints applied to the provided users role-mappings"
  [user & {:as constraints}]
  (reduce constraint-filter (:role-mappings user) constraints))

(defn has-role?
  [user role & {:as constraints}]
  (let [potential-role-mappings 
        (->>
          (:role-mappings user)
          (filter #(submap-of? role (:role %))))
        matching-mappings
        (reduce
          (fn [acc [constraint-key constraint-map]]
            (filter #(submap-of? 
                       constraint-map 
                       (get % constraint-key)) acc))
          potential-role-mappings
          constraints)]
     (if (seq matching-mappings)
       true)))

(defn superadmin?
  [user & constraints]
  (apply has-role? user {:code code-role-superadmin} constraints))

(defn admin?
  [user & constraints]
  (apply has-role? user {:code code-role-admin} constraints))

(defn consent-manager?
  [user & constraints]
  (apply has-role? user {:code code-role-consentmanager} constraints))

(defn consent-collector?
  [user & constraints]
  (apply has-role? user {:code code-role-collector} constraints))

(defn protocol-designer?
  [user & constraints]
  (apply has-role? user {:code code-role-designer} constraints))

(defn system?
  [user & constraints]
  (apply has-role? user {:code code-role-externalsystem} constraints))

(defn consent-collector-mappings
  [user & constraints]
  (apply get-role-mappings user :role {:code code-role-collector} constraints))

(defn protocol-designer-mappings
  [user & constraints]
  (apply get-role-mappings user :role {:code code-role-designer} constraints ))

(defn consent-manager-mappings
  [user & constraints]
  (apply get-role-mappings user :role {:code code-role-consentmanager} constraints ))


;; Helper functions to determine if a user as a specific role for an organization or location.
(defn can-collect-org-id?
  [user org-id]
  (consent-collector? user :organization {:id org-id}))

(defn can-collect-org?
  [user org]
  (can-collect-org-id? user (:id org)))

(defn can-collect-location-id?
  [user location-id]
  (consent-collector? user :location {:id location-id}))

(defn can-collect-location?
  [user location]
  (can-collect-location-id? user (:id location)))

(defn can-collect-protocol?
  [user protocol]
  (can-collect-location? user (:location protocol)))

(defn can-collect-protocol-version?
  [user protocol-version]
  (and (published? protocol-version) (can-collect-protocol? user (:protocol protocol-version))))

(defn can-design-org-id?
  [user org-id]
  (protocol-designer? user :organization {:id org-id}))

(defn can-design-org?
  [user org]
  (can-design-org-id? user (:id org)))

(defn can-design-location-id?
  [user location-id]
  (protocol-designer? user :location {:id location-id}))

(defn can-design-location?
  [user location]
  (can-design-location-id? user (:id location)))

(defn can-design-protocol?
  [user protocol]
  (can-design-location? user (:location protocol)))

(defn can-design-protocol-version?
  [user protocol-version]
  (can-design-protocol? user (:protocol protocol-version)))

(defn can-admin-org-id?
  [user org-id]
  (or (superadmin? user) (admin? user :organization {:id org-id})))

(defn can-admin-org?
  [user org]
  (can-admin-org-id? user (:id org)))

(defn can-manage-org-id?
  [user org-id]
  (consent-manager? user :organization {:id org-id}))

(defn can-manage-org?
  [user org]
  (can-manage-org-id? user (:id org)))

(defn can-manage-location-id?
  [user location-id]
  (consent-manager? user :location {:id location-id}))

(defn can-manage-location?
  [user location]
  (can-manage-location-id? user (:id location)))
