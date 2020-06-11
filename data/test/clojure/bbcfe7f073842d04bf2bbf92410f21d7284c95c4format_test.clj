(ns pancake.format-test
  (:refer-clojure :exclude [format])
  (:require [clojure.test :refer [are deftest is]]
            [clojure.string :as str]
            [pancake.format :as format]

            [clojure.spec.alpha :as s]
            [clojure.spec.gen.alpha :as gen]
            [clojure.spec.test.alpha :as stest]))

(stest/instrument)

(def format-with-no-value-specs
  {:id "test-format"
   :type "delimited"
   :delimiter \|
   :description "Test format."
   :spec :domain/item
   :cells [{:id :id :index 0 :spec :tailor/to-trimmed}
           {:id :amount :index 1 :spec :tailor/to-double}]})

(deftest no-value-specs
  (is (= {:id :tailor/to-trimmed, :amount :tailor/to-double}
         (format/value-specs format-with-no-value-specs))))

(def format-with-two-value-specs
  {:id "test-format"
   :type "delimited"
   :delimiter \|
   :description "Test format."
   :spec :domain/item
   :cells [{:id :id :index 0 :spec :tailor/to-trimmed}
           {:id :amount :index 1 :spec :tailor/to-double}]})

(deftest two-value-specs
  (is (= {:id :tailor/to-trimmed
          :amount :tailor/to-double}
         (format/value-specs format-with-two-value-specs))))
