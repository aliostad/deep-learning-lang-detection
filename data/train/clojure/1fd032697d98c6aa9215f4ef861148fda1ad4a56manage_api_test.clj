(ns herald.tests.use-cases.manage-api-test
  (:require [midje.sweet :refer :all]
            [clj-sql-up.migrate :refer [migrate rollback]]
            [herald.db :as db]
            [herald.use-cases.manage-api :as uc-api]
            [herald.models [api :as api-mdl]
                           [token :as token-mdl]
                           [repo :as repo-mdl]]
            [herald.models.stars.user-api-token :as UAT-star]
            [herald.models.stars.repo-veyeproject-repofile :as RVR-star]
            [herald.tests.models.helpers :refer [delete-all count-all]]
            [blancas.morph.monads :refer [right? run-right either]]
            [taoensso.timbre :as log])
  (:import [herald.schemas HError]))

(def UAT-table "USERS_APIS_TOKENS")
(def api-table "APIS")
(def token-table "TOKENS")
(def repo-table "REPOS")
(def RVR-table "REPOS_VEYEPROJECTS_REPOFILES")

;;-- set up test tables
(migrate (:test db/db-configs))
(def db-conn (db/connect (:test db/db-configs)))
(delete-all UAT-table)

;;-- API source related tests
(delete-all api-table)

(def test-api-data {:name "VersionEye"
                    :api-type "veye"
                    :url "https://www.versioneye.com/api/v2"
                    :description "tilu-lilu"})

(def test-api-data2 {:name "Github"
                     :api-type "github"
                     :url "https://api.github.com"
                     :description "simpa-timpa"})

(def test-api {:name "Veye"
               :api_type "veye"
               :url "https://www.versioneye.com/api/v2"
               :description "test source"
               :private true
               :has_repos false})

(def test-api2 {:name "Github"
                :api_type "github"
                :url "https://api.github.com"
                :description "test source"
                :private false
                :has_repos true})

(facts "get-user-sources"
  (fact "returns correct list of API sources"
    ;-- set up test data
    (count-all UAT-table)                       => 0
    (run-right (api-mdl/create test-api2))       => {:id 5}
    (run-right (UAT-star/create 1 5 0))         => {:id 1}
    (count-all api-table)                       => 1
    (count-all UAT-table)                       => 1

    ;-- run tests
    (let [res (uc-api/get-user-sources 1)
          items (run-right res)]
      (right? res)            => true
      (count items)           => 1
      (-> items first :name)  => (:name test-api2)))
  (delete-all api-table)
  (delete-all UAT-table))

(facts "add-user-sources"
  (fact "returns correct list of API sources after adding new item"
    (count-all UAT-table) => 0
    (let [res (uc-api/add-user-source 1 test-api-data)
          items (run-right res)] ;;api-id == 6
      (count-all api-table)   => 1
      (count-all UAT-table)   => 1
      (count items)           => 1
      (right? res)            => true
      (-> items first :name)  => (:name test-api-data)))
  (delete-all UAT-table)
  (delete-all api-table))

(facts "update-user-source"
  (fact "returns correct list of API sources after updating the item"
    ;-- set up test data
    (count-all UAT-table) => 0
    (uc-api/add-user-source 1 test-api-data) ;;api-id == 7
    (count-all UAT-table) => 1
    ;-- test
    (let [updated-data (assoc test-api-data
                              :api-id 7
                              :name "UpdatedSource")
          res (uc-api/update-user-source 1 updated-data)
          items (run-right res)]
      (count-all UAT-table)   => 1
      (count items)           => 1
      (right? res)            => true
      (-> items first :name)  => "UpdatedSource"))
  (delete-all UAT-table)
  (delete-all api-table))

(facts "delete-user-source"
  (fact "after successful deletion, returns correct items"
    (count-all UAT-table) => 0
    ;-- set up test data
    (let [res (uc-api/add-user-source 1 test-api-data)
          items (run-right res)
          item (first items)]
      (right? res)            => true
      (count-all UAT-table)   => 1
      (count items)           => 1
      (run-right (uc-api/delete-user-source 1 item)) => empty?
      (count-all UAT-table)   => 0))
  (delete-all UAT-table)
  (delete-all api-table))

;;-- API tokens related tests
(delete-all token-table)

(def api-token "ba7d93beb5de7820764e")

(def test-token {:username "timgluz"
                 :key "ABCkeyID"
                 :secret api-token})
(def test-token-msg {:api-id 9
                     :api-type "veye"
                     :username "timgluz"
                     :key "KEY123"
                     :secret api-token})

(facts "get-user-tokens"
  (fact "it returns correct list of user tokens"
    ;- add test data
    (run-right (api-mdl/create test-api))       => {:id 9}
    (run-right (UAT-star/create-user-api 1 9))  => {:id 5}
    (run-right (token-mdl/create test-token))   => {:id 1}
    (run-right (UAT-star/create 1 9 1))         => {:id 6}
    ;- execute tests
    (count-all token-table)         => 1
    (count-all UAT-table)           => 2
    (let [res (uc-api/get-user-tokens 1)
          tokens (run-right res)
          token (first tokens)]
      (right? res)        => true
      (count tokens)      => 1
      token               =not=> nil?
      (:username token)   => (:username test-token)
      (:key token)  => (:key test-token)))
  (delete-all UAT-table)
  (delete-all api-table)
  (delete-all token-table))

(facts "add-user-api-token"
  (fact "adds new token and returns correct list of user tokens"
    ;- add test data
    (run-right (api-mdl/create test-api))         => {:id 10}
    (run-right (UAT-star/create-user-api 1 10))   => {:id 7}
    (count-all UAT-table)                         => 1
    (let [test-token (assoc test-token-msg :api-id 10)]
      (either [tokens (uc-api/add-user-token 1 test-token)]
        (log/error "add-user-api-token failed: " tokens)
        (let [token (first tokens)]
          (count tokens)            => 1
          token                     =not=> nil?
          (:username token)         => (:username test-token)
          (:key token)              => (:key test-token)))))
  (delete-all UAT-table)
  (delete-all api-table)
  (delete-all token-table))

(facts "update-user-api-token"
  (fact "updates token and returns new list of user tokens"
    (uc-api/add-user-source 1 test-api-data)
    (uc-api/add-user-token 1 (assoc test-token-msg :api-id 11))
    ;- run test cases
    (count-all UAT-table) => 2
    (let [res (uc-api/update-user-token
                   1 3 (assoc test-token-msg :username "KikkaKukka"))
          tokens (run-right res)
          token (first tokens)]
      (right? res)        => true
      (count tokens)      => 1
      token               =not=> nil?
      (:username token)   => "KikkaKukka"
      (:key token)  => (:key test-token-msg)))
  (delete-all api-table)
  (delete-all token-table)
  (delete-all UAT-table))

(facts "delete-user-api-token"
  (fact "delete token and returns empty list of user tokens"
    (uc-api/add-user-source 1 test-api-data)
    (uc-api/add-user-token 1 (merge test-token-msg {:api-id 12}))
    ;- run test cases
    (count-all UAT-table) => 2
    (let [res (uc-api/delete-user-token 1 12 4)
          tokens (run-right res)]
      (right? res)            => false
      (count-all token-table) => 0
      (count-all UAT-table)   => 1 ;; source binding must stay
      ))
  (delete-all token-table)
  (delete-all api-table)
  (delete-all UAT-table))

;;-- additional methods

(def test-repo {:scm_id "a1"
                :owner_login "test"
                :owner_type "user"
                :name "repo"
                :fullname "test/repo"
                :language "ruby"
                :description "bla-bla"
                :private false})

(facts "get-user-source-owners"
  (fact "returns only connected user repo-api and correct list of owners"
    ;;-- add test data
    (uc-api/add-user-source 1 test-api-data)
    (uc-api/add-user-token 1 (assoc test-token-msg :api-id 13))
    (uc-api/add-user-source 1 test-api-data2)
    ;(uc-api/add-user-token 1 (assoc test-token-msg :api-id 14))
    ;;work around automatic token key validation before saving
    (run-right (token-mdl/create {:username "heraldtest"
                                  :key "123"
                                  :secret "abc"}))  => {:id 6}
    (run-right (UAT-star/create 1 14 6))            => {:id 16}

    (repo-mdl/create test-repo)
    (RVR-star/create {:uat_id 16 :repo_id 1})
    ;;-- execute tests
    (count-all api-table) => 2
    (count-all UAT-table) => 4
    (-> 1 UAT-star/get-user-authorized-apis run-right count) => 2

    (let [res (uc-api/get-user-source-owners 1)
          repo-apis (run-right res)]
      (println "#-- get-user-source-owners-test: " res)
      (right? res)      => true
      (count repo-apis) => 1
      (let [api (first repo-apis)]
        (:name api)       => (:name test-api-data2)
        (:owners api)     => #{"test"})))
  (delete-all UAT-table)
  (delete-all token-table)
  (delete-all api-table)
  (delete-all repo-table)
  (delete-all RVR-table))

;;-- tear-down test-database
(delete-all UAT-table)
(rollback (:test db/db-configs) 999)

