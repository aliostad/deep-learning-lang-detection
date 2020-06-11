(ns gardendb.core-query-test
  (:use clojure.test)
  (:require [gardendb.core :as db]))

(def jazz {:jazz {:torme {:_id :torme :_rev "1-a" :_v 1 :fn "Mel" :ln "Torme" :instrument :vocals}
                  :monk {:_id :monk :_rev "1-b" :_v 1 :fn "Thelonious" :ln "Monk" :instrument :sax}
                  :grappelli {:_id :grappelli :_rev "1-c" :_v 1 :fn "Stephane" :ln "Grappelli" :instrument :violin}
                  :coltrane {:_id :coltrane :_rev "1-d" :_v 1 :fn "John" :ln "Coltrane" :instrument :sax}}})

(def case-test-init-db {:clear? true
                        :revisions? false
                        :persists? false
                        :seed jazz})

(def coltrane-album-list [{:title "My Favorite Things" :released 1961}
                          {:title "Giant Steps" :released 1960}
                          {:title "Expression" :released 1967}
                          {:title "Live at Birdland" :released 1964}])

(def coltrane-albums {:my-fav-things {:title "My Favorite Things" :released 1961}
                      :giant-steps {:title "Giant Steps" :released 1960}
                      :expression {:title "Expression" :released 1967}
                      :live-at-birdland {:title "Live at Birdland" :released 1964}})


(deftest test-query
  (testing "Querying document and document elements from database."
    (db/initialize-map! case-test-init-db)

    (is (= 4 (count (db/documents :jazz))) "initial seed c :jazz has 4 docs")

    (is (= (db/pull :jazz :coltrane :instrument) :sax) "coltrane instrument is sax.")
    (is (nil? (db/pull :jazz :coltrane :fav-color)) "no coltrane fav color; should be nil.")

    (is (nil? (db/pull :jazz :coltrane :albums)) "no coltrane albums yet; should be nil.")

    (db/put! :jazz (assoc (db/document :jazz :coltrane)
                     :album-list coltrane-album-list
                     :albums coltrane-albums))

    (is (= 4 (count (db/query :jazz))) "no :where clause, all 4 docs should be returned.")

    (is (= 1 (count (db/query :jazz
                              :where [#(= :vocals (:instrument %))]))) "only 1 doc returned.")

    (is (= :torme (:_id (first (db/query :jazz
                                         :where [#(= :vocals (:instrument %))])))) "only :torme doc returned.")

    (is (= 1 (count (db/query :jazz
                              :where [#(= :vocals (:instrument %))]
                              :limit 1))) "only 1 doc returned.")

    (is (= :torme (:_id (first (db/query :jazz
                                         :where [#(= :vocals (:instrument %))]
                                         :limit 1)))) "only :torme doc returned.")

    (is (= 1 (count (db/query :jazz
                              :where [#(= :vocals (:instrument %))]
                              :limit 2))) "only 1 doc returned.")

    (is (= :torme (:_id (first (db/query :jazz
                                         :where [#(= :vocals (:instrument %))]
                                         :limit 2)))) "only :torme doc returned.")

    (is (= '({:ln "Coltrane"} {:ln "Grappelli"} {:ln "Monk"} {:ln "Torme"})
           (db/query :jazz
                     :order-by :ln
                     :keys [:ln])) "check :order-by")))
