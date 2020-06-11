(ns leiningen.sql-generation-test
  (:require [clojure.test :refer :all]
            [de.sveri.clospcrud.liquibase :as liq]
            [leiningen.common :refer [person-definition]]
            [clojure.spec :as s]))

(defn create-h2-connection []
  (liq/get-db-connection :h2 {:target :memory :database :default}))

(deftest create-table-h2
  (let [cs-string (first (liq/change-sql (liq/create-table person-definition) (create-h2-connection)))]
    (is (.startsWith cs-string "CREATE TABLE PUBLIC.person"))
    (is (.contains cs-string "fooname"))
    (is (.contains cs-string "age"))
    (is (.contains cs-string "CONSTRAINT PK_PERSON PRIMARY KEY"))))

(deftest drop-table-h2
  (is (= (str "DROP TABLE " (:name person-definition)) (liq/drop-table-sql person-definition))))


(s/instrument-all)