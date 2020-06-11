(ns clojure-experiment.spec_error
  (:require [clojure.spec :as s]
            [clojure.spec.test :as stest]))
;; I think you can't run alpha12 in lighttables


;; ######### Preciate definitions ###########

(defn length1? [coll] (= (count coll) 1))
(defn length2? [coll] (= (count coll) 2))

(s/def ::length-one length1?)
(s/def ::length-two length2?)



;; ######### User defined functions #########

(defn foo [n]
  (inc n))



;; ######### Function specs #################

(s/fdef clojure-experiment.spec_error/foo
  :args (s/and ::length-one
               (s/cat :check-number number?)))
(stest/instrument 'clojure-experiment.spec_error/foo)

(s/fdef clojure.core/filter
  :args (s/and ::length-two
               (s/cat :check-function ifn? :check-seqable seqable?)))
(stest/instrument 'clojure.core/filter)

(s/fdef clojure.core/odd?
  :args (s/and ::length-one
               (s/cat :check-integer integer?)))
(stest/instrument 'clojure.core/odd?)



;; ######### Experiments ####################

;; 1. The level of nesting doesn't matter - spec errors
;; (foo map)
;; (foo (foo map))
;; (foo (foo (foo (foo map))))
;; (foo (foo (foo (foo (foo (foo (foo (foo map))))))))
;; (odd? (odd? (odd? map)))

;; 2. Combinations of different functions - spec errors
;; (odd? (foo true)) ; spec error
;; (foo (odd? true)) ; spec error
;; (inc (foo (odd? true))) ; spec error
;; (foo (odd? (foo true))) ; spec error

;; 3. Using doall vs not using doall
;; (foo (map foo [1 2 3 true])) ;; standard error
;; (doall (foo (map foo [1 2 3 true]))) ;; standard error
;; (foo (doall (map foo [1 2 3 true]))) ;; spec error
;; (foo (doall (map foo [1 2 3 (range)]))) ;; out of memory
;; (foo (doall (map foo [1 2 3 (take 10 (range))]))) ;; spec error
