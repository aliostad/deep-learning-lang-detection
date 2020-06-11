(ns odm-spec.util-test
  (:require
    #?@(:clj
        [[clojure.spec.alpha :as s]
         [clojure.spec.test.alpha :as st]
         [clojure.test :refer :all]]
        :cljs
        [[cljs.spec.alpha :as s]
         [cljs.spec.test.alpha :as st]
         [cljs.test :refer-macros [deftest testing is]]])
         [odm-spec.util :as u]))

(st/instrument)

(deftest oid-spec
  (testing "Generator available"
    (is (doall (s/exercise (u/oid-spec "S") 1)))))

(deftest distinct-oids?-test
  (testing "One OID is good"
    (is (u/distinct-values? :oid [{:oid "1"}])))

  (testing "Distinct OID's are good"
    (is (u/distinct-values? :oid [{:oid "1"} {:oid "2"}])))

  (testing "Duplicate OID's are bad"
    (is (not (u/distinct-values? :oid [{:oid "1"} {:oid "1"}])))))

(deftest distinct-order-numbers?-test
  (testing "No order numbers are good"
    (is (u/distinct-order-numbers? [{} {}])))

  (testing "Distinct order numbers are good"
    (is (u/distinct-order-numbers?
          [{:odm/order-number 1}
           {:odm/order-number 2}]))))
