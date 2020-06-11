(ns clojure-spec-example.spec_errors
  (:require [clojure.spec :as s]
            [clojure.spec.test :as stest]))



;; #########################################
;; #     helper functions/predicates       #
;; #########################################

(defn length1? [coll] (= (count coll) 1))
(defn length2? [coll] (= (count coll) 2))
(defn length3? [coll] (= (count coll) 3))

(s/def ::length-one length1?)
(s/def ::length-two length2?)
(s/def ::length-three length3?)



;; ##########################################
;; #    spec definitions and instruments    #
;; ##########################################

;; One possible spec for the core odd? function
(s/fdef clojure.core/odd?
  :args (s/cat :check-integer integer?))

;; Another possible spec for the core odd? function to check the arity first
;; (s/fdef clojure.core/odd?
;;   :args (s/and ::length-one
;;                (s/cat :check-integer integer?)))

(stest/instrument 'clojure.core/odd?)

;; One possible spec for the core reduce function
(s/fdef clojure.core/reduce
  :args (s/cat :check-function ifn? :dummy (s/? any?) :check-seqable seqable?))

;; Another possible spec for the core reduce function to check the arity first
;; (s/fdef clojure.core/reduce
;;   :args (s/or :two-case (s/and ::length-two
;;                                (s/cat :check-function ifn? :check-seqable seqable?))
;;               :three-case (s/and ::length-three
;;                                  (s/cat :check-function ifn? :dummy any? :check-seqable seqable?))))

(stest/instrument 'clojure.core/reduce)



;; ##########################################
;; #              use of spec               #
;; ##########################################

;; 1. wrong number of arguments error

;; (odd? )                ;; fails with `:reason "Insufficient input"` with the first spec definition
;; (odd? 1 2)             ;; fails with `:reason "Extra input"` with the first spec definition
;; (odd? false 1)         ;; integer? condition fails with the first spec definition

;; (reduce )              ;; fails with `:reason "Insufficient input"` with the first spec definition
;; (reduce + 3 [1 2 3] 1) ;; fails with `:reason "Extra input"` with the first spec definition
;; (reduce 5 + [1 2 3] 7) ;; ifn? condition fails with the first spec definition


;; 2. argument type error

;; (odd? false)
;; (odd? nil)

;; (reduce true 3 [1 2 3])
;; (reduce + true)
