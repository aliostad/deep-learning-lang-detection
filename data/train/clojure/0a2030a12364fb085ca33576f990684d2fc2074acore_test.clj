(ns stack.core-test
  (:require [clojure.test :refer :all]
            [bond.james :as bond]
            [stack.core :as core]))

(deftest make-dispatch-fn-test
  (testing "#'make-dispatch-fn"
    (testing "with no args"
      (testing "applies :help"
        (let [foo (constantly nil)
              help (bond/spy (constantly nil))
              error-fn (constantly nil)
              dispatch (core/make-dispatch-fn {:foo foo, :help help}
                                              error-fn)]
          (dispatch)
          (is (= (-> (bond/calls help) count) 1)))))

    (testing "with --help"
      (testing "applies :help"
        (let [foo (constantly nil)
              help (bond/spy (constantly nil))
              error-fn (constantly nil)
              dispatch (core/make-dispatch-fn {:foo foo, :help help}
                                              error-fn)]
          (dispatch "--help")
          (is (= (-> (bond/calls help) count) 1)))))

    (testing "with a valid sub-command"
      (testing "applies the remaining args to the command"
        (let [foo (bond/spy (constantly nil))
              help (constantly nil)
              error-fn (constantly nil)
              dispatch (core/make-dispatch-fn {:foo foo, :help help}
                                              error-fn)]
          (dispatch "foo" "a" "b")
          (is (= (-> (bond/calls foo) first :args)
                 ["a" "b"])))))

    (testing "with an invalid sub-command"
      (testing "applies error-fn"
        (let [help (constantly nil)
              error-fn (bond/spy (constantly nil))
              dispatch (core/make-dispatch-fn {:help help}
                                              error-fn)]
          (dispatch "boo" "a" "b")
          (is (= (-> (bond/calls error-fn) count) 1)))))))
