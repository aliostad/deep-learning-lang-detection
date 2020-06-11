(ns herald.tests.use-cases.manage-repos-test
  (:require [midje.sweet :refer :all]
            [clj-sql-up.migrate :refer [migrate rollback]]
            [herald.db :as db]
            [herald.models [api :as api-mdl]
                           [repo :as repo-mdl]
                           [repofile :as repofile-mdl]
                           [veye-project :as veyeproj-mdl]
                           [veye-dependency :as veyedep-mdl]]
            [herald.models.stars [user-api-token :as UAT-star]
                                 [repo-veyeproject-repofile :as RVR-star]]
            [herald.tests.models.helpers :refer [delete-all count-all]]
            [herald.use-cases.manage-repos :as uc-repos]
            [blancas.morph.monads :refer [right? run-right either]]
            [taoensso.timbre :as log]))


(def RVR-table "REPOS_VEYEPROJECTS_REPOFILES")
(def uat-tbl "USERS_APIS_TOKENS")
(def api-tbl "APIS")
(def repo-tbl "REPOS")
(def repofile-tbl "REPOFILES")

;;-- set up test table
(def db-configs (:test db/db-configs))
(migrate db-configs)
(def db-conn (db/connect db-configs))


;;add test data
(def test-repo {:scm_id "abc123"
                :owner_login "test"
                :owner_type "author"
                :name "repo"
                :fullname "testrepo"
                :language "c"
                :description ""
                :private false})

(def test-repo-file {:name "test.c"
                     :branch "master"
                     :commit_sha "1233434"})


(def test-project {:veye_id "1122"
                   :project_key "c_test"
                   :project_type "c"
                   :name "test_c"
                   :source "api"})

(def test-dependency {:veyeproject_id 1
                      :name "dep1"
                      :license "MIT"
                      :prod_key "dep1"
                      :group_id "dep"
                      :artifact_id "artifact"
                      :version_current "1.1.1"
                      :version_requested "1.1.1"
                      :comparator "="
                      :unknown false
                      :outdated false
                      :stable true})

(def test-api {:name "TestApi"
               :api_type "git"
               :description "Api just for testing"
               :has_repos true
               :url "https://no.required"
               :private true})

(delete-all api-tbl) ;;remove default APIS


;;-- generate test data

(fact "generate static DB data for test run"
  (run-right (api-mdl/create test-api)) => {:id 5}
  (run-right (UAT-star/create 1 1 1))   => {:id 1}
  (count-all api-tbl)       => 1
  (count-all uat-tbl)       => 1

  (count-all repo-tbl) => 0
  (run-right(repo-mdl/create test-repo))                => {:id 1}
  (run-right
    (RVR-star/create {:uat_id 1 :repo_id 1}))           => {:id 1}
  (run-right (repofile-mdl/create test-repo-file))      => {:id 1}
  (run-right (veyeproj-mdl/create test-project))        => {:id 1}
  (run-right (veyedep-mdl/create test-dependency))      => {:id 1}
  (run-right
    (RVR-star/create {:uat_id 1
                      :repo_id 1
                      :repofile_id 1
                      :veyeproject_id 1}))     => {:id 2})

;;-- run tests

(facts "get-user-repofile"
  (fact "returns correct response"
    (either [repofile (uc-repos/get-user-repofile 1 1)]
      "request failed"      => true
      (do
        repofile                      =not=> nil?
        repofile                      => map?
        (contains? repofile :repo)    => true
        (contains? repofile :file)    => true
        (contains? repofile :project) => true
        (get-in repofile [:repo :fullname]) => (:fullname test-repo)
        (get-in repofile [:file :name])     => (:name test-repo-file)
        (get-in repofile [:project :name])  => (:name test-project)))))

(facts "get-user-repofiles"
  (fact "returns a correct list of repo's files"
    (let [res (uc-repos/get-user-repofiles 1)
          file (first (run-right res))]
      (right? res)        => true
      (count (run-right res)) => 1
      (:filename file)    => (:name test-repo-file)
      (:branch file)      => (:branch test-repo-file))))

(facts "get-user-repos"
  (fact "returns a correct list of result"
    (let [res (uc-repos/get-user-repos 1)
          repo (first (run-right res))]
      (right? res)        => true
      (count (run-right res)) => 1

      (:fullname repo)    => (:fullname test-repo)
      (:owner-login repo) => (:owner_login test-repo)
      (:language repo)    => (:language test-repo))))


(facts "delete-user-repos-by-uat"
  (fact "removes all user repos"
    (count-all repo-tbl)      => 1
    (count-all repofile-tbl)  => 1
    (count-all RVR-table)     => 2

    (uc-repos/delete-user-repos-by-uat 1 1)
    (count-all repo-tbl)      => 0
    (count-all repofile-tbl)  => 0
    (count-all RVR-table)     => 0
    (count-all uat-tbl)       => 1))

;;-- clean up DB
(delete-all RVR-table)
(delete-all uat-tbl)
(delete-all repo-tbl)
(delete-all repofile-tbl)
(rollback db-configs 999)
