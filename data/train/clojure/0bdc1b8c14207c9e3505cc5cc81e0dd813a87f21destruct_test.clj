(ns spede.destruct-test
  (:require  [clojure.test :as t]
             [clojure.spec.test :as st]
             [spede.core :as es]
             [clojure.spec :as s])
  (:import clojure.lang.ExceptionInfo))

(s/def ::a integer?)
(s/def ::b integer?)
(s/def ::c integer?)

(es/sdefn destr [{a ::a b ::b c ::c}
                 {a2 ::a b2 ::b c2 ::c}
                 {a3 ::a b3 ::b c3 ::c}]
  (+ a b c))

(st/instrument `destr)

(t/deftest destr-test
  (t/is (= 9 (destr {::a 2 ::b 3 ::c 4} {::a 2 ::b 3 ::c 4} {::a 2 ::b 3 ::c 4}))
        "normal call")
  (t/is (thrown-with-msg? ExceptionInfo #"did not conform to spec"
                          (destr {::a "ugh" ::b 3 ::c 4}
                                 {::a 2 ::b 3 ::c 4}
                                 {::a 2 ::b 3 ::c 4}))
        "map value validity")
  (t/is (thrown-with-msg? ExceptionInfo #"did not conform to spec"
                          (destr {::a 1 ::b 3 ::c 4}
                                 {::a 2 ::c 4}
                                 {::a 2 ::b 3 ::c 4}))
        "map :req"))
