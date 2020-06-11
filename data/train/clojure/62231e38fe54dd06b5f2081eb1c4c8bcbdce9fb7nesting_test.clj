(ns spede.nesting-test
  (:require  [clojure.test :as t]
             [spede.core :as sd]
             [clojure.spec :as s]
             [clojure.spec.test :as st]
             [spede.test-utils :as tu]))

(s/def ::a integer?)

(sd/sdefn fun [[{a :a} b] c]
  (+ a b c))

(sd/sdefn funv [[[a b] c] d]
  (+ a b c d))

(sd/sdefn fun-more [[[a] b] & c]
  (+ a b (apply * c)))

(st/instrument [`fun
                `funv
                `fun-more])

(t/deftest normal-call
  (t/is (= 6 (fun [{:a 1 :b 2} 2] 3)))
  (t/is (= 7 (funv [[1 1] 2] 3)))
  (t/is (= 9 (fun-more [[1] 2] 2 3)))
  (t/is (= 6 (fun-more [[1] 2] 3))))

(t/deftest spec-fail
  (t/is (thrown-with-msg? clojure.lang.ExceptionInfo tu/spec-err
                          (fun [{:a "ugh"} 2] 3)))
  (t/is (thrown-with-msg? clojure.lang.ExceptionInfo tu/spec-err
                          (fun [1 2] 3)))
  (t/is (thrown-with-msg? clojure.lang.ExceptionInfo tu/spec-err
                          (fun [1 2])))
  (t/is (thrown-with-msg? clojure.lang.ExceptionInfo tu/spec-err
                          (funv [[1] 2] 3)))
  (t/is (thrown-with-msg? clojure.lang.ExceptionInfo tu/spec-err
                          (funv [1 1 2] 3))))
