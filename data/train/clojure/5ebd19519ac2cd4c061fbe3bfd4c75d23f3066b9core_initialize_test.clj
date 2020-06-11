(ns gardendb.core-initialize-test
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
                        :options o})

(def case-test-seeding {:seed joint})

(deftest test-initialize!
  (testing "db initialize!"
    (db/initialize-map! case-test-init-db)
    (doseq [p case-test-init-db]
      (is (= (db/setting (p 0)) (p 1))))
    (db/initialize-map! case-test-seeding)
    (is (= 3 (count (db/documents :jazz))))
    (is (= 4 (count (db/documents :fruit))))))
