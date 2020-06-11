(ns herald.tests.use-cases.manage-veye-project-test
  (:require [midje.sweet :refer :all]
            [clj-sql-up.migrate :refer [migrate rollback]]
            [herald.db :as db]
            [herald.models.stars [user-api-token :as UAT-star]
                                 [repo-veyeproject-repofile :as RVR-star]]
            [herald.models [api :as api-mdl]
                           [token :as token-mdl]
                           [repo :as repo-mdl]
                           [repofile :as repofile-mdl]]
            [herald.use-cases.manage-veye-project :as uc-veye]
            [blancas.morph.monads :refer [right? run-right]]
            [herald.tests.models.helpers :refer [delete-all count-all]]))

(def rvr-tbl "REPOS_VEYEPROJECTS_REPOFILES")
(def api-tbl "APIS")
(def repo-tbl "REPOS")
(def token-tbl "TOKENS")
(def repofile-tbl "REPOFILES")
(def uat-tbl "USERS_APIS_TOKENS")
(def veye-project-tbl "VEYEPROJECTS")
(def veye-dep-tbl "VEYEDEPENDENCIES")

;;-- set up test table
(def db-configs (:test db/db-configs))
(migrate db-configs)
(def db-conn (db/connect db-configs))


;;-- test data
(def test-api {:name "Github"
               :api_type "github"
               :description "Public Github"
               :has_repos true
               :url "https://api.github.com"
               :private false})

(def test-veye-api {:name "VersionEye"
                    :api_type "veye"
                    :description "Public Veye API"
                    :has_repos false
                    :url "https://www.versioneye.com/api"
                    :private false})

(def test-token {:username "heraldtest"
                 :key "not-required"
                 :secret "7790a09b31c734f8581d581aa33bb8ece1e7149f"})

(def test-veye-token {:username "veye-user"
                      :key "not-required"
                      :secret "ba7d93beb5de7820764e"})

(def test-repo {:scm_id "20255062"
                :owner_login "heraldtest"
                :owner_type "user"
                :name "fantom_hydra"
                :fullname "heraldtest/fantom_hydra"
                :language "java"
                :description ""
                :private false})

(def test-repo-file {:path "Gemfile"
                     :name "Gemfile"
                     :branch "master"
                     :commit_sha "20b9c1193a16c1d86f2a524d30c3e37bd0050bc4"})

(def test-veye-msg {:veye_id "uuid-1-1-1"
                    :project_key "veye_project_key_1"
                    :project_type "Gemfile"
                    :name "veye_project"
                    :source "api"
                    :period "weekly"
                    :dep_number 1
                    :out_number 1})

(def test-veye-dep1 {:name "dep1"
                     :license "Beer"
                     :prod_key "ruby/dep1"
                     :group_id "ruby"
                     :artifact_id "dep1"
                     :version_current "1.0"
                     :version_requested "1.0"
                     :comparator "="
                     :unknown false
                     :outdated false
                     :stable true})

(delete-all api-tbl) ;;remove default APIS

(fact "initialize test data"
  (count-all repo-tbl) => 0
  (count-all api-tbl)  => 0
  ;;-- add authorized API
  (run-right (api-mdl/create test-api))     => {:id 5}
  (run-right (token-mdl/create test-token)) => {:id 1}
  (run-right (UAT-star/create 1 5 1))       => {:id 1}

  ;;-- create test repo
  (run-right (repo-mdl/create test-repo))   => {:id 1}
  (run-right (repofile-mdl/create test-repo-file)) => {:id 1}

  (run-right (RVR-star/create {:uat_id 1
                               :repo_id 1
                               :repofile_id 1}))   => {:id 1})

;;-- tests
(facts save-veye-project
  (fact "creates new project and saves it dependencies"
    (count-all veye-project-tbl) => 0
    (count-all veye-dep-tbl)     => 0
    (count-all rvr-tbl)          => 1
    (let [res (uc-veye/save-project 1
                                    (assoc test-veye-msg
                                           :dependencies [test-veye-dep1]))]
      (right? res) => true)
    (count-all rvr-tbl)          => 1
    (count-all veye-project-tbl) => 1
    (count-all veye-dep-tbl)     => 1)
  (delete-all veye-dep-tbl)
  (delete-all veye-project-tbl))

(facts "when project is successfully linked"
  (fact "saves new project"
    (count-all veye-project-tbl) => 0
    (count-all veye-dep-tbl)     => 0
    (count-all rvr-tbl)          => 1
    (let [res (uc-veye/save-project 1
                                    (assoc test-veye-msg
                                           :dependencies [test-veye-dep1]))]
      (right? res)    => true
      (run-right res) => true)
    (count-all rvr-tbl)          => 1
    (count-all veye-project-tbl) => 1
    (count-all veye-dep-tbl)     => 1)

  (fact "get-by-project-id returns correct project"
    (let [res (uc-veye/get-by-project-id 2)
          proj (run-right res)]
      (right? res)          => true
      proj                  =not=> nil?
      (:name proj)          => (:name test-veye-msg)
      (:project-type proj)  => (:project_type test-veye-msg)
      (:project-key proj)   => (:project_key test-veye-msg)
      (count (:dependencies proj)) => 1
      (let [dep (-> proj :dependencies first)]
        (:name dep)               => (:name test-veye-dep1)
        (:license dep)            => (:license test-veye-dep1)
        (:version_requested dep)  => (:version_requested test-veye-dep1))))

  (fact "returns a correct list of veye Projects."
    (let [res (uc-veye/get-user-projects 1)
          project ((comp first run-right) res)]
      (right? res)            => true
      (:name project)         => (:name test-veye-msg)
      (:project-type project) => (:project_type test-veye-msg)
      (:project-key project)  => (:project_key test-veye-msg)
      (:filename project)     => (:name test-repo-file)
      (:branch project)       => (:branch test-repo-file)
      (count (:dependencies project)) => 1
      (let [dep (-> project :dependencies first)]
        (:name dep)               => (:name test-veye-dep1)
        (:license dep)            => (:license test-veye-dep1)
        (:version_requested dep)  => (:version_requested test-veye-dep1))))

  (fact "removes project and its dependencies successfully"
    (count-all rvr-tbl)          => 1
    (count-all veye-project-tbl) => 1
    (count-all veye-dep-tbl)     => 1
    (right? (uc-veye/delete-project 2)) => true
    (count-all rvr-tbl)          => 1
    (count-all veye-project-tbl) => 0
    (count-all veye-dep-tbl)     => 0
    ))

;;-- tests for fn using remote APIs

#_(facts "when file content exists"
  (facts import-file-content
    (fact "imports file content from SCM"
      (let [git-auth (run-right (UAT-star/get-user-token-by-id 1 1))
            res (uc-veye/import-file-content 1 git-auth)
            repo-file (run-right res)]

        (right? res)          => true
        (:path repo-file)     => (:path test-repo-file)
        (:name repo-file)     => (:name test-repo-file)
        (:size repo-file)     => 1990
        (:encoding repo-file) => "base64"
        (:content repo-file)  =not=> nil)))

  (facts create-project
    (fact "add additional veye tokens before spec"
      (run-right (api-mdl/create test-veye-api))      => {:id 6}
      (run-right (token-mdl/create test-veye-token))  => {:id 2}
      (run-right (UAT-star/create 1 6 2))             => {:id 2})

    (fact "links existing project file with versioneye API"
      (let [veye-auth (run-right (UAT-star/get-user-token-by-id 1 2))
            res (uc-veye/link-project 1 veye-auth)
            new-proj (run-right res)]
        (right? res)              => true
        new-proj                  =not=> nil
        (:path new-proj)          => (:path test-repo-file)
        (:commit-sha new-proj)    => (:commit_sha test-repo-file)
        (:branch new-proj)        => (:branch test-repo-file)
        (:project-type new-proj)  => "RubyGem"
        (:repo new-proj)          => (:fullname test-repo))))

  (facts import-by-file-id
    (fact "links existing project with versioneye API"
      (let [veye-auth (run-right (UAT-star/get-user-token-by-id 1 2))
            res (uc-veye/link-by-file-id 1 veye-auth nil)
            new-proj (run-right res)]
        (right? res)              => true
        new-proj                  =not=> nil

        (:path new-proj)          => (:path test-repo-file)
        (:commit-sha new-proj)    => (:commit_sha test-repo-file)
        (:branch new-proj)        => (:branch test-repo-file)
        (:project-type new-proj)  => "RubyGem"
        (:repo new-proj)          => (:fullname test-repo)))))


#_(facts "when file-content doesnt exists"
  (facts import-by-file-id
    (repofile-mdl/update 1 {:content nil})
    (fact "links existing project with versioneye API"
      (let [veye-auth (run-right (UAT-star/get-user-token-by-id 1 2))
            git-auth (run-right (UAT-star/get-user-token-by-id 1 1))
            res (uc-veye/link-by-file-id 1 veye-auth git-auth)
            new-proj (run-right res)]
        (println "Linked new project: \n" new-proj)
        (right? res)              => true
        new-proj                  =not=> nil

        (:path new-proj)          => (:path test-repo-file)
        (:commit-sha new-proj)    => (:commit_sha test-repo-file)
        (:branch new-proj)        => (:branch test-repo-file)
        (:project-type new-proj)  => "RubyGem"
        (:repo new-proj)          => (:fullname test-repo)
        ))))

;;-- clean up DB
(delete-all api-tbl)
(delete-all token-tbl)
(delete-all uat-tbl)
(delete-all repo-tbl)
(delete-all repofile-tbl)
(delete-all rvr-tbl)
(rollback db-configs 999)
