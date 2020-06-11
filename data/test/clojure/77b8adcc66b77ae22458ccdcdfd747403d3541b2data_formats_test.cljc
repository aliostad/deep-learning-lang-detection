(ns odm.data-formats-test
  (:require
    #?@(:clj
        [[clojure.spec.alpha :as s]
         [clojure.spec.test.alpha :as st]
         [clojure.test :refer :all]]
        :cljs
        [[cljs.spec.alpha :as s]
         [cljs.spec.test.alpha :as st]
         [cljs.test :refer-macros [deftest testing is are]]])
         [odm.data-formats :as df]))

(st/instrument)

(deftest sas-name-test
  (testing "Valid SAS names"
    (are [x] (s/valid? ::df/sas-name x)
      "aaaaaaaa"
      "a1234567"
      "_1234567"
      "STUDYID"
      "SUBJID"
      "SEX"))

  (testing "Invalid SAS names"
    (are [x] (not (s/valid? ::df/sas-name x))
      "1"
      "a12345678"
      ""))

  (testing "Generator available"
    (is (doall (s/exercise ::df/sas-name 1)))))

(deftest translated-text-test
  (are [x] (s/valid? ::df/translated-text x)
    [{:lang-tag "de" :text "foo"}]

    [{:lang-tag "de" :text "foo"}]

    [{:lang-tag "de" :text "foo"}
     {:lang-tag "en" :text "bar"}])

  (are [x] (not (s/valid? ::df/translated-text x))
    [{}]

    [{:lang-tag "de" :text "foo"}
     {:lang-tag "de" :text "bar"}])

  (testing "Generator available"
    (is (doall (s/exercise ::df/translated-text 1)))))
