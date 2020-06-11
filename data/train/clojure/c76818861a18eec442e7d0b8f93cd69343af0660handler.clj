(ns ovation.handler
  (:require [compojure.api.sweet :refer :all]
            [compojure.api.routes :refer [path-for*]]
            [compojure.route :as route]
            [ring.util.http-response :refer [created ok no-content accepted not-found unauthorized bad-request conflict temporary-redirect]]
            [ring.middleware.cors :refer [wrap-cors]]
            [ring.logger :refer [wrap-with-logger]]
            [ovation.middleware.raygun :refer [wrap-raygun-handler]]
            [slingshot.slingshot :refer [try+ throw+]]
            [clojure.string :refer [lower-case capitalize join]]
            [ovation.schema :refer :all]
            [ovation.route-helpers :refer [annotation get-resources post-resources get-resource post-resource put-resource delete-resource rel-related relationships post-revisions* get-head-revisions* move-contents*]]
            [ovation.config :as config]
            [ovation.core :as core]
            [ovation.middleware.auth :refer [wrap-auth]]
            [ovation.links :as links]
            [ovation.audit]
            [ovation.search :as search]
            [ovation.breadcrumbs :as breadcrumbs]
            [ovation.request-context :as request-context]
            [schema.core :as s]
            [ovation.teams :as teams]
            [new-reliquary.ring :refer [wrap-newrelic-transaction]]
            [ovation.prov :as prov]
            [buddy.auth.backends.token :refer [jws-backend]]
            [buddy.auth.middleware :refer [wrap-authentication]]
            [buddy.auth :refer [authenticated?]]
            [buddy.auth.accessrules :refer [wrap-access-rules]]
            [ring.logger :as ring.logger]
            [ovation.revisions :as revisions]
            [ovation.util :as util]
            [ovation.routes :as routes]
            [ovation.request-context :as request-context]
            [ovation.authz :as authz]
            [clojure.core.async :refer [chan]]
            [ovation.storage :as storage]
            [ovation.auth :as auth]
            [clojure.java.io :as io]
            [ovation.constants :as k]
            [ring.logger.messages :refer [request-details]]
            [ring.logger.protocols :refer [info]]
            [ovation.audit :as audit]
            [clojure.string :as string]
            [ovation.annotations :as annotations]
            [clojure.tools.logging :as logging]))


(def rules [{:pattern        #"^/api.*"
             :handler        {:or [{:and [auth/authenticated-service-account? (authz/require-scope k/READ-GLOBAL-SCOPE)]}
                                   auth/authenticated-user-account?]}
             :request-method :get}
            {:pattern        #"^/api.*"
             :handler        {:or [{:and [auth/authenticated-service-account? (authz/require-scope k/WRITE-GLOBAL-SCOPE)]}
                                   auth/authenticated-user-account?]}
             :request-method [:put :post :delete]}
            {:pattern #"^/api.*"
             :handler auth/authenticated-user-account?}])

(def DESCRIPTION (slurp (io/file (io/resource "description.md"))))

;;; --- Routes --- ;;;
(defroutes static-resources
  (route/resources "/public"))

(defn create-app [database authz search]
  (let [db        database
        es-client (:client search)]
    (api
      {:swagger {:ui   "/"
                 :spec "/swagger.json"
                 :data {:info {
                               :version        "2.0.0"
                               :title          "Ovation"
                               :description    DESCRIPTION
                               :contact        {:name "Ovation"
                                                :url  "https://www.ovation.io"}
                               :termsOfService "https://app-services.ovation.io/terms_of_service"}
                        :tags [{:name "entities" :description "Generic entity operations"}
                               {:name "activities" :description "Describe inputs and outputs of a procedure"}
                               {:name "projects" :description "Manage Projects"}
                               {:name "folders" :description "Mange Folders"}
                               {:name "files" :description "Manage Files"}
                               {:name "sources" :description "Manage Sources, the subject of measurements"}
                               {:name "users" :description "Get information about Users"}
                               {:name "annotations" :description "Per-user annotations"}
                               {:name "links" :description "Relationships between entities"}
                               {:name "provenance" :description "Provenance graph"}
                               {:name "teams" :description "Manage collaborations"}
                               {:name "ui" :description "Support for Web UI"}
                               {:name "search" :description "Search Ovation"}
                               {:name "zip" :description "Download ZIP archive"}
                               {:name "admin" :description "Manage organizations and groups"}
                               {:name "organizations" :description "Organizations"}
                               {:name "groups" :description "User Groups within an Organization"}
                               {:name "auth" :description "Authorization & permissions"}]}}}


      (middleware [[wrap-cors
                    :access-control-allow-origin #".+"      ;; Allow from any origin
                    :access-control-allow-methods [:get :put :post :delete :options]
                    :access-control-allow-headers [:accept :content-type :authorization :origin]]

                   [wrap-authentication (jws-backend {:secret               config/JWT_SECRET
                                                      :options              {:alg :hs256}
                                                      :token-name           "Bearer"
                                                      :unauthorized-handler authz/unauthorized-response})]

                   [wrap-access-rules {:rules    rules
                                       :on-error authz/unauthorized-response}]

                   wrap-auth

                   audit/add-request-id

                   [ring.logger/wrap-with-logger {:printer :audit-printer
                                                  :logger  (audit/make-logger)}]

                   [wrap-raygun-handler (config/config :raygun-api-key)]

                   wrap-newrelic-transaction]



                  (undocumented
                    static-resources)

        (GET "/healthz" request
          (ok "Alive!"))

        (context "/api" []
          (context "/v1" []
            (context "/o" []
              :tags ["admin"]
              (GET "/" request
                :name :get-organizations
                :return {:organizations [Organization]}
                :summary "Returns all organizations for the authenticated user"
                (ok (authz/get-organizations authz (request-context/make-context request nil nil))))

              (POST "/" request
                :name :post-organization
                :return {:organization Organization}
                :body [body {:organization NewOrganization}]
                :summary "Create a new Organization"
                (let [ctx (request-context/make-context request nil nil)
                      org (authz/create-organization authz ctx body)]
                  (created (get-in org [:organization :links :self]) org)))

              (context "/:org" []
                :path-params [org :- s/Int]

                (GET "/" request
                  :name :get-organization
                  :return {:organization Organization}
                  :summary "Get an Organization"
                  (ok (authz/get-organization authz (request-context/make-context request org authz))))

                (PUT "/" request
                  :name :put-organization
                  :return {:organization Organization}
                  :body [body {:organization Organization}]
                  :summary "Get an Organization"
                  (ok (authz/update-organization authz (request-context/make-context request org authz) body)))

                (DELETE "/" request
                  :name :delete-organization
                  :return {}
                  :summary "Delete an Organization. BE CAREFUL!"
                  (let [ctx (request-context/make-context request org authz)
                        _ (authz/delete-organization authz ctx)]
                    (no-content)))

                (context "/stats" []
                  :tags ["admin"]
                  (GET "/" request
                    :name :get-stats
                    :return {:stats [{:id              Id
                                      :organization_id Id
                                      :usage           s/Num}]}
                    :summary "Get storage usage statistics"
                    (let [ctx (request-context/make-context request org authz)
                          ch  (chan)]
                      (ok {:stats (util/<?? (storage/get-organization-storage ctx db org ch))}))))

                (context "/authorizations" []
                  :tags ["auth"]
                  (GET "/" request
                    :name :get-authorizations
                    :return {:authorization {:id           Id
                                             :user         {:id   Id
                                                            :uuid (s/either s/Uuid s/Str)}
                                             :behaviors    {s/Keyword {:create s/Bool
                                                                       :read   s/Bool
                                                                       :update s/Bool
                                                                       :delete s/Bool}}
                                             :organization {:id   Id
                                                            :role s/Str}
                                             :teams        {s/Keyword {:id   Id
                                                                       :uuid (s/either (s/eq nil) s/Uuid s/Str)
                                                                       :role (s/either (s/eq nil) s/Str)}}}}
                    :summary "Get current user's authorizations"
                    (ok (authz/get-authorization authz (request-context/make-context request org authz)))))

                (context "/memberships" []
                  :tags ["admin"]
                  (GET "/" request
                    :name :get-org-memberships
                    :return {:organization-memberships [OrganizationMembership]}
                    :summary "Get organization users"
                    (ok (authz/get-organization-memberships authz (request-context/make-context request org authz))))

                  (POST "/" request
                    :name :post-org-membership
                    :return {:organization-membership OrganizationMembership}
                    :body [body {:organization-membership NewOrganizationMembership}]
                    :summary "Add a user to the organization"
                    (let [ctx (request-context/make-context request org authz)
                          membership (authz/create-organization-membership authz ctx body)]
                      (created (get-in membership [:organization-membership :links :self]) membership)))

                  (context "/:id" []
                    :path-params [id :- s/Str]
                    (GET "/" request
                      :name :get-org-membership
                      :return {:organization-membership OrganizationMembership}
                      :summary "Get the organization membership for a user"
                      (ok (authz/get-organization-membership authz (request-context/make-context request org authz) id)))

                    (PUT "/" request
                      :name :put-org-membership
                      :return {:organization-membership OrganizationMembership}
                      :body [body {:organization-membership OrganizationMembership}]
                      :summary "Update the organization membership for a user"
                      (ok (authz/put-organization-membership authz (request-context/make-context request org authz) id body)))

                    (DELETE "/" request
                      :name :delete-org-membership
                      :return {}
                      :summary "Delete the organization membership for a user"
                      (let [_ (authz/delete-organization-membership authz (request-context/make-context request org authz) id)]
                        (no-content)))))

                (context "/groups" []
                  :tags ["admin"]
                  (GET "/" request
                    :name :get-org-groups
                    :return {:organization-groups [OrganizationGroup]}
                    :summary "Get organization groups"
                    (ok (authz/get-organization-groups authz (request-context/make-context request org authz))))

                  (POST "/" request
                    :name :post-org-group
                    :return {:organization-group OrganizationGroup}
                    :body [body {:organization-group NewOrganizationGroup}]
                    :summary "Add a group to the organization"
                    (let [ctx (request-context/make-context request org authz)
                          group (authz/create-organization-group authz ctx body)]
                      (created (get-in group [:organization-group :links :self]) group)))

                  (context "/:id" []
                    :path-params [id :- s/Str]
                    (GET "/" request
                      :name :get-org-group
                      :return {:organization-group OrganizationGroup}
                      :summary "Get a group"
                      (ok (authz/get-organization-group authz (request-context/make-context request org authz) id)))

                    (PUT "/" request
                      :name :put-org-group
                      :return {:organization-group OrganizationGroup}
                      :body [body {:organization-group OrganizationGroup}]
                      :summary "Update a group"
                      (ok (authz/put-organization-group authz (request-context/make-context request org authz) id body)))

                    (DELETE "/" request
                      :name :delete-org-group
                      :return {}
                      :summary "Delete a group"
                      (let [_ (authz/delete-organization-group authz (request-context/make-context request org authz) id)]
                        (no-content)))

                    (context "/memberships" []
                      :tags ["admin"]
                      (GET "/" request
                        :name :get-groups-memberships
                        :return {:group-memberships [OrganizationGroupMembership]}
                        :summary "Get groups members"
                        (ok (authz/get-organization-groups-memberships authz (request-context/make-context request org authz) id)))

                      (POST "/" request
                        :name :post-group-membership
                        :return {:group-membership OrganizationGroupMembership}
                        :body [body {:group-membership NewOrganizationGroupMembership}]
                        :summary "Add a user to the group"
                        (let [ctx    (request-context/make-context request org authz)
                              result (authz/create-organization-group-membership authz ctx body)]
                          (created (get-in result [:links :self]) result)))

                      (context "/:membership-id" []
                        :path-params [membership-id :- s/Str]
                        (GET "/" request
                          :name :get-group-membership
                          :return {:group-membership OrganizationGroupMembership}
                          :summary "Get a group membership"
                          (ok (authz/get-organization-group-membership authz (request-context/make-context request org authz) membership-id)))

                        (PUT "/" request
                          :name :put-group-membership
                          :return {:group-membership OrganizationGroupMembership}
                          :body [body {:group-membership OrganizationGroupMembership}]
                          :summary "Update a membership"
                          (ok (authz/put-organization-group-membership authz (request-context/make-context request org authz) membership-id body)))

                        (DELETE "/" request
                          :name :delete-group-membership
                          :return {}
                          :summary "Delete a group membereship to remove the associated user from the group"
                          (let [_ (authz/delete-organization-group-membership authz (request-context/make-context request org authz) membership-id)]
                            (no-content)))))))

                (context "/annotations" []
                  :tags ["annotations"]
                  (context "/:id" []
                    :path-params [id :- s/Str]
                    (GET "/" request
                      :name :get-annotation
                      :return {:annotation GenericAnnotation}
                      :summary "Gets a single Annotation record with :id"
                      :responses {404 {:schema JsonApiError :description "Not found"}}
                      (let [ctx (request-context/make-context request org authz)]
                        (if-let [annotation (core/get-values ctx db [id])]
                          (if-let [annotation (first annotation)]
                            (ok {:annotation annotation})
                            (not-found {:errors {:detail "Not found"}}))
                          (not-found {:errors {:detail "Not found"}}))))))

                (context "/entities" []
                  :tags ["entities"]
                  (context "/:id" []
                    :path-params [id :- s/Str]
                    (GET "/" request
                      :name :get-entity
                      :query-params [{trash :- (s/maybe s/Bool) false}
                                     {includes :- (s/maybe s/Str) nil}]
                      :return {:entity                    TrashedEntity
                               (s/optional-key :includes) [GenericAnnotation]}
                      :responses {404 {:schema JsonApiError :description "Not found"}}
                      :summary "Returns entity with :id. If include-trashed is true, result includes entity even if it's in the trash."
                      (let [ctx (request-context/make-context request org authz)]
                        (if-let [entity (core/get-entity ctx db id :include-trashed trash)]
                          (if (= includes "annotations")
                            (let [incl                [k/TAGS k/PROPERTIES k/NOTES k/TIMELINE_EVENTS]
                                  annotation-includes (vec (mapcat #(annotations/get-annotations ctx db [id] %) incl))]
                              (ok {:entity   entity
                                   :includes annotation-includes}))
                            (ok {:entity entity}) )
                          (not-found {:errors {:detail "Not found"}}))))
                    (DELETE "/" request
                      :name :delete-entity
                      :return {:entity TrashedEntity}
                      :summary "Deletes entity with :id. Deleted entities can be restored."
                      (try+
                        (let [ctx (request-context/make-context request org authz)]
                          (accepted {:entity (first (core/delete-entities ctx db [id]))}))
                        (catch [:type :ovation.auth/unauthorized] err
                          (unauthorized {:errors {:detail "Delete not authorized"}}))))
                    (PUT "/restore" request
                      :name :restore-entity
                      :return {:entity Entity}
                      :body [body {:entity TrashedEntityUpdate}]
                      :summary "Restores a deleted entity from the trash."
                      (try+
                        (let [ctx (request-context/make-context request org authz)]
                          (ok {:entity (first (core/restore-deleted-entities ctx db [id]))}))
                        (catch [:type :ovation.auth/unauthorized] err
                          (unauthorized {:errors {:detail "Restore` not authorized"}}))))

                    (context "/annotations" []
                      :tags ["annotations"]
                      :name :annotations
                      (annotation db org authz id "keywords" "tags" TagRecord TagAnnotation)
                      (annotation db org authz id "properties" "properties" PropertyRecord PropertyAnnotation)
                      (annotation db org authz id "timeline events" "timeline_events" TimelineEventRecord TimelineEventAnnotation)
                      (annotation db org authz id "notes" "notes" NoteRecord NoteAnnotation))))


                (context "/relationships" []
                  :tags ["links"]
                  :path-params [org :- s/Int]
                  (context "/:id" []
                    :path-params [id :- s/Str]
                    (GET "/" request
                      :name :get-relation
                      :return {:relationship LinkInfo}
                      :summary "Relationship document"
                      (let [ctx (request-context/make-context request org authz)]
                        (ok {:relationship (first (core/get-values ctx db [id] :routes (::request-context/routes ctx)))})))
                    (DELETE "/" request
                      :name :delete-relation
                      :return {:relationship LinkInfo}
                      :summary "Removes relationship"
                      (let [ctx          (request-context/make-context request org authz)
                            relationship (first (core/get-values ctx db [id]))]
                        (if relationship
                          (let [source (first (core/get-entities ctx db [(:source_id relationship)]))]
                            (accepted {:relationships (links/delete-links ctx db
                                                        source
                                                        (:_id relationship))}))
                          (not-found {:errors {:detail "Not found"}}))))))

                (context "/projects" []
                  :tags ["projects"]

                  (GET "/" request
                    :name :all-projects
                    :return {:projects [Project]}
                    :query-params [{organization_group_id :- Id nil}
                                   {organization_membership_id :- Id nil}]
                    :summary "Gets all top-level projects"
                    (let [ctx       (request-context/make-context request org authz)
                          group-id  organization_group_id
                          member-id organization_membership_id]
                      (cond
                        group-id (let [project-ids (authz/get-organization-group-project-ids authz ctx group-id)
                                       entities    (core/get-entities ctx db project-ids)]
                                   (ok {:projects entities}))
                        member-id (let [project-ids (authz/get-organization-member-project-ids authz ctx member-id)
                                        entities    (core/get-entities ctx db project-ids)]
                                    (ok {:projects entities}))
                        :else (let [entities (core/of-type ctx db "Project")]
                                (ok {:projects entities})))))


                  (post-resources db org authz "Project" [NewProject])
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "Project" id)
                    (post-resource db org authz "Project" id [NewFolder NewFile NewChildActivity])
                    (put-resource db org authz "Project" id)
                    (delete-resource db org authz "Project" id)

                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "Project" id rel)
                      (relationships db org authz "Project" id rel))))


                (context "/sources" []
                  :tags ["sources"]
                  (get-resources db org authz "Source" Source)
                  (post-resources db org authz "Source" [NewSource])
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "Source" id)
                    (post-resource db org authz "Source" id [NewSource])
                    (put-resource db org authz "Source" id)
                    (delete-resource db org authz "Source" id)

                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "Source" id rel)
                      (relationships db org authz "Source" id rel))))


                (context "/activities" []
                  :tags ["activities"]
                  (get-resources db org authz "Activity" Activity)
                  (post-resources db org authz "Activity" [NewActivity])
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "Activity" id)
                    (put-resource db org authz "Activity" id)
                    (delete-resource db org authz "Activity" id)

                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "Activity" id rel)
                      (relationships db org authz "Activity" id rel))))

                (context "/folders" []
                  :tags ["folders"]
                  (get-resources db org authz "Folder" Folder)
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "Folder" id)
                    (post-resource db org authz "Folder" id [NewFolder NewFile])
                    (put-resource db org authz "Folder" id)
                    (delete-resource db org authz "Folder" id)
                    (POST "/move" request
                      :name :move-folder
                      :return {s/Keyword (s/either File Folder)
                               :links    [{s/Keyword s/Any}]
                               :updates  [{s/Keyword s/Any}]}
                      :summary "Move folder from source folder to destination folder"
                      :body [info {:source      s/Str
                                   :destination s/Str}]
                      (let [ctx (request-context/make-context request org authz)]
                        (created (routes/self-route ctx "folder" id)
                          (move-contents* request db org authz id info))))

                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "Folder" id rel)
                      (relationships db org authz "Folder" id rel))))


                (context "/files" []
                  :tags ["files"]
                  (get-resources db org authz "File" File)
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "File" id)
                    (POST "/" request
                      :name :create-file-entity
                      :return CreateRevisionResponse
                      :body [revisions {:entities [NewRevision]}]
                      :summary "Creates a new downstream Revision from the current HEAD Revision"
                      (let [ctx (request-context/make-context request org authz)]
                        (created (routes/heads-route2 ctx id)
                          (post-revisions* ctx db id (:entities revisions)))))

                    (POST "/move" request
                      :name :move-file
                      :return {s/Keyword (s/either File Folder)
                               :links    [{s/Keyword s/Any}]
                               :updates  [{s/Keyword s/Any}]}
                      :summary "Move file from source folder to destination folder"
                      :body [info {:source      s/Str
                                   :destination s/Str}]
                      (let [ctx (request-context/make-context request org authz)]
                        (created (routes/self-route ctx "file" id)
                          (move-contents* request db org authz id info))))

                    (GET "/heads" request
                      :name :file-head-revisions
                      :return {:revisions [Revision]}
                      :summary "Gets the HEAD revision(s) for this file"
                      (get-head-revisions* request db org authz id))
                    (put-resource db org authz "File" id)
                    (delete-resource db org authz "File" id)

                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "File" id rel)
                      (relationships db org authz "File" id rel))))


                (context "/revisions" []
                  :tags ["files"]
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (get-resource db org authz "Revision" id)
                    (put-resource db org authz "Revision" id)
                    (delete-resource db org authz "Revision" id)
                    (POST "/" request
                      :name :create-revision-entity
                      :return CreateRevisionResponse
                      :body [revisions [NewRevision]]
                      :summary "Creates a new downstream Revision"
                      (let [ctx (request-context/make-context request org authz)]
                        (created (routes/targets-route ctx "revision" id "revisions")
                          (post-revisions* ctx db id revisions))))
                    (PUT "/upload-complete" request
                      :name :upload-complete
                      :summary "Indicates upload is complete and updates metadata from S3 for this Revision"
                      :return {:revision Revision}
                      (let [ctx      (request-context/make-context request org authz)
                            revision (core/get-entity ctx db id)]
                        (ok {:revision (revisions/update-metadata ctx db revision)})))
                    (PUT "/upload-failed" request
                      :name :upload-failed
                      :summary "Indicates upload failed and updates the File status"
                      :return {:revision Revision
                               :file     File}
                      (let [ctx      (request-context/make-context request org authz)
                            revision (first (core/get-entities ctx db [id]))
                            result   (revisions/record-upload-failure ctx db revision)]
                        (ok {:revision (:revision result)
                             :file     (:file result)})))
                    (context "/links/:rel" []
                      :path-params [rel :- s/Str]

                      (rel-related db org authz "Revision" id rel)
                      (relationships db org authz "Revision" id rel))))



                (context "/prov" []
                  :tags ["provenance"]
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (GET "/" request
                      :name :entity-provenance
                      :return {:provenance [{:_id      s/Uuid
                                             :type     s/Str
                                             :name     s/Str
                                             s/Keyword [{:_id s/Uuid :name s/Str :type s/Str}]}]}
                      :summary "Local provenance for a single entity"
                      (let [ctx    (request-context/make-context request org authz)
                            result (prov/local ctx db [id])]
                        (ok {:provenance result})))))

                (context "/teams" []
                  :tags ["teams"]
                  (context "/:id" []
                    :path-params [id :- s/Str]

                    (GET "/" request
                      :name :get-team
                      :return {:team Team}
                      :summary "Gets Project Team"
                      (let [ctx (request-context/make-context request org authz)]
                        (ok (teams/get-team* ctx db id))))

                    (context "/team_groups" []
                      (GET "/" request
                        :name :get-team-groups
                        :return {:team-groups [TeamGroup]}
                        :summary "Gets groups that belong to this team"
                        (let [ctx (request-context/make-context request org authz)]
                          (ok (authz/get-team-groups authz ctx id))))

                      (POST "/" request
                        :name :create-team-group
                        :return {:team-group TeamGroup}
                        :summary "Creates a new group membership for the given team and group. Returns the created group membership."
                        :body [body {:team-group NewTeamGroup}]
                        (let [ctx (request-context/make-context request org authz)
                              group (authz/post-team-group authz ctx body)]
                          (created (routes/named-route ctx :get-team-group {:org org :id id :gid (get-in group [:team-group :id])}) group)))

                      (context "/:gid" []
                        :path-params [gid :- Id]

                        (GET "/" request
                          :name :get-team-group
                          :return {:team-group TeamGroup}
                          :summary "Gets a Group team membership"
                          (let [ctx (request-context/make-context request org authz)
                                group (authz/get-team-group authz ctx gid)]
                            (ok group)))

                        (PUT "/" request
                          :name :put-team-group
                          :body [body {:team-group TeamGroup}]
                          :return {:team-group TeamGroup}
                          :summary "Updates a Group team membership"
                          (let [ctx (request-context/make-context request org authz)
                                group (authz/put-team-group authz ctx gid body)]
                            (ok group)))


                        (DELETE "/" request
                          :name :delete-team-group
                          :summary "Deletes a Group team membership"
                          (let [ctx (request-context/make-context request org authz)
                                _ (authz/delete-team-group authz ctx gid)]
                            (no-content)))))

                    (context "/memberships" []
                      (POST "/" request
                        :name :post-memberships
                        :return {s/Keyword TeamMembership}
                        :summary "Creates a new team membership (adding a user to a team). Returns the created membership. Invites user if they're not already an Ovation user."
                        :body [body {:membership NewTeamMembership}]
                        (let [ctx (request-context/make-context request org authz)
                              membership (teams/post-membership* ctx id (:membership body))]
                          (created (get-in [:membership :links :self] membership) membership)))
                      (context "/:mid" []
                        :path-params [mid :- s/Str]

                        (PUT "/" request
                          :name :put-membership
                          :summary "Updates an existing membership by setting its role."
                          :return {:membership TeamMembership}
                          :body [body {:membership UpdatedTeamMembership}]
                          (let [ctx (request-context/make-context request org authz)]
                            (ok (teams/put-membership* ctx id (:membership body) mid))))

                        (DELETE "/" request
                          :name :delete-membership
                          :summary "Deletes a team membership, removing the team member."
                          (let [ctx (request-context/make-context request org authz)]
                            (teams/delete-membership* ctx mid)
                            (no-content)))))))


                (context "/roles" []
                  :tags ["teams"]
                  (GET "/" request
                    :name :all-roles
                    :return {:roles [TeamRole]}
                    :summary "Gets all team Roles for the current Organization"
                    (ok (teams/get-roles* (request-context/make-context request org authz)))))

                (context "/breadcrumbs" []
                  :tags ["ui"]
                  (GET "/" request
                    :query-params [id :- s/Str]
                    :name :get-breadcrumbs
                    :return {:breadcrumbs [[{:type s/Str :id s/Uuid :name s/Str :organization Id}]]}
                    :summary "Gets the breadcrumbs for an entity."
                    (let [ctx    (request-context/make-context request org authz)
                          result (breadcrumbs/get-breadcrumbs ctx db [id])]
                      (ok {:breadcrumbs (get result id)})))

                  (POST "/" request
                    :body [ids [s/Str]]
                    :return {:breadcrumbs {s/Uuid [[{:type s/Str :id s/Uuid :name s/Str}]]}}
                    :summary "Gets the breadcrumbs for a collection of entities. Allows POSTing for large collections"
                    (let [ctx    (request-context/make-context request org authz)
                          result (breadcrumbs/get-breadcrumbs ctx db ids)]
                      (ok {:breadcrumbs result}))))

                (context "/zip" []
                  :tags ["zip"]
                  (context "/folders" []
                    (GET "/:id" request
                      :path-params [id :- s/Uuid]
                      :name :zip-folder
                      :summary "Download Folder contents as a Zip archive"
                      (temporary-redirect (util/join-path [config/ZIP_SERVICE "api" "v1" "folders" id]))))
                  (context "/activities" []
                    (GET "/:id" request
                      :path-params [id :- s/Uuid]
                      :name :zip-activity
                      :summary "Download Activity contents as a Zip archive"
                      (temporary-redirect (util/join-path [config/ZIP_SERVICE "api" "v1" "activities" id])))))

                (context "/search" []
                  :tags ["search"]
                  (GET "/" request
                    :query-params [q :- s/Str
                                   {bookmark :- (s/maybe s/Str) nil}
                                   {limit :- s/Int 25}]
                    :summary "Searches the organization data"

                    :return {:search_results [{:id            s/Uuid
                                               :entity_type   s/Str
                                               :name          s/Str
                                               :owner         s/Uuid
                                               :updated-at    (s/maybe s/Str) ;; allow nil updated-at
                                               :project_names [s/Str]
                                               :organization  Id
                                               :links         {:breadcrumbs s/Str}}]
                             :meta           {:bookmark   s/Str
                                              :total_rows s/Int}}
                    :responses {400 {:schema JsonApiError, :description "Search error", :headers {:location s/Str}}}

                    (let [ctx (request-context/make-context request org authz)
                          result (search/search ctx db es-client q :bookmark bookmark :limit limit)]
                      (ok result))))))))))))
