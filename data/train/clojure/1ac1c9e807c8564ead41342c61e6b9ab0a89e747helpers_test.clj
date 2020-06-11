(ns dspec.helpers-test
  (:require [clojure.test :refer :all]
            [clojure.spec.test :as stest]
            [lab79.dspec.helpers :refer :all]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [datomic.api :as d]
            [dspec.util :refer [db-id?]]))

; Instrument all our functions in dspec
(doseq [nspace ['lab79.dspec 'lab79.dspec.helpers]]
  (-> (stest/enumerate-namespace nspace)
    stest/instrument))

(let [specs [#:interface.def{:name :interface/helper-a
                             :fields {:helper-a/key [:keyword :gen/should-generate]}
                             :identify-via [['?e :helper-a/key]]}]]
  (deftest test-specs->datomic
    (let [{:datomic/keys [partition-schema enum-schema field-schema]} (specs->datomic specs d/tempid)]
      (is (empty? partition-schema))
      (is (empty? enum-schema))
      (is (= #{{:db/ident :helper-a/key
                :db/valueType :db.type/keyword
                :db/cardinality :db.cardinality/one
                :db.install/_attribute :db.part/db}}
             (set (map #(dissoc % :db/id) field-schema))))))

  (deftest test-create-clojure-specs!
    ; should not throw
    (create-clojure-specs! specs d/tempid db-id?))

  (deftest test-create-clojure-specs-with-custom-generators!
    ; should not throw
    (let [generators {:helper-a/key #(gen/fmap
                                       (fn [string] (keyword "constant-ns" string))
                                       (gen/string-alphanumeric))}]
      (create-clojure-specs-with-custom-generators! specs generators d/tempid db-id?))))
