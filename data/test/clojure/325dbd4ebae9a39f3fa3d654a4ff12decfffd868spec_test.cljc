(ns datohm.spec-test
  (:require [datohm.conn :as conn]
            [datohm.test-utils :as utils :include-macros true]
            [#?(:clj  clojure.spec
                :cljs cljs.spec)
             :as s]
            [#?(:clj  clojure.spec.gen
                :cljs cljs.spec.impl.gen)
             :as gen]
            [#?(:clj  clojure.spec.test
                :cljs cljs.spec.test)
             :include-macros true
             :as stest]
            [#?(:clj  clojure.test
                :cljs cljs.test)
             :as t
             :include-macros true
             #?(:clj  :refer
                :cljs :refer-macros)
             [deftest testing is]]
            [clojure.test.check :as stc]
            [clojure.test.check.properties]))

(stest/instrument)

#?(:clj
   (do
     (deftest test-spec-gens
       (doall
        (for [k (sort (filter keyword? (utils/specs)))]
          (utils/time-tests k (is (utils/passed? (utils/gen k)))))))))
