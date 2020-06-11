(ns gardendb.core-pull-test
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


(deftest test-pull!
  (testing "Pulling document and document elements from database."
    (db/initialize-map! case-test-init-db)

    (is (= 4 (count (db/documents :jazz))) "initial seed c :jazz has 4 docs")

    (is (= (db/pull :jazz :coltrane :instrument) :sax) "coltrane instrument is sax.")
    (is (nil? (db/pull :jazz :coltrane :fav-color)) "no coltrane fav color; should be nil.")

    (is (nil? (db/pull :jazz :coltrane :albums)) "no coltrane albums yet; should be nil.")

    (db/put! :jazz (assoc (db/document :jazz :coltrane)
                     :album-list coltrane-album-list
                     :albums coltrane-albums))

    (is (db/pull :jazz :coltrane :album-list) "coltrane album list should be populated.")
    (is (db/pull :jazz :coltrane :albums) "coltrane albums should be populated.")

    (let [album-list (db/pull :jazz :coltrane :album-list)]
      (is (= 4 (count album-list)) "albums should be 4")
      (is (= '(1960 1961 1964 1967) (map #(:released %) (sort-by :released album-list)))))

    ; drill down pull tests
    (is (= (db/pull :jazz :coltrane :albums :my-fav-things :title) "My Favorite Things"))
    (is (= (db/pull :jazz :coltrane :albums :giant-steps :title) "Giant Steps"))
    (is (= (db/pull :jazz :coltrane :albums :expression :title) "Expression"))
    (is (= (db/pull :jazz :coltrane :albums :live-at-birdland :title) "Live at Birdland"))))
