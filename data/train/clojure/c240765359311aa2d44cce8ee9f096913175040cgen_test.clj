(ns dspec.gen-test
  (:require [clojure.test.check.clojure-test :refer [defspec]]
            [clojure.test.check.properties :as prop]
            [clojure.spec.test :as stest]
            [lab79.dspec.gen :refer :all]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]))

(doseq [nspace ['lab79.dspec 'lab79.dspec.gen]]
  (-> (stest/enumerate-namespace nspace)
    stest/instrument))

(let [gen-factory (only-keys-gen :x/x :y/y)
      _ (s/def :x/x keyword?)
      _ (s/def :y/y keyword?)
      generator (gen-factory #(s/keys))]
  (defspec test-only-keys-gen
           100
           (prop/for-all [m generator]
                         (= #{:x/x :y/y}
                            (set (keys m))))))
