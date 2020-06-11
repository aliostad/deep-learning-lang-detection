(ns takelist.db-test
  (:require [clojure.java.jdbc :as j]
            [clojure.spec.test :as st]
            [clojure.test :refer :all]
            [takelist.db :as db :refer :all]))

(st/instrument)

(deftest find-user-query-test
  (are [props constraints query] (= query (find-user-query props constraints))
    [:id]
    {:id 1}
    "select id from tkl_user where id = ?"

    [:id :name]
    {:id 1}
    "select id, name from tkl_user where id = ?"

    [:id]
    {:issuer "foo", :subject "bar"}
    "select id from tkl_user where issuer = ? and subject = ?"))

(deftest create-user-test
  (testing "Blank username is forbidden"
    (is (thrown? Exception (create-user! {} {:name "" :issuer "foo" :subject "bar"})))))
