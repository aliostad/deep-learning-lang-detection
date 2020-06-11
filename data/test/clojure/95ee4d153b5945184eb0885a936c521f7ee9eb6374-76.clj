(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-74
; (define zero-crossings
;   (stream-map sign-change-detector sense-data <expression>))
; -> 이건 stream-map은 sense-data와 expr의 car를 취해서, 그 둘 사이에 sign-change가 있었는지 검사해서 그 결과를 내놓는다. last-value가 0이라고 했으니, 0부터 시작하는 sense-data와 비교하면 될 것 같다.

(def zero-crossings
    (stream-map
        sign-change-detector
        sense-data
        (cons-stream 0 sense-data)))

; 3-75
; (define (make-zero-crossings input-stream last-value)
;   (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
;     (cons-stream (sign-change-detector avpt last-value)
;                  (make-zero-crossings (stream-cdr input-stream)
;                                       avpt))))
; -> 이 구현은 avpt를 last-value로 다음 호출에 보내기 때문에 틀렸다. last-avpt를 보내야 한다.

(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream (sign-change-detector avpt last-value)
                 (make-zero-crossings
                    (stream-cdr input-stream)
                    (stream-car input-stream)
                    avpt))))

; 3-76
(defn avrg [x y]
    (/ (+ x y) 2))

(defn smooth [input-stream]
    (stream-map avrg input-stream (cons-stream 0 input-stream)))

; modular하게 만들어보면
(defn zero-crossings [sense-data]
    (let [smoothed (smooth sense-data)]
        (stream-map
            sign-change-detector
            smoothed
            (cons-stream 0 smoothed))))
