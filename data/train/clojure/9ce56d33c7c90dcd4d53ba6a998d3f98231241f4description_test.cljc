(ns odm.description-test
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
         [odm.description]))

(st/instrument)

(deftest description-test
  (testing "Valid descriptions"
    (are [x] (s/valid? :odm/description x)
      [{:lang-tag "de" :text "foo"}]))

  (testing "Invalid description key"
    (given-problems (s/keys :req [:odm/description])
      {:odm/description nil}
      [first :path] := [:odm/description]
      [first :pred] := `coll?))

  (testing "Generator available"
    (is (doall (s/exercise :odm/description 1)))))
