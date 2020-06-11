(ns gardendb.core-delete-test
  (:use clojure.test)
  (:require [gardendb.core :as db]))

(def fruit {:fruit
               {:cherry {:_id :cherry :_rev "1-a" :_v 1 :color :red :region :temperate}
                :apple {:_id :apple :_rev "1-b" :_v 1 :color :green :region :temperate}
                :rasp {:_id :rasp :_rev "1-c" :_v 1 :color :red :region :temperate}
                :banana {:_id :banana :_rev "1-d" :_v 1 :color :yellow :region :tropical}}})

(def jazz {:jazz {:torme {:_id :torme :fn "Mel" :ln "Torme" :instrument :vocals}
                  :monk {:_id :monk :fn "Thelonious" :ln "Monk" :instrument :sax}
                  :grappelli {:_id :grappelli :fn "Stephane" :ln "Grappelli" :instrument :violin}}})

(def joint (merge fruit jazz))

(def o {:collections {:fruit {:revisions? true}
                      :jazz {:volatile? true}}})

(def case-test-init-db {:db-name "db-name"
                        :path "path"
                        :host "host"
                        :protocol :mem
                        :revisions? false
                        :persists? false
                        :seed joint
                        :options o})

(deftest test-delete!
  (testing "db delete!"
      (db/clear!)
      (db/initialize-map! case-test-init-db)
      (is (= 3 (count (db/documents :jazz))) "initial seed c :jazz has 3 docs")
      (is (= 4 (count (db/documents :fruit))) "intial seed c :fruit has 4 docs")
      (is (= :cherry (:_id (db/pull :fruit :cherry))) "should be a :cherry doc in :fruit")
      (db/delete! :fruit :cherry)
      (is (= 3 (count (db/documents :jazz))) ":jazz should still have 3 docs")
      (is (= 3 (count (db/documents :fruit))) ":fruit should now have 3 docs")
      (is (nil? (db/pull :fruit :cherry)) "make sure document is gone")
      (db/delete! :fruit :cherry)
      (is (= 3 (count (db/documents :fruit))) ":fruit still has 3 docs")
      (is (= :banana (db/pull :fruit :banana :_id)) "should be a :banana doc in :fruit")
      (db/delete! :fruit :banana)
      (is (= 2 (count (db/documents :fruit))) ":fruit should now have 2 docs")
      (is (nil? (db/pull :fruit :banana)) ":banana should be nil for c :fruit")))
