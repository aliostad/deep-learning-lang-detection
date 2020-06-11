(ns ^{:author "Adam Berger"} ulvm.blocks-test
  "Blocks tests"
  (:require [clojure.spec.test :as st]
            [ulvm.blocks :as b]
            [ulvm.utils :as utils]
            [cats.core :as m]
            [cats.monad.either :as e])
  (:use     [clojure.test :only [is deftest]]))

(deftest get-unique-deps-test
  (st/instrument (st/instrumentable-syms ['ulvm 'b]))
  (let [deps {"b" #{"a"} "c" #{"a" "b"}}]
    (is
      (= (@#'b/get-unique-deps
           deps
           (utils/flip-map deps) 
           ["b" "a"]
           "c")
         #{"b"}))))

(deftest build-call-graph-test
  (st/instrument (st/instrumentable-syms ['ulvm 'b]))
  (let [g (b/build-call-graph
            nil
            nil
            nil
            {"b" #{"a"} "c" #{"b" "a"}}
            {}
            ["a" "b" "c"])]
    (is (e/right? g))
    (m/fmap #(is (= %
                    '(let ["a" "invoke-a"]
                       (let ["b" "invoke-b"]
                         (let ["c" "invoke-c"]
                           (do ())))))))))
