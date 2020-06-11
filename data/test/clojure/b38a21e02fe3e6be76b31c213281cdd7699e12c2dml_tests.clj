(ns garcimore.dml-tests
  (:require [clojure.test :refer [deftest are is]]
            [clojure.spec.test :as stest]
            [garcimore.dml :as gdml]))

(stest/instrument 'garcimore.dml/diff-row)

(deftest diff-row
  (is (= {} (gdml/diff-row {"a" 1} {"a" 1})))
  (is (= {"a" [1 2]} (gdml/diff-row {"a" 1} {"a" 2})))
  (is (= {"a" [2 1]} (gdml/diff-row {"a" 2} {"a" 1})))
  (is (= {"a" [2 1] "b" [3 4]} (gdml/diff-row {"a" 2 "b" 3} {"a" 1 "b" 4}))))

#_
(deftest primary-key-values
  (is (= {"id" 1} (gdml/primary-key-values ["id"] {"id" 1 "key""value"})))
  (is (= {"id" 1 "key" "value"} (gdml/primary-key-values ["id" "key"] {"id" 1 "key""value"}))))

(stest/instrument 'garcimore.dml/diff-table-with-primary-keys)

(deftest diff-table-with-primary-keys
  (is (= {:inserted [{"id" 2 "a" 3 "b" 4}]}
         (gdml/diff-table-with-primary-keys ["id"]
                                           [{"id" 1 "a" 1 "b" 2}]
                                           [{"id" 1 "a" 1 "b" 2}
                                            {"id" 2 "a" 3 "b" 4}])))
  (is (= {:updated [{"id" 1 "a" [1 2]}]}
         (gdml/diff-table-with-primary-keys ["id"]
                                           [{"id" 1 "a" 1 "b" 3}]
                                           [{"id" 1 "a" 2 "b" 3}])))
  (is (= {:updated [{"id" 2 "a" [3 5] "b" [4 6]}{"id" 1 "c" [7 8]}]}
         (gdml/diff-table-with-primary-keys ["id"]
                                           [{"id" 1 "a" 1 "b" 2 "c" 7}
                                            {"id" 2 "a" 3 "b" 4}]
                                           [{"id" 2 "a" 5 "b" 6}
                                            {"id" 1 "a" 1 "b" 2 "c" 8}])))
  (is (= {:deleted [{"id" 2 "a" 3 "b" 4}]}
         (gdml/diff-table-with-primary-keys ["id"]
                                           [{"id" 1 "a" 1 "b" 2}
                                            {"id" 2 "a" 3 "b" 4}]
                                           [{"id" 1 "a" 1 "b" 2}])))

  (is (= {:inserted [{"ID" 3 "APPEARANCE" "rosy" "COST" 24}]
          :updated [{"ID" 4 "APPEARANCE" ["rosy" "round"] "COST" [49 24]}]
          :deleted [{"ID" 2 "APPEARANCE" "round" "COST" 49}]}
         (gdml/diff-table-with-primary-keys ["ID"]
                                           [{"ID" 1 "APPEARANCE" "rosy" "COST" 24}
                                            {"ID" 2 "APPEARANCE" "round" "COST" 49}
                                            {"ID" 4 "APPEARANCE" "rosy" "COST" 49}]
                                           [{"ID" 3 "APPEARANCE" "rosy" "COST" 24}
                                            {"ID" 1 "APPEARANCE" "rosy" "COST" 24}
                                            {"ID" 4 "APPEARANCE" "round" "COST" 24}]))))

(deftest diff-table
  (is (= {"FRUIT" {:inserted [{"ID" 2 "APPEARANCE" "round" "COST" 24}]}}
         (gdml/diff-tables {"FRUIT" {:constraints {:primary-keys ["ID"]}}}
                          {"FRUIT"
                           [{"ID" 1 "APPEARANCE" "rosy" "COST" 49}]}
                          {"FRUIT"
                           [{"ID" 1 "APPEARANCE" "rosy" "COST" 49}
                            {"ID" 2 "APPEARANCE" "round" "COST" 24}]}))))
