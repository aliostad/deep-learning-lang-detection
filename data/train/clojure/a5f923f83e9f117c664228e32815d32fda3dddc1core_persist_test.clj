(ns gardendb.core-persist-test
  (:use clojure.test)
  (:require [gardendb.core :as db]
           [clojure.java.io :as io]))

(def fruit {:fruit {:cherry {:_id :cherry :_rev "1-a" :_v 1 :color :red :region :temperate}
                    :apple {:_id :apple :_rev "1-b" :_v 1 :color :green :region :temperate}
                    :rasp {:_id :rasp :_rev "1-c" :_v 1 :color :red :region :temperate}
                    :banana {:_id :banana :_rev "1-d" :_v 1 :color :yellow :region :tropical}}})

(def jazz {:jazz {:torme {:_id :torme :fn "Mel" :ln "Torme" :instrument :vocals}
                  :monk {:_id :monk :fn "Thelonious" :ln "Monk" :instrument :sax}
                  :grappelli {:_id :grappelli :fn "Stephane" :ln "Grappelli" :instrument :violin}}})

(def joint (merge fruit jazz))

(def o {:collections {:fruit {:revisions? false}
                      :jazz {:volatile? false}}})

(def case-test-init-db {:clear? true
                        :db-name "core-persist-test.tmp"
                        :path ""
                        :host ""
                        :protocol :file
                        :revisions? false
                        :persists? false
                        :seed joint
                        :options o})

(deftest test-persist!
  (testing "db persist!"
    (db/initialize-map! case-test-init-db)
    (let [f (java.io.File. (db/db-fn))]
      (io/delete-file f true)
      (is (= 3 (count (db/documents :jazz))) "initial seed c :jazz has 3 docs")
      (is (= 4 (count (db/documents :fruit))) "intial seed c :fruit has 4 docs")
      (db/persists! true)
      (db/persist!)
      (is (.exists f) "should persist! if persists? is true")
      (io/delete-file f true)
      (db/persists! false)
      (db/persist!)
      (is (not (.exists f)) "if persists? is false, no persisted file should be created.")
      (db/force-persist!)
      (is (.exists f) "if persists? is false but force-persist! called, should be persisted")
      (db/clear-store!)
      (is (= @db/store {}) "store should be empty post clear-store!")
      (db/load!)
      (is (= 3 (count (db/documents :jazz))) "initial seed c :jazz has 3 docs; loaded post persist")
      (is (= 4 (count (db/documents :fruit))) "intial seed c :fruit has 4 docs; loaded post persist")
      (db/collection-option! :jazz :volatile? true) ; set the c :jazz to be volatile and do not persist
      (db/force-persist!)
      (db/clear-store!)
      (db/load!)
      (is (= 0 (count (db/documents :jazz))) "c :jazz was set to :volatile? true so not persisted")
      (is (= 4 (count (db/documents :fruit))) "c :fruit has 4 docs; loaded post persist")
      (db/clear!)
      (io/delete-file f true))))
