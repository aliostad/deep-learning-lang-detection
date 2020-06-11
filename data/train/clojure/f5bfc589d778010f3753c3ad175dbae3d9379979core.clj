(ns akl-clj-spec.core
  (:require [clojure.test :refer [deftest is]]
            [clojure.spec :as s]
            [clojure.spec.test :as st]
            [clojure.string :as str]
            [clojure.core.async :as a]
            [clojure.core.async.impl.protocols :as ap])
  (:import (clojure.lang ExceptionInfo)))

;Don't actually replace this. It's so you can find the things you do need to replace.
(def !!!replace-me!!! (constantly false))

;; ====
;; 1
;; ====

(deftest pick-and-mix
  (is (s/valid? int? !!!replace-me!!!))
  (is (s/valid? string? !!!replace-me!!!))
  (is (s/valid? keyword? !!!replace-me!!!))
  (is (s/valid? fn? nil))
  (is (s/valid? seq? !!!replace-me!!!))
  (is (s/valid? (s/coll-of int?) !!!replace-me!!!))
  (is (s/valid? associative? !!!replace-me!!!))
  (is (s/valid? (s/nilable keyword?) !!!replace-me!!!))
  (is (s/valid? #{:zombies/ninja-zombies "lasers" :robots 42} !!!replace-me!!!)))
;There's lots of other stuff you can use, and even make your own with defn.

;; ====
;; 2
;; ====

;Try simple function, from core... probably one ending with a question mark.
(deftest numbery-thing
  (is (s/valid? !!!replace-me!!! 1)))

;; =====
;; 3
;; =====

(deftest conform-kws
  (let [spec !!!replace-me!!!]
    (is (not= ::s/invalid (s/conform spec :dog)))
    (is (= :cat (s/conform spec :cat)))))

;; =====
;; 4
;; =====

(s/def ::dog-breed !!!replace-me!!!)

(deftest dog-breeds
  (is (s/valid? ::dog-breed :corgi))
  (is (s/valid? ::dog-breed :german-shepard))
  (is (not (s/valid? ::dog-breed :doge)))
  (is (s/valid? ::dog-breed :shiba-inu)))

;; =====
;; 5
;; =====

(s/def ::dog (s/keys :req [::dog-breed]))

(deftest dog-test
  (is (s/valid? ::dog !!!replace-me!!!)))

;; =====
;; 6
;; =====

;You'll have to s/def some more things for this.
(s/def ::person (s/keys :req [!!!replace-me!!!]))

(deftest person-test
  (is (s/valid? ::person {::first-name "Jane"
                          ::last-name "Doe"
                          ::id 123
                          ::country-code :NZ
                          ::dog {::name "Steve"
                                 ::dog-breed :german-shepard}}))
  (is (not (s/valid? ::person {}))))

;; =====
;; 8
;; =====

(s/def ::dog-breed-ratings (s/map-of ::dog-breed !!!replace-me!!!))

(deftest dog-rating-test
  (is (s/valid? ::dog-breed-ratings {:german-shepard 10
                                     :corgi 0}))
  (is (not (s/valid? ::dog-breed-ratings {:tabby "0"
                                          :tortise-shell 7}))))

;; =====
;; 9
;; =====

(defn foo [x]
  (inc x))

(s/fdef foo
  :args (s/cat :x !!!replace-me!!!))

(deftest foo-spec
  (st/instrument ['akl-clj-spec.core/foo])                  ;Normally you'd just do instrument.
  (is (= 2 (foo 1)))
  (is (thrown? ExceptionInfo (foo "hello!")))
  (st/unstrument ['akl-clj-spec.core/foo]))

;; =====
;; 10
;; =====

(defn bar [x]
  (str/trim x))

(s/fdef bar
  :args (s/cat :x !!!replace-me!!!)
  :ret !!!replace-me!!!)

(deftest bar-spec
  (st/instrument ['akl-clj-spec.core/bar])
  (is (= "abc" (bar "  abc    ")))
  (is (thrown? ExceptionInfo (bar 123)))
  (st/unstrument ['akl-clj-spec.core/bar]))

;; =====
;; 11
;; =====

(defn baz [x]
  (name x))

(s/fdef baz
  :args (s/cat :x !!!replace-me!!!)
  :ret !!!replace-me!!!
  :fn !!!replace-me!!!)                                     ;Look at the docs or use a prn to check what the args to this are

(deftest baz-spec
  (st/instrument ['akl-clj-spec.core/baz])
  (is (= "abc" (baz :abc)))
  (is (thrown? ExceptionInfo (baz 123)))
  (is (-> (st/check ['akl-clj-spec.core/baz])
          (first)
          :clojure.spec.test.check/ret
          :result
          (true?)))
  (st/unstrument ['akl-clj-spec.core/baz]))

;; =====
;; 12
;; =====

;; This one's harder, and needs a macro and knowledge of protocols.
;; Ask for hints if you want.
(defmacro chan-of [spec & chan-args]
  ;TODO: alter this so it throws an exception if you don't pass a thing that conforms to `spec`
  `(a/chan ~@chan-args))

(deftest chan-of-test
  (let [ch (chan-of int?)]
    (a/put! ch 1)
    (is (= 1
           (a/poll! ch)))
    (is (thrown? Exception (a/put! ch "fez")))))
