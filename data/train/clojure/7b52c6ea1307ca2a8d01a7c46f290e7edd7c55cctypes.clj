;; Provides a singular location by which the names of types and type instance identifiers can be 
;; defined for the base release.
(ns org.healthsciencessc.consent.common.types)

;; TYPES THAT ARE AVAILABLE IN THE BASE APPLICATION

(defmacro def-them-all [& types]
  `(do
     ~@(for [t types]
        `(def ~t ~(name t)))))

(def-them-all 
  organization
  user
  user-identity
  role
  language
  location
  group
  consenter
  role-mapping
  meta-item
  policy
  policy-definition
  endorsement
  endorsement-type
  form
  widget
  widget-property
  encounter
  session
  consent
  consent-meta-item
  consent-endorsement
  protocol
  protocol-version
  text-i18n
  system)

;; COMMON CODES USED THROUGHOUT THE APPLICATION.  IDENTIFIES UNIQUENESS WITHIN METADATA.

(def code-base-org "!DEFAULTORGANIZATION!")

(def code-role-superadmin "!sadmin!")
(def code-role-admin "!admin!")
(def code-role-collector "!collect!")
(def code-role-designer "!design!")
(def code-role-consentmanager "!manage!")
(def code-role-externalsystem "!csys!")

(def code-endorsement-type-witness "!witness.signature!")
(def code-endorsement-type-witness2 "!witness.signature.secondary!")

;; STANDARD STATUSES FOR FINALIZING RECORDS - ie: PROTOCOL VERSION, POLICY, POLICY DERPS, META-ITEM, etc
(def status-draft "Draft")
(def status-submitted "Submitted")
(def status-published "Published")
(def status-retired "Retired")

(defn draft?
  [record]
  (= status-draft (:status record)))

(defn submitted?
  [record]
  (= status-submitted (:status record)))

(defn published?
  [record]
  (= status-published (:status record)))

(defn retired?
  [record]
  (= status-retired (:status record)))
