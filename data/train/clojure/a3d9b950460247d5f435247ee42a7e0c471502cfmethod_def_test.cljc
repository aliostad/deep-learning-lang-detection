(ns odm.method-def-test
  (:require
    #?@(:clj
        [[clojure.spec.alpha :as s]
         [clojure.spec.test.alpha :as st]
         [clojure.test :refer :all]
         [odm-spec.test-util :refer [given-problems]]]
        :cljs
        [[cljs.spec.alpha :as s]
         [cljs.spec.test.alpha :as st]
         [cljs.test :refer-macros [deftest testing is are]]
         [odm-spec.test-util :refer-macros [given-problems]]])
         [odm.method-def]))

(st/instrument)

(deftest method-def-test
  (testing "Valid method definitions"
    (are [x] (s/valid? :odm/method-def x)
      #:odm.method-def
          {:oid "M01"
           :name "foo"
           :type :other
           :odm/description
           [{:lang-tag "de" :text "bar"}]}))

  (testing "Generator available"
    (is (doall (s/exercise :odm/method-def 1)))))
