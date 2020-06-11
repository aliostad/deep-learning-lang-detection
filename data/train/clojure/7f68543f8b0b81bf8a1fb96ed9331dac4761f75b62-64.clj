(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-62
; mul과 invert를 활용해야 한다.
; invert는 constant term이 1인 시리즈의 inverse를 구한다.
; 그러니 denominator를 normalize한 다음, invert하고, numerator와 mul-series한다.
; 아, 그리고 마지막에 normalize했던 것을 복구한다.
; normalize한 걸 invert해서 곱했으니까, 복구할 때는 한번 더 normalize하듯 하면 될 것 같다.
; 테스트는 어떻게 할지 모르겠군.
(defn div-series [numer-series denom-series]
    (let [denom (stream-car denom-series)]
        (if (zero? denom)
            (prn "Zero denominator")
            (scale-stream
                (mul-series
                    numer-series
                    (invert-unit-series (scale-stream denom-series (/ 1 denom))))
                (/ 1 denom)))))

; 3-63
; 원래 버전
(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

; 문제
(define (sqrt-stream x)
  (cons-stream 1.0
               (stream-map (lambda (guess)
                             (sqrt-improve guess x))
                           (sqrt-stream x))))

; 비교하면, 원래 버전은 guesses라는 로컬 변수를 쓰고 새 버전은 안 쓴다. 대신 sqrt-stream을 recursive하게 부른다.
; 그러면 뒤의 버전은 sqrt-stream을 계속 계산해야 하고, 원래 버전은 guesses를 한 번만 계산하면 되니까 효율 차이가 날 것이다.
; 그러나 memo를 안 쓰면 당연히 둘이 별로 다를 바가 없다.

; 3-64
; "two successive elements that differ in absolute value by less than the tolerance"
(defn stream-limit [st tol]
  (let [st2 (stream-cdr s)]
    (if (< (abs (- (stream-car st) (stream-car st2))) tol)
        (stream-car st2)
        (stream-limit st2 tol))))
