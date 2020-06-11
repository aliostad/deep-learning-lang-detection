(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-69
(defn triples [s t u]
  	(cons-stream
   		(list (stream-car s) (stream-car t) (stream-car u))
   		(interleave
    		(stream-map (fn [x] (cons (stream-car s) x)) (pairs t (stream-cdr u)))
    		(triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

; 3-70
; 참고: merge
; (define (merge s1 s2)
;   (cond ((stream-null? s1) s2)
;         ((stream-null? s2) s1)
;         (else
;          (let ((s1car (stream-car s1))
;                (s2car (stream-car s2)))
;            (cond ((< s1car s2car)
;                   (cons-stream s1car (merge (stream-cdr s1) s2)))
;                  ((> s1car s2car)
;                   (cons-stream s2car (merge s1 (stream-cdr s2))))
;                  (else
;                   (cons-stream s1car
;                                (merge (stream-cdr s1)
;                                       (stream-cdr s2)))))))))

; (define (pairs s t)
;   (cons-stream
;    (list (stream-car s) (stream-car t))
;    (interleave
;     (stream-map (lambda (x) (list (stream-car s) x))
;                 (stream-cdr t))
;     (pairs (stream-cdr s) (stream-cdr t)))))

(defn merge-weighted [s1 s2 weight]
	(cond
		(stream-null? s1) s2
		(stream-null? s2) s1
		:else
			(let [s1car (stream-car s1) s2car (stream-car s2)]
				(if (<= (weight s1car) (weight s2car))
					(cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight))
				    (cons-stream s2car (merge-weighted s1 (stream-cdr s2 weight)))
					))))

(defn weighted-pairs [s t weight]
	(cons-stream
		(list (stream-car s) (stream-car t))
		(merge-weighted
			(stream-map (fn [x] (list (stream-car s) x)) (stream-cdr t))
			(weighted-pairs (stream-cdr s) (stream-cdr t) weight)
			weight)))

; a
(defn weight-a [pair]
  (+ (first pair) (second pair)))

(weighted-pairs integers integers weight-a)

; b
(defn weight-b [pair]
  (+ (* 2 (first pair)) (* 3 (second pair))
     (* 5 (first pair) (second pair))))

(def not-divided-ints
  (stream-filter
    (fn [x]
        (not
            (or
                (even? x)
                (zero? (remainder x 3))
                (zero? (remainder x 5))
            ))
    )))

(weighted-pairs not-divided-ints not-divided-ints weight-b)
