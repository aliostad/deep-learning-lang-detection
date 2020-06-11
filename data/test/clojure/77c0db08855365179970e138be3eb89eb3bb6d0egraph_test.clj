(ns rp.json.graph-test
  (:refer-clojure :exclude [ref])
  (:require [clojure.test :refer :all]
            [clojure.spec.alpha :as spec]
            [clojure.spec.test.alpha :as spec-test]
            [rp.json.graph :refer :all]))

(spec/fdef rp.json.graph/ref
           :args (spec/cat :value any?)
           :ret (fn []))
(spec-test/instrument 'rp.json.graph/ref)

(deftest test-ref
  (is (= {:$type :ref
          :value 42}
         (ref 42)))
  (is (= {:$type :ref
          :value nil}
         (ref nil))))
