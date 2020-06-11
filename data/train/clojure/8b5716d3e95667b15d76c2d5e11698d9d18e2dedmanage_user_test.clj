(ns herald.tests.use-cases.manage-user-test
  (:require [midje.sweet :refer :all]
            [clj-sql-up.migrate :refer [migrate rollback]]
            [herald.db :as db]
            [korma.db :refer [with-db]]
            [herald.models.user :as user-mdl]
            [herald.use-cases.manage-user :as uc-user]
            [herald.tests.models.helpers :refer [delete-all count-all]]
            [blancas.morph.monads :refer [run-right either right? left?]]))

(def test-tbl "USERS")
(def test-password "kikkakukka123")
(def encrypted-password (user-mdl/encrypt-password test-password))
(def test-user {:email "abc@def.com"
                :password test-password
                :active true})

;;-- DB altering tests
(def db-spec (:test db/db-configs))
(migrate db-spec)
(def db-conn  (db/connect db-spec))

(facts "add-user"
  (fact "create new user if database is empty"
    (count-all test-tbl) => 0
    (let [res (uc-user/add-user (:email test-user) test-password)
          new-user (run-right res)]
      (right? res)          => true
      (count-all test-tbl)  => 1
      (:email new-user)     => (:email test-user)
      (user-mdl/password-match? test-password
                                (:password new-user))  => true
      (:active new-user)    => true))
  (delete-all test-tbl)

  (fact "returns error if email is already taken"
    (uc-user/add-user (:email test-user) test-password)
    (count-all test-tbl) => 1
    (let [res (uc-user/add-user (:email test-user) "kekkakikkakukka")]
      (left? res) => true))
  (delete-all test-tbl)

  (fact "returns error if data doesnt pass validator"
    (count-all test-tbl) => 0
    (let [res (uc-user/add-user "not-email" "short")]
      (left? res) => true))
  (delete-all test-tbl))


(facts "change-password"
  (fact "it changes password if user pass is correct"
    (let [res (uc-user/add-user (:email test-user) test-password)
          the-user (run-right res)]
      (right? res)          => true
      (count-all test-tbl)  => 1
      (let [res (uc-user/change-password (:id the-user) test-password "x12")
            updated-user (run-right res)]
        (right? res) => true
        (user-mdl/password-match? test-password (:password updated-user)) => false
        (user-mdl/password-match? "x12" (:password updated-user))         => true)))
  (delete-all test-tbl)

  (fact "it doesnt change password if user entered wrong password"
    (let [res (uc-user/add-user (:email test-user) test-password)
          the-user (run-right res)]
      (right? res)          => true
      (count-all test-tbl)  => 1
      (let [res (uc-user/change-password (:id the-user) "x12" "x12")]
        (left? res) => true)))
  (delete-all test-tbl))

(facts "deactivate-user"
  (fact "it deactivates user's account and disallows login"
    (let [res (uc-user/add-user (:email test-user) test-password)
          the-user (run-right res)]
      (right? res)          => true
      (count-all test-tbl)  => 1
      (:active the-user)    => true
      (let [res (uc-user/deactivate-user (:id the-user) test-password)
            updated-user (run-right res)]
        (right? res)           => true
        (:active updated-user) => false)))
  (delete-all test-tbl))

;;-- clean DB
(delete-all test-tbl)
(rollback db-spec 999)

