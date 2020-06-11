(ns herald.use-cases.manage-veye-project
  (:require [herald.db :as db]
            [clojure.string :as string]
            [taoensso.timbre :as log]
            [schema.core :as s]
            [schema.macros :as sm]
            [blancas.morph.core :as morph :refer [monad]]
            [blancas.morph.monads :refer [either run-right right left
                                          right? make-either]]
            [herald.schemas :refer [->HError]]
            [herald.services.veye.core :as veye]
            [herald.services.github.core :as github]
            [herald.services.clients :as clients :refer [make-client]]
            [herald.services.schemas :as schemas]
            [herald.models [repofile :as repofile-mdl]
                           [api :as api-mdl] ;;just needed for init-test
                           [veye-project :as veye-project-mdl]
                           [veye-dependency :as veye-dep-mdl]]
            [herald.models.stars.repo-veyeproject-repofile :as RVR-star]
            [herald.models.helpers :refer [clob->str]])
  (:import [blancas.morph.monads Either]
           [herald.services.clients VeyeClient]))

;;-- DB helpers
(sm/defn get-by-project-id :- Either
  "returns project info by project id"
  [project-id :- s/Int]
  (either [proj-info (RVR-star/get-by-project-id project-id)]
    (left (->HError "Failed to fetch project by id" proj-info))
    (either [proj-deps (veye-dep-mdl/get-by-project-id project-id)]
      (do
        (log/error "Can fetch project dependencies: " proj-deps)
        (right proj-info))
      (right (assoc proj-info :dependencies proj-deps)))))

(sm/defn get-user-projects :- Either
  "returns a list of linked user's projects"
  [user-id :- s/Int]
  (either [imported-projects (RVR-star/get-user-imported-projects user-id)]
    (left (->HError "User has no imported projects" imported-projects))
    ((comp right vec)
      (for [proj imported-projects]
        (either [proj-deps (veye-dep-mdl/get-by-project-id (:veyeproject-id proj))]
          proj
          (assoc proj :dependencies proj-deps))))))

(sm/defn delete-project :- Either
  "removes a project and its dependencies from DB"
  [project-id :- s/Int]
  (monad [_ (veye-dep-mdl/delete-by-project-id project-id)
          _ (veye-project-mdl/delete project-id)
          _ (RVR-star/remove-project-id project-id)]
    (right true)))

;;-- API tasks
(def UserAuth {:key s/Str
               :secret s/Str
               :username s/Str})

;;TODO: make source agnostic
(sm/defn import-file-content :- Either
  "caches project file onto DB."
  [file-id :- s/Int
   scm-auth :- UserAuth]
  (either [file-data (repofile-mdl/get-by-id file-id)]
    (left (->HError "File doesnt exists." file-data))
    (let [rvr-info (run-right (RVR-star/get-by-file-id file-id))
          client (clients/make-client :github scm-auth {})]
      (either [file-content (github/get-file-content client
                                                     (:repo rvr-info)
                                                     (:commit_sha file-data))]
        ;;when request failed
        (let [file-name (:name file-data)
              repo-name (:repo rvr-info)
              error-msg (format "Cant read content of SCM file `%s/%s` on branch %s,
                                file id is `%s`\n%s"
                                repo-name file-name (:branch file-data)
                                (:id file-data) file-content)]
          (log/error error-msg)
          (left (->HError error-msg file-content)))
        ;;when request was successful
        (let [updated-dt {:content  (get-in file-content [:data :content])
                          :encoding (get-in file-content [:data :encoding])
                          :size     (get-in file-content [:data :size])}]
          (either [res (repofile-mdl/update (:id file-data) updated-dt)]
            (left (->HError "Failed to update a content of the project file." res))
            (repofile-mdl/get-by-id (:id file-data))))))))


(def Project {s/Keyword s/Any})

(sm/defn save-project :- Either
  [file-id :- s/Int
   proj-resp :- {:data Project}]
  (let [proj-info (:data proj-resp)
        proj-dt (dissoc proj-info :dependencies :public)
        deps (get proj-info :dependencies [])]
    (either [proj-id (veye-project-mdl/create proj-dt)]
      (do
        (log/error "Cant save new veye project: " proj-id)
        (left (->HError "Can not save a new Veye project" proj-id)))
      ;;save dependencies
      (do
        (doseq [dep deps]
          (either [res (veye-dep-mdl/create
                         (assoc dep :veyeproject_id (:id proj-id)))]
            (log/error "Failed to save dependency: " res)
            (log/info "Saved dependency: " res)))
        ;;-- updated RVR binding
        (RVR-star/update-by-file-id file-id {:veyeproject_id (:id proj-id)})
        (right proj-id)))))

(sm/defn link-project :- Either
  "links project file with veye and creates new veye projects with related
  state of dependencies."
  [file-id     :- s/Int
   user-auth   :- s/Int]
  (either [file-data (repofile-mdl/get-by-id file-id)]
    (left (->HError "File doesnt exists." file-data))
    (let [file-content (clob->str (:content file-data))]
      (if (empty? file-content)
        (left
          (->HError (format "No content for %s, check file id: %s "
                            (:path file-data), file-id)
                    file-data))
        ;;if file-content exists
        (let [client (make-client :veye user-auth
                                  {:socket-timeout 30000})]
          (monad [proj-info (veye/create-project client
                                                 (:name file-data)
                                                 file-content)
                  _ (veye/delete-project client
                                         (get-in proj-info [:data :project_key]))
                  proj-id (save-project (:id file-data) proj-info)]
            (RVR-star/get-by-project-id (:id proj-id))))))))

(sm/defn get-or-import-file-content :- Either
  "Gets file content or if it's missing then tries to import it from source."
  [file-dt :- {s/Keyword s/Any}
   source-auth :- UserAuth]
  (if (nil? (:content file-dt))
    (either [updated-file (import-file-content (:id file-dt) source-auth)]
      (left (->HError "Failed to import missing file content" updated-file))
      (right (:content file-dt)))
    (right (:content file-dt))))

(sm/defn link-by-file-id :- Either
  "imports content of projectfile & links it with VersionEye data"
  [repofile-id  :- s/Int
   veye-auth    :- UserAuth
   source-auth  :- UserAuth]
  (let [fetch-data (monad [file-dt (repofile-mdl/get-by-id repofile-id)
                           rvr-dt (RVR-star/get-by-file-id repofile-id)]
                      (right [file-dt rvr-dt]))]
    (either [proj-dt fetch-data]
      (left (->HError "Failed to check project file data before linking;" proj-dt))
      (let [[file-dt rvr-dt] proj-dt]
        (monad [_ (get-or-import-file-content file-dt source-auth) ;pulls file
                _ (delete-project (:veyeproject-id rvr-dt))
                new-rvr-dt (link-project repofile-id veye-auth)]
          (right new-rvr-dt))))))

(comment

  (require '[herald.use-cases.manage-veye-project :as uc-veye] :reload)

  (require '[herald.models.stars.user-api-token :as UAT-star] :reload)
  (require '[herald.db :as db])
  (require '[blancas.morph.monads :refer [either run-right]])

  (def repofile-id "641")
  (def user-id 1)
  (def uat-id 3)

  (def veye-auth (run-right
                   (db/with-connection :dev
                     (UAT-star/get-user-token-by-api-type user-id "veye"))))
  (def source-auth (db/with-connection :dev
                     (run-right
                        (UAT-star/get-user-token-by-id user-id uat-id))))

  (db/with-connection :dev
    (uc-veye/import-file-content repofile-id source-auth))

  (db/with-connection :dev
    (uc-veye/link-by-file-id repofile-id veye-auth source-auth))

  (require '[herald.models.repofile :as repofile-mdl])
  (require '[herald.models.helpers :refer [clob->str]])
  (require '[herald.services.clients :as clients])
  (require '[herald.services.veye.core :as veye])

  (db/with-connection :dev
  (let [file-dt (run-right (repofile-mdl/get-by-id repofile-id))
        file-content (clob->str (:content file-dt))
        client (clients/make-client :veye veye-auth {:debug true
                                                     :conn-timeout 5000
                                                     :socket-timeout 30000})]
    (veye/create-project client (:name file-dt) file-content)))

  )

