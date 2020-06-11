(ns section-3-5-3.stream-math-test
  (:require [clojure.test :refer :all]
            [section-3-5-3.stream-math :refer :all]
            [section-3-5-3.streams :refer :all]))

(deftest a-test
  (testing "FIXME, I fail."
    (is (= '(1 1) (stream-ref int-pairs 0)))
    (is (= '(1 2) (stream-ref int-pairs 1)))
    (is (= '(2 2) (stream-ref int-pairs 2)))
    (is (= '(1 3) (stream-ref int-pairs 3)))
    ))

;; need plan to fix this:
;; DONE-1) break components into correct namespaces
;; DONE-2) come up with list of things that int-pairs uses
;;    pairs
;;      cons-stream
;;      stream-car
;;      stream-cdr
;;      stream-interleave <-- probably the problem
;;      stream-map
;;    integers
;;      integers-starting-from
;; DONE-3) come up with unit tests for each until I have problem fixed
;; 4) Come up with emacs workflow that works with all of this
;;    DONE-1) Get everything checked in
;;    DONE-2) Merge README on BTG-Mac-Mini-1
;;    3) Move to CIDER
;;    4) Move to reloaded


;; (stream-ref int-pairs 3) ; XXX this blows up


(def sqrt-2 (sqrt-stream 2))

; (stream-ref sqrt-2 0)
; (stream-ref sqrt-2 1)
; (stream-ref sqrt-2 2)
; (stream-ref sqrt-2 3)
; (stream-ref sqrt-2 4)
; (stream-ref sqrt-2 5)

  ; (pairs s t)

;; all integers i,j with i<=j such that i+j is prime
(stream-filter #(prime? (+ (first %) (second %)))
               int-pairs)

(stream-take 40 int-pairs)
(stream-ref int-pairs 0)
(stream-ref int-pairs 1)
(stream-ref int-pairs 2)
(stream-ref int-pairs 3)
(stream-ref int-pairs 4)
(stream-ref int-pairs 5)
(stream-ref int-pairs 6)
(stream-ref int-pairs 7)
(stream-ref int-pairs 8)
(stream-ref int-pairs 9)
(stream-ref int-pairs 10)


(stream-ref int-pairs 50)
(stream-ref int-pairs 100)
(stream-ref int-pairs 150)
(stream-ref int-pairs 200)
(stream-ref int-pairs 224)
; (stream-ref int-pairs 2) ; XXX this blows up

;; exercise 3.66

;; not too many preceed 1,100, but a whole lot preceed 99,100, and even more 100,100..

;; exercise 3.67

;; 1,1 <- #1  1,2 1,3 <- #2

;; 2,1   2,2 2,3 <- #4
;; 3,1   3,2 3,3
;;  ^#3

(def all-int-pairs (all-pairs integers integers))

(stream-take 40 all-int-pairs)

(deftest b-test
  (testing "FIXME, I fail."
    (is (= '(1 1) (stream-car (all-pairs integers integers))))))

;; ex 3.68

;; lack of delay causes to infinitely recurse

;; ex 3.69


