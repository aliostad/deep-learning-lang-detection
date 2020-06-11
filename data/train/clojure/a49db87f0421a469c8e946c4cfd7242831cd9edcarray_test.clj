(ns spede.array-test
  (:require  [clojure.test :as t]
             [spede.core :as sd]
             [clojure.spec :as s]
             [clojure.spec.test :as st]
             [spede.test-utils :as tu])
  (:import clojure.lang.ExceptionInfo))

(sd/sdefn some-func [[a b]]
  (+ a b))

(sd/sdefn some-other-func [[a b :as ugh]]
  (+ a b (apply + ugh)))

(sd/sdefn func-with-rest [[a b & c]]
  (apply + (into [a b] c)))

(st/instrument [`some-func
                `some-other-func
                `func-with-rest])

(t/deftest array-destr
  (t/is (= 3 (some-func [1 2]))))

(t/deftest array-as
  (t/is (= 6 (some-other-func [1 2]))))

(t/deftest test-seq
  (t/is (= 3 (some-func (list 1 2))))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-func 1))))

(t/deftest seq-len
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-func [1]))))

(t/deftest with-rest
  (t/is (= 6 (func-with-rest [1 2 3])))
  (t/is (= 3 (func-with-rest [1 2])))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (func-with-rest [1]))))

(t/deftest argname
  (t/is (= :ugh (tu/get-name-of-first-arg `some-other-func))))
