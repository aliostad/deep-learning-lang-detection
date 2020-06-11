(ns blog.comment.comment-sql-datastore-impl-test
  (:require [clojure.test :refer :all]
            [blog.comment.comment-sql-datastore-impl :refer :all]
            [clojure.java.jdbc :as jdbc]))


; test functions that operate on the database

(deftest database-operations
  (let [db-spec {:subprotocol "hsqldb"
                 :subname (str "mem:testdb"
                               ";shutdown=true"
                               ";sql.syntax_pgs=true")
                 :user "SA"
                 :password ""}]
    (jdbc/with-db-connection [con db-spec]

      (testing "create-comment-table"
        (is (= (create-comment-table {:db con})
               :ok)))

      (testing "save-comment"
        (is (= (save-comment {:db con}
                             {:name "some author"
                              :text "some text"
                              :time (java.util.Date.)}
                       "the-article")
               :ok)))

      (testing "select-comments"
        (let [[c] (select-comments {:db con} "the-article")]
          (are [k v] (= (k c) v)
               :name "some author"
               :text "some text"))
        (is (= (select-comments {:db con} "the-wrong-article")
               [])))

      (testing "select-comment-count"
        (is (= (select-comment-count con "the-article")
               1))
        (is (= (select-comment-count con "the-wrong-article")
               0)))

      (testing "select-comment-counts"
        (is (= (select-comment-counts {:db con} ["the-article"])
               {"the-article" 1}))
        (is (= (select-comment-counts {:db con} ["the-wrong-article"])
               {"the-wrong-article" 0}))))))


; test functions that manage the database entries

(deftest database-management-operations
  (let [db-spec {:subprotocol "hsqldb"
                 :subname (str "mem:testdb"
                               ";shutdown=true"
                               ";sql.syntax_pgs=true")
                 :user "SA"
                 :password ""}]
    (jdbc/with-db-connection [con db-spec]

      (testing "create-comment-table"
        (is (= (create-comment-table {:db con})
               :ok)))

      (testing "save-comment"
        (is (= (save-comment {:db con}
                             {:name "some author"
                              :text "some text"
                              :time (java.util.Date.)}
                       "the-article")
               :ok)))

      (testing "delete-comment"
        (let [[c] (select-comments {:db con} "the-article")]
          (are [k v] (= (k c) v)
               :name "some author"
               :text "some text")
          (is (= (delete-comment {:db con} (str (:id c)))
                 :ok))
          (is (= (select-comments {:db con} "the-article")
                 [])))))))
