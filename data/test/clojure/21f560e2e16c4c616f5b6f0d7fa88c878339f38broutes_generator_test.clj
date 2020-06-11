(ns leiningen.routes-generator-test
  (:require [clojure.test :refer :all]
            [de.sveri.clospcrud.routes-generator :as rg]
            [leiningen.common :refer [person-definition]]
            [clojure.spec :as s]))

(deftest contains-boolean
  (is (rg/boolean? {:name "too" :type :boolean}))
  (is (not (rg/boolean? {:name "too" :type :int}))))

(deftest create-add-fns
  (let [add-fns (rg/create-add-fns (:columns person-definition))]
    (is (.contains add-fns "(defn convert-boolean [b] (if (= \"on\" b) true false))"))
    (is (nil? (rg/create-add-fns [{:name "foo" :type :int}])))))


(s/instrument-all)