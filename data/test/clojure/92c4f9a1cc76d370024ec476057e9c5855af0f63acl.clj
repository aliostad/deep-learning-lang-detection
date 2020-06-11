;; old namespace: com.sixsq.slipstream.ssclj.resources.common.authz
(ns com.sixsq.slipstream.auth.acl
  (:require
    [ring.util.response :as r]
    [com.sixsq.slipstream.util.response :as ru]
    [com.sixsq.slipstream.util.convert :as cu]
    [clojure.string :as str]))

(def rights-hierarchy (-> (make-hierarchy)
                          (derive ::all ::manage)
                          (derive ::all ::delete)
                          (derive ::all ::edit-acl)
                          (derive ::all ::view-acl)

                          (derive ::edit-acl ::edit-data)
                          (derive ::edit-acl ::view-acl)

                          (derive ::edit-data ::edit-meta)
                          (derive ::edit-data ::view-data)

                          (derive ::edit-meta ::view-meta)

                          (derive ::view-acl ::view-data)
                          (derive ::view-data ::view-meta)

                          ;; compatibility with old rights names
                          (derive ::all ::modify)
                          (derive ::modify ::view)
                          (derive ::modify ::delete)
                          (derive ::modify ::edit-acl)
                          (derive ::view ::view-acl)))

(defn- add-rights-entry
  [m kw]
  (-> m
      (assoc kw kw)
      (assoc (-> kw name str/upper-case (str/replace "-" "_")) kw)))

(def rights-keywords
  (reduce add-rights-entry {} (cons ::all (ancestors rights-hierarchy ::all))))

(def admin-rule
  {:principal "ADMIN"
   :type      "ROLE"
   :right     "ALL"})

(defn current-authentication
  "Extracts the current authentication (identity map) from the ring
   request.  Returns nil if there is no current identity."
  [{{:keys [current authentications]} :identity}]
  (or (get authentications current) {:identifier nil, :roles ["ANON"]}))

(defn extract-right
  "Given the identity map, this extracts the associated right from the
   given rule if it applies.  If the rule does not apply, then nil is
   returned."
  [{:keys [identity roles] :as id-map} {:keys [type principal right] :as rules}]
  (let [roles (set roles)
        right (get rights-keywords right)]
    (cond
      (roles "ADMIN") ::all
      (and (= type "USER") (= principal identity)) right
      (and (= type "ROLE") (roles principal)) right
      (and (= type "ROLE") (= principal "ANON")) right
      :else nil)))

(defn extract-rights
  "Returns a set containing all of the applicable rights from an ACL
   for the given identity map."
  [id-map {:keys [owner rules]}]
  (->> (concat [admin-rule (assoc owner :right "ALL")] rules)
       (map #(extract-right id-map %))
       (remove nil?)
       (set)))

(defn authorized-do?
  "Returns true if the ACL associated with the given resource permits the
   current user (in the request) the given action."
  [resource request action]
  (let [rights (extract-rights
                 (current-authentication request)
                 (cu/walk-clojurify (:acl resource)))
        action (get rights-keywords action)]
    (some #(isa? rights-hierarchy % action) rights)))

(defn can-do?
  "Determines if the ACL associated with the given resource permits the
   current user (in the request) the given action.  If the action is
   allowed, then the resource itself is returned.  If the action is not
   allowed then an 'unauthorized' response map is thrown."
  [resource request action]
  (if (authorized-do? resource request action)
    resource
    (throw (ru/ex-unauthorized (:resource-id resource)))))

(defn can-modify?
  "Determines if the resource can be modified by the user in the request.
   Returns the request on success; throws an error ring response on
   failure."
  [resource request]
  (can-do? resource request ::modify))

(defn can-view?
  "Determines if the resource can be modified by the user in the request.
   Returns the request on success; throws an error ring response on
   failure."
  [resource request]
  (can-do? resource request ::view))

(defn authorized-view?
  [resource request]
  (authorized-do? resource request ::view))

(defn default-acl
  "Provides a default ACL based on the authentication information.
   The ACL will have the identity as the owner with no other ACL
   rules.  The only exception is if the user is in the ADMIN
   group, then the owner will be ADMIN.  If there is no identity
   then returns nil."
  [{:keys [identity roles]}]
  (if identity
    (if (contains? (set roles) "ADMIN")
      {:owner {:principal "ADMIN"
               :type      "ROLE"}}
      {:owner {:principal identity
               :type      "USER"}})))

(defn add-acl
  "Adds the default ACL to the given resource if an ACL doesn't already
   exist."
  [{:keys [acl] :as resource} request]
  (assoc
    resource
    :acl
    (or acl (default-acl (current-authentication request)))))

