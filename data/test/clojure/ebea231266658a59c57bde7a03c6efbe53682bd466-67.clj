(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-66
; 먼저 (1 n) 쌍 앞에 몇 개 있는지 보면
; (1 1) (1 2) (2 2) (1 3) (2 3) (1 4) (3 3) (1 5) (2 4) (1 6) 이런 식이다.
; 즉 (1 n)은 2(n-1)번째에 있으니, (1 n) 앞에는 2(n-1) - 1 = 2n-3개가 있다.
; 따라서 (1 100) 앞에는 197개가 있다.

; 이제 위 스트림에서 1로 시작하는 것들을 빼놓고 보면
; (2 2) (2 3) (3 3) (2 4) (3 4) (2 5) (4 4) (2 6) 이런 식이다.
; 결국 (1 n)과 패턴이 같으므로 이 스트림에서 (2 m)은 2(m-1)번째에 있다.
; 그런데 1과 하나씩 interleave되므로 여기에 2를 곱한 자리에 있을 것이다.
; 즉 (2 m)앞에 있는 것은 2 * (2(m-1)-1).

; 같은 원리로 (x n)는 2^(x-1) * (2(n-1)-1) 개의 precedings를 가지고 있다.
; 그러므로 (99 100) 앞에는 2^98 * 197, (100 100) 앞에는 2^99 * 197개가 있다.

; 3-67
; 근데 사실 현재 pairs 정의대로라도 모든 정수의 쌍이 무조건 다 나오도록 보장되어있는 것 아닌가? 문제 의미를 정확히 모르겠다.
; 아무튼, (1 1) (1 2) (2 1) 과 같이 나오게 하라는 의미라고 생각하면, 기존의 interleave 안에 있는 stream-mape을 거꾸로 해서 다시 interleave하게 하면 대충 될 거 같다.
; 아니면 interleave-btw-three 를 만들어서 세 개를 규칙적으로 섞어주는 걸로도 만들 수 있을 것 같은데, 문제의 의미를 정확히 모르니 그냥 첫번쨰 걸로 한다.

; 원본
(define (pairs s t)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (interleave
            (stream-map (lambda (x) (list (stream-car s) x))(stream-cdr t))
            (pairs (stream-cdr s) (stream-cdr t)))))

; 고치기
(define (pairs s t)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (interleave
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (interleave
                (stream-map (lambda (x) (list x (stream-car t))) (stream-cdr s))
                (pairs (stream-cdr s) (stream-cdr t))))))
