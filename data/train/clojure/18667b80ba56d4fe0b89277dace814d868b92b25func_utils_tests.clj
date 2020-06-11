(ns ^{:author "Adam Berger"} ulvm.func-utils-tests
  "Spec tests for ulvm.func-utils"
  (:require [clojure.spec.test :as st]
            [cats.monad.either :as e]
            [ulvm.func-utils :as futil])
  (:use     [clojure.test :only [is deftest]]))

(deftest mlet-mixed
  (st/instrument (st/instrumentable-syms 'futil))
  (is (= 16 (futil/mlet e/context
                        [a 4
                         b (e/right (+ a 5))]
                        (+ b 7)))))

(deftest mlet-destructured
  (st/instrument (st/instrumentable-syms 'futil))
  (is (= 20 (futil/mlet e/context
                        [{a :a b :b} (e/right {:a 4 :b 6})
                         {c :c d :d} {:c 7 :d 3}
                         res (+ a b c d)]
                        res))))

(deftest mlet-fallthrough
  (st/instrument (st/instrumentable-syms 'futil))
  (is (e/left? (futil/mlet e/context
                           [a 4
                            b (e/left 5)
                            c (e/right (+ a 5))]
                           (+ c 7)))))

(deftest get-in-either
  (st/instrument (st/instrumentable-syms 'futil))
  (let [m {:a (e/right {{:b 7} (e/right {:c :right})})}]
    (is (= (e/right :right)
           (futil/get-in-either m [:a {:b 7} :c] nil)))
    (is (= (e/right {:c :right})
           (futil/get-in-either m [:a {:b 7}] nil)))))
