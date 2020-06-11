(ns sicp-ch3.paragraphs.3-52
  (:require [sicp-ch3.paragraphs.3-51 :refer :all]))


(defn integers-starting-from [n]
        (cons-stream n (integers-starting-from (inc n))))


(defn divisible? [x y]
 (= (rem x y) 0))

(def integers (integers-starting-from 1))

(defn no-sevens []
          (filter #(not (divisible? % 7)) integers))

;(println (take 10 (no-sevens))) => (1 2 3 4 5 6 8 9 10 11)

;scheme code
;(define (fibgen a b) (cons-stream a (fibgen b (+ a b))))
;(define fibs (fibgen 0 1))

(defn fib [a b]
  (cons a (lazy-seq (fib b (+ a b)))))

;(take 10 (fib 0 1)) => 0 1 1

;scheme code
;(define (sieve stream)
;        (cons-stream
;          (stream-car stream)
;          (sieve (stream-filter
;                   (lambda (x)
;                           (not (divisible? x (stream-car stream))))
;                   (stream-cdr stream)))))
;(define primes (sieve (integers-starting-from 2)))

;; Algorithm of Eratosthenes Sieve.

;; cons-stream -> cons then later lazy-seq
;; stream-car -> first
;; stream-cdr -> rest
;;

(defn sieve [stream]
  (cons (first stream)
        (lazy-seq (sieve (filter #(not (divisible? % (first stream)))
                                 (rest stream))))))

;; Infinite stream of prime numbers.

;(def primes (sieve (integers-starting-from 2)))
;
;(println (take 10 primes)) => (2 3 5 7 11 13 17 19 23 29)


