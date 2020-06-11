(ns sicp-clj.ch2.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 2-75
; (define (make-from-real-imag x y)
;   (define (dispatch op)
;     (cond ((eq? op 'real-part) x)
;           ((eq? op 'imag-part) y)
;           ((eq? op 'magnitude)
;            (sqrt (+ (square x) (square y))))
;           ((eq? op 'angle) (atan y x))
;           (else
;            (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
;   dispatch)

; (defn make-from-mag-ang [r a]
;     (defn dispatch [op]
;         (cond
;             (= op 'magnitude) r
;             (= op 'angle) a
;             (= op 'real-part) (* r (cos a))
;             (= op 'imag-part) (* r (sin a))
;             :else (prn "Unknown")
;             ))
;     dispatch)
