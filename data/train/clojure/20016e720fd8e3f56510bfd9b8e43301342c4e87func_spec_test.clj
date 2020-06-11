(ns spede.func-spec-test
  (:require  [clojure.test :as t]
             [spede.core :as sd]
             [spede.test-utils :as tu]
             [clojure.spec.test :as st]
             [clojure.spec :as s])
  (:import clojure.lang.ExceptionInfo))

(sd/sdefn fun
  "function which has function specs"
  :args #(= 0 (apply + (vals %)))
  [a b c]
  (* a b c))

(s/def ::a pos-int?)

(sd/sdefn fun-2
  "function which has function specs"
  :args #(= 0 (apply + (vals %)))
  [a ::a b c]
  (* a b c))

(defn separate-predicate?
  [arg]
  (= 0 (+ (:a arg) (:b arg) (:c arg))))

(sd/sdefn fun-3
  "function which has function specs"
  :args separate-predicate?
  [a ::a b c]
  (* a b c))

(st/instrument [`fun
                `fun-2
                `fun-3])

(t/deftest function-spec
  (t/is (= 6 (fun -1 -2 3)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun 1 2 3))))

(t/deftest catted-function-spec
  (t/is (= 6 (fun-2 3 -2 -1)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-2 1 2 3)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-2 -1 -2 3))))

(t/deftest catted-function-spec-separate
  (t/is (= 6 (fun-3 3 -2 -1)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-3 1 2 3)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-3 -1 -2 3))))
