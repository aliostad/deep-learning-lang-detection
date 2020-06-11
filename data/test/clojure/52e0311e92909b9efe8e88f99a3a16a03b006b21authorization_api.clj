(ns lupapalvelu.authorization-api
  "API for manipulating application.auth"
  (:require [taoensso.timbre :refer [debug error errorf]]
            [clojure.string :refer [blank? join trim split]]
            [swiss.arrows :refer [-<>>]]
            [monger.operators :refer :all]
            [sade.strings :as ss]
            [sade.core :refer [ok fail fail! unauthorized]]
            [sade.util :as util]
            [lupapalvelu.action :refer [defquery defcommand defraw update-application notify] :as action]
            [lupapalvelu.application :as application]
            [lupapalvelu.authorization :as auth]
            [lupapalvelu.authorization-messages] ; notification definitions
            [lupapalvelu.document.model :as model]
            [lupapalvelu.document.persistence :as doc-persistence]
            [lupapalvelu.domain :as domain]
            [lupapalvelu.mongo :as mongo]
            [lupapalvelu.notifications :as notifications]
            [lupapalvelu.roles :as roles]
            [lupapalvelu.states :as states]
            [lupapalvelu.user :as user]
            [lupapalvelu.permit :as permit]))

;;
;; Invites
;;

(defn- invites-with-application [application]
  (->>
    (domain/invites application)
    (map #(assoc % :application (select-keys application [:id :address :primaryOperation :municipality])))))

(defn- select-user-auths
  "Select auths for user by user-id and company-id."
  [{user-id :id :as user} {auth :auth :as application}]
  (let [company-auths  (auth/get-company-auths application user)
        personal-auths (auth/get-auths application user-id)]
    (assoc application :auth (remove nil? (concat company-auths personal-auths)))))

(defquery invites
  {:user-roles #{:applicant :authority :oirAuthority :financialAuthority}}
  [{{user-id :id {company-id :id company-role :role} :company :as user} :user}]
  (->> (mongo/select :applications
                     {$or [{:auth.invite.user.id user-id}
                           {:auth {$elemMatch {:invite.user.id company-id :company-role company-role}}}
                           {:auth {$elemMatch {:invite.user.id company-id :company-role {$exists false}}}}]
                      :state {$ne :canceled}}
                     [:auth :primaryOperation :address :municipality])
       (map (partial select-user-auths user))
       (mapcat invites-with-application)
       (ok :invites)))

(def settable-roles #{:writer :foreman :financialAuthority})
(def changeable-roles #{:writer :foreman})

(defn- valid-role [role]
  (settable-roles (keyword role)))

(defn send-invite! [{{:keys [email text documentName documentId path role notification]} :data
                     timestamp :created
                     inviter :user
                     application :application
                     :as command}]
  (let [email (ss/canonize-email email)
        existing-auth (auth/get-auth application (:id (user/get-user-by-email email)))
        existing-role (keyword (get-in existing-auth [:invite :role] (:role existing-auth)))]
    (cond
      (#{:reader :guest} existing-role)
      (fail :invite.already-has-reader-auth :existing-role existing-role)

      existing-auth
      (fail :invite.already-has-auth)

      :else
      (let [invited (user/get-or-create-user-by-email email inviter)
            auth    (auth/create-invite-auth inviter invited (:id application) role timestamp text documentName documentId path)
            email-template (case notification
                             "invite-to-prev-permit" :invite-to-prev-permit
                             "invite-financial-authority" :invite-financial-authority
                             :invite)]
        (update-application command
          {:auth {$not {$elemMatch {:invite.user.username (:email invited)}}}}
          {$push {:auth     auth}
           $set  {:modified timestamp}})
        (notifications/notify! email-template (assoc command :recipients [invited]))
        (ok)))))

(defn- role-validator [{{role :role} :data}]
  (when-not (valid-role role)
    (fail! :error.illegal-role :parameters role)))

(defcommand invite-with-role
  {:parameters [:id :email :text :documentName :documentId :path :role]
   :categories #{:documents}
   :input-validators [(partial action/non-blank-parameters [:email])
                      action/email-validator
                      role-validator]
   :states     (states/all-application-states-but [:canceled])
   :user-roles #{:applicant :authority}
   :pre-checks  [application/validate-authority-in-drafts
                 permit/is-not-archiving-project]
   :notified   true}
  [command]
  (send-invite! command))

(defcommand approve-invite
  {:parameters [id]
   :optional-parameters [invite-type]
   :user-roles #{:applicant}
   :user-authz-roles roles/default-authz-reader-roles
   :states     states/all-application-states}
  [{created :created  {user-id :id {company-id :id company-role :role} :company :as user} :user application :application :as command}]
  (let [auth-id       (cond (not (util/=as-kw invite-type :company)) user-id
                            (util/=as-kw company-role :admin)        company-id)
        auth          (->> (auth/get-auths application auth-id) (util/find-first :invite))
        approved-auth (auth/approve-invite-auth auth user created)]
    (when approved-auth
      (update-application command
        {:auth {$elemMatch {:invite.user.id auth-id}}}
        {$set {:modified created
               :auth.$   approved-auth}})
      (when-let [document-id (not-empty (get-in auth [:invite :documentId]))]
        (let [application (domain/get-application-as id user :include-canceled-apps? true)]
          ; Document can be undefined (invite's documentId is an empty string) in invite or removed by the time invite is approved.
          ; It's not possible to combine Mongo writes here, because only the last $elemMatch counts.
          (doc-persistence/do-set-user-to-document application document-id (:id user) (get-in auth [:invite :path]) created false)))
      (ok))))

(defn generate-remove-invalid-user-from-docs-updates [{docs :documents :as application}]
  (-<>> docs
    (map-indexed
      (fn [i doc]
        (->> (model/validate application doc)
          (filter #(= (:result %) [:err "application-does-not-have-given-auth"]))
          (map (comp (partial map name) :path))
          (map (comp (partial join ".") (partial concat ["documents" i "data"]))))))
    flatten
    (zipmap <> (repeat ""))))

(defn do-remove-auth [{application :application :as command} username]
  (let [username (ss/canonize-email username)
        user-pred #(when (and (= (:username %) username) (not= (:type %) "owner")) %)]
    (when (some user-pred (:auth application))
      (let [updated-app (update-in application [:auth] (fn [a] (remove user-pred a)))
            doc-updates (generate-remove-invalid-user-from-docs-updates updated-app)]
        (update-application command
          (merge
            {$pull {:auth {$and [{:username username}, {:type {$ne :owner}}]}}
             $set  {:modified (:created command)}}
            (when (seq doc-updates) {$unset doc-updates})))))))

(defcommand decline-invitation
  {:parameters [:id]
   :user-roles #{:applicant :authority}
   :user-authz-roles roles/default-authz-reader-roles
   :states     states/all-application-states}
  [command]
  (do-remove-auth command (get-in command [:user :username])))

;;
;; Auhtorizations
;;

(defcommand remove-auth
  {:parameters [:id username]
   :input-validators [(partial action/non-blank-parameters [:username])]
   :user-roles #{:applicant :authority}
   :states     (states/all-application-states-but [:canceled])
   :pre-checks [application/validate-authority-in-drafts]}
  [command]
  (do-remove-auth command username))

(defcommand change-auth
  {:parameters [:id userId role]
   :input-validators [(partial action/non-blank-parameters [:userId])
                      role-validator
                      (fn [{:keys [data user]}]
                        (when (= (:id user) (-> data :userId ss/trim))
                          (fail :error.unauthorized :cause "Own role can not be changes")))
                      ]
   :user-roles #{:applicant :authority}
   :states     (states/all-application-states-but [:canceled])
   :pre-checks [application/validate-authority-in-drafts
                (fn [command]
                  (when-let [user-id (get-in command [:data :userId])]
                    (if-let [auths (seq (auth/get-auths (:application command) user-id))]
                      (when-not (some changeable-roles (map (comp keyword :role) auths))
                        (fail :error.invalid-role :cause (map :role auths)))
                      (fail :error.user-not-found))))]}
  [{:keys [application] :as command}]
  (let [user-id (ss/trim userId)
        auths (auth/get-auths application user-id)
        roles (map :role auths)]

    (when (> (count auths) 1)
      (errorf "More than one authorization for user %s %s, will change first that is changeable"
             (-> auths first :username), roles))

    (update-application command
      {:auth {:$elemMatch {:id userId, :role {$in changeable-roles}}}}
      {$set {:auth.$.role role}})))

(defn- manage-unsubscription [{application :application user :user :as command} unsubscribe?]
  (let [username (get-in command [:data :username])]
    (if (or (= username (:username user))
            (some (partial = (:organization application)) (user/organization-ids-by-roles user #{:authority})))
      (update-application command
        {:auth {$elemMatch {:username username}}}
        {$set {:auth.$.unsubscribed unsubscribe?}})
      unauthorized)))

(defcommand unsubscribe-notifications
  {:parameters [:id :username]
   :input-validators [(partial action/non-blank-parameters [:id :username])]
   :user-roles #{:applicant :authority}
   :user-authz-roles roles/default-authz-reader-roles
   :states states/all-application-states
   :pre-checks [application/validate-authority-in-drafts]}
  [command]
  (manage-unsubscription command true))

(defcommand subscribe-notifications
  {:parameters [:id :username]
   :input-validators [(partial action/non-blank-parameters [:id :username])]
   :user-roles #{:applicant :authority}
   :user-authz-roles roles/default-authz-reader-roles
   :states states/all-application-states
   :pre-checks [application/validate-authority-in-drafts]}
  [command]
  (manage-unsubscription command false))
