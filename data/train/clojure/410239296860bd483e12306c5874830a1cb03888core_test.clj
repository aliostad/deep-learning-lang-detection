(ns hugsql-finagle-async.core-test
  (:require [clojure.core.async :as async]
            [clojure.java.io :as io]
            [clojure.test :refer :all]
            [finagle-clojure.mysql.client :as mysql]
            [hugsql-finagle-async.core :refer :all]
            [hugsql.core :as hugsql]))

(def mysql-config
  {:user     "root"
   :password "BEE38DF8AA2040C4"
   :db       "testDB"
   :endpoint "127.0.0.1:33060"})


(def Client
  (let [{:keys [user password db endpoint]} mysql-config]
    (-> (mysql/mysql-client)
        (mysql/with-credentials user password)
        (mysql/with-database db)
        (mysql/rich-client endpoint))))

(hugsql/def-db-fns
  (io/file "test/resources/fns.sql"))

(hugsql/set-adapter! (hugsql-adapter-finagle-async))


(deftest integrate-test
  (testing "select character with no database"
    (is (instance? com.twitter.finagle.mysql.ServerError
                   (async/<!! (select-character-star Client {:id 1})))))

  (testing "create character table"
    ;; TODO: manage it to a specific test and a fixture in this function
    ;; FIXME: this is the incompatible part from jdbc.
    (is (= (async/<!! (create-characters-table Client)) []))

    ;; Create a existed table will return a nil.
    (is (instance? com.twitter.finagle.mysql.ServerError
                   (async/<!! (create-characters-table Client)))))

  (testing "select character with no data"
    (is (nil? (async/<!! (select-character-star Client {:id 0})))))


  (testing "insert a weight 0 character"
    (is (= (async/<!! (insert-character Client {:name "Chris" :weight 0}))
           [])))

  (testing "select character with 1 record"
    (is (async/<!! (select-character-star Client {:id 1}))))

  (testing "select the weight 0 character with dynamic table-name"
    (is (= (zero? (:weight (async/<!! (select-character-by-weight Client {:weight 0
                                                                          :table-name "characters"})))))))

  (testing "test the unique constaints by insert another weight 0 character"
    (is (instance?
         com.twitter.finagle.mysql.ServerError
         (async/<!! (insert-character Client {:name "Richard" :weight 0})))))

  (testing "select character with not exist DB"
    (is (instance? com.twitter.finagle.mysql.ServerError
                   (async/<!! (select-character-by-weight
                               Client
                               {:weight 0
                                :table-name "characters1"})))))


  (testing "raw return query with multiple recoreds returning"
    (doseq [i (range 10)]
      (insert-character Client
                        {:name "Chris" :weight i}))
    (is (= 10 (count (async/<!! (raw-query-character-less-than Client {:weight 10}))))))

  (testing "drop character table"
    (async/<!! (drop-characters-table Client))))


#_(deftest still-have-asynchrounous-ability
    (testing "asynchrounously insert 100 record character"
      ;; TODO:
      (is (async/<!! (async/map
                      (constantly true)
                      (for [i (range 10)]
                        (insert-character Client
                                          {:name "Chris" :weight i})))))
      ))
