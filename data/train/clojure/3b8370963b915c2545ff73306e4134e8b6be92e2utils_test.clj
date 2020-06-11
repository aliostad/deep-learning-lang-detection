(ns curd.utils-test
  (:require [clojure.test :refer :all]
            [curd.utils :refer :all]
            [clojure.spec.test.alpha :as stest]))

;; ENABLE INSTRUMENTATION
(stest/instrument `->namespaced-keyword)
(stest/instrument `fail)

(deftest test->kebab-case
  (testing "Should convert map keys from snake_case to kebab-case"
    (is (= (->kebab-case {:a_b 1 :b_c 2 :c_d 3}) {:a-b 1 :b-c 2 :c-d 3})))

  (testing "Input map already has kebab-case keys"
    (is (= (->kebab-case {:a-b 1 :b-c 2 :c-d 3}) {:a-b 1 :b-c 2 :c-d 3}))))

(deftest test->namespaced-keyword
  (testing "Should return namespaced keyword within same namespace"
    (is (= (->namespaced-keyword ::method) :curd.utils-test/method)))
  (testing "Should return namespaced keyword within other namespace"
    (is (= (->namespaced-keyword :other.namespace/method) :other.namespace/method)))
  (testing "Invalid input string, should throw spec validation exception"
    (is (thrown? Exception (->namespaced-keyword "other.namespace/method") :other.namespace/method))))

(deftest test-fail
  (testing "Should throw exception for method ::test"
    (let [message-str (str ":curd.utils-test/test" generic-fail-message)
          message (re-pattern message-str)]
      (is (thrown-with-msg? Exception message
                            (fail ::test (ex-info message-str {}) {})))))
  (testing "Invalid string input, should throw spec validation exception"
    (is (thrown? Exception (fail "test" (ex-info "" {}) {})))))