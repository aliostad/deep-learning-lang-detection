"Includes controller helpers to get repos&repofiles from DB,
it also handles updating files and client-side error messages;"

(ns herald.use-cases.manage-repos
  (:require [herald.models [repo :as repo-mdl]
                           [repofile :as repofile-mdl]
                           [veye-dependency :as deps-mdl]
                           [veye-project :as veye-proj-mdl]]
            [herald.models.stars.repo-veyeproject-repofile :as RVR-star]
            [herald.use-cases.manage-veye-project :as uc-veye]
            [clojure.string :as string]
            [schema.core :as s]
            [schema.macros :as sm]
            [herald.schemas :refer [->HError]]
            [blancas.morph.monads :refer [either run-right right left]]
            [taoensso.timbre :as log])
  (:import [blancas.morph.monads Either]))

(defn clob->str
  [clob-field]
  (when clob-field
    (slurp (.getCharacterStream clob-field))))

(def RepoSchema {s/Keyword s/Any})

(sm/defn get-user-repofile :- Either
  "returns all metadata of the related project file"
  [user-id :- s/Int
   file-id :- s/Int]
  (either [rvr-dt (RVR-star/get-user-repofile user-id file-id)]
    (left (->HError "File does not exists" rvr-dt))
    (let [user-repo (run-right (repo-mdl/get-by-id (:repo-id rvr-dt)))
          fileinfo (run-right (repofile-mdl/get-by-id file-id))
          project-dt (run-right (uc-veye/get-by-project-id (:veyeproject-id rvr-dt)))
          desc-txt (clob->str (:description user-repo))
          file-content (clob->str (:content fileinfo))]
      (right
        {:repo (assoc user-repo
                      :description desc-txt
                      :uat-id (:uat-id rvr-dt))
        :file (assoc fileinfo :content file-content)
        :project project-dt}))))

(sm/defn get-user-repofiles :- Either
  "returns all user repofiles formatted has index-map
  structured as {[:repo-id :branch filename] repofile-data-map}
  to make it easier to filter and lookup repofiles by repo & name"
  [user-id :- s/Int]
  (either [repofiles (RVR-star/get-user-repofiles user-id)]
    (left (->HError "User has no repo files" repofiles))
    (right (vec repofiles))))

(sm/defn get-user-repos :- Either
  "get's user repos"
  [user-id :- s/Int]
  (either [repos (RVR-star/get-user-repos user-id)]
    (left (->HError "User has no repos" repos))
    (let [user-files (run-right (get-user-repofiles user-id))
          filter-by-repo-id (fn [repo-id]
                              (vec (filter #(= repo-id (:repo-id %1)) user-files)))]
      ((comp right vec)
        (for [repo repos]
          (assoc repo
                :description (clob->str (:description repo))
                :repofiles (filter-by-repo-id (:repo-id repo))))))))

(sm/defn delete-user-repos-by-uat :- Either
  "deletes only repo data related to the connected API."
  [user-id :- s/Int
   uat-id :- s/Int]
  (either [user-repos (RVR-star/get-user-repos-mini user-id)]
    (left (->HError "User has no repos" user-repos))
    (let [uat-repos (vec (filter #(= uat-id (:uat-id %1)) user-repos))
          uniq-repo-ids (set (map :repo-id uat-repos))]
      (doseq [repo-id uniq-repo-ids]
        (RVR-star/delete-by-repo-id repo-id))
      (right true))))

