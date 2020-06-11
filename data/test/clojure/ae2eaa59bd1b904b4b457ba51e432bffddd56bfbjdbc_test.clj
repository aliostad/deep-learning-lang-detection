(ns hugsql-finagle-async.jdbc-test
  (:require [clojure.core.async :as async]
            [clojure.test :refer :all]
            [clojure.java.io :as io]
            [clojure.java.jdbc :as jdbc]
            [hugsql.core :as hugsql]
            [hugsql-finagle-async.jdbc :as jdbc-adapter]
            [clojure.string :as str]))

(hugsql/set-adapter! (jdbc-adapter/hugsql-adapter-clojure-async-jdbc))

(def h2-config
  {:classname   "org.h2.Driver"
   :subprotocol "h2:mem"
   :subname     "testdb0;MODE=MySQL;DB_CLOSE_DELAY=-1"
   :user        "test"
   :password    "sav"})


(def H2DB
  {:connection (jdbc/get-connection h2-config)})

(hugsql/def-db-fns
  (io/file "test/resources/fns.sql"))


(deftest integrate-test
  (testing "select character with no database"
    (is (instance? org.h2.jdbc.JdbcSQLException
                   (async/<!! (select-character-star H2DB {:id 1})))))

  (testing "create character table"
    ;; TODO: manage it to a specific test and a fixture in this function
    (is (= (async/<!! (create-characters-table H2DB)) [0]))

    ;; Create a existed table will return a nil.
    (is (instance? org.h2.jdbc.JdbcSQLException
                   (async/<!! (create-characters-table H2DB)))))

  (testing "select character with no data"
    (is (nil? (async/<!! (select-character-star H2DB {:id 0})))))


  (testing "insert a weight 0 character"
    (is (= (async/<!! (insert-character H2DB {:name "Chris" :weight 0}))
           [1])))

  (testing "select character with 1 record"
    (is (async/<!! (select-character-star H2DB {:id 1}))))

  (testing "select the weight 0 character with dynamic table-name"
    (is (= (zero? (:weight (async/<!! (select-character-by-weight
                                       H2DB
                                       {:weight 0
                                        :table-name "characters"})))))))

  (testing "test the unique constaints by insert another weight 0 character"
    (is (instance? org.h2.jdbc.JdbcBatchUpdateException
                   (async/<!! (insert-character
                               H2DB
                               {:name "Richard" :weight 0})))))

  (testing "select character with not exist DB"
    (is (instance? org.h2.jdbc.JdbcSQLException
                   (async/<!! (select-character-by-weight
                               H2DB
                               {:weight 0
                                :table-name "characters1"})))))

  (testing "raw return query with multiple recoreds returning"
    (doseq [i (range 10)]
      (insert-character H2DB
                        {:name "Chris" :weight i}))
    (is (= 10 (count (async/<!! (raw-query-character-less-than H2DB {:weight 10}))))))

  (testing "drop character table"
    (async/<!! (drop-characters-table H2DB))))
