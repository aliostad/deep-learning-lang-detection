(ns spede.destruct-map-or-test
  (:require  [clojure.test :as t]
             [spede.core :as es]
             [clojure.spec :as s]
             [clojure.spec.test :as st]
             [spede.test-utils :as tu])
  (:import clojure.lang.ExceptionInfo))

(s/def ::a integer?)
(s/def ::b integer?)

(es/sdefn some-func [{aa ::a b ::b :or {aa 0}}]
  (+ aa b))

(es/sdefn some-other-func [{:keys [:a :b] :or {a 0}}]
  (+ a b))

(st/instrument `some-func)
(st/instrument `some-other-func)

(t/deftest namespaced
  (t/is (= 5 (some-func {::a 2 ::b 3})))
  (t/is (= 2 (some-func {::b 2})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-func {::c 123})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-func {::a 999})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-func {:b 2}))))

(t/deftest un-namespaced
  (t/is (= 5 (some-other-func {:a 2 :b 3})))
  (t/is (= 2 (some-other-func {:b 2})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-other-func {:c 123})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-other-func {:a 999})))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (some-other-func {::b 2}))))

