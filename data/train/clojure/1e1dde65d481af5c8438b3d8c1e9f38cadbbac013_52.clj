;; Exercise 3.52
;; Consider the sequence of expressions
;;
;; (define sum 0)
;;
;; (define (accum x)
;;   (set! sum (+ x sum))
;;   sum)
;;
;; (define seq (stream-map accum (stream-enumerate-interval 1 20)))
;; (define y (stream-filter even? seq))
;; (define z (stream-filter (lambda (x) (= (remainder x 5) 0)) seq))
;;
;; (stream-ref y 7)
;; (display-stream z)
;;
;; What is the value of sum after each of the above expressions is evaluated?
;; What is the printed response to evaluating the stream-ref and display-stream
;; expressions?  Would these responses differ if we had implemented (delay
;; <exp>) simply as (lambda () <exp>) without using the optimization provided by
;; memo-proc?  Explain.

(ns sicp-mailonline.exercises.3-52
  (:require [sicp-mailonline.examples.3-5-1 :refer :all]))

(def sum (atom 0))
;; -> @sum=0

(defn accum [x]
  (swap! sum + x))
;; -> @sum=0

(def seq (stream-map accum (stream-enumerate-interval 1 20)))
;; -> @sum=1

(def y (stream-filter even? seq))
;; -> @sum=6

(def z (stream-filter (fn [x] (zero? (rem x 5))) seq))
;; -> @sum=10

(stream-ref y 7)
;; -> @sum=136
;; -> 136

(display-stream z)
;; -> @sum=210
;; -> 10
;;    15
;;    45
;;    55
;;   105
;;   120
;;   190
;;   210

;; The responses would differ if the implementation of delay did not memoize the
;; result.  For example, the definition of y adds 5 to sum.  Without
;; memoization, the definition of z results in re-evaluation of the stream
;; values, with the outcome that sum would be 15 without memoization as
;; opposed to 10 with.
