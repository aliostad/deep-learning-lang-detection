(ns section-3-5-3.core
  (:require
   [section-3-5-3.streams :refer :all]
   [section-3-5-3.stream-math :as sm]
   [section-3-5-3.letrec :as lr]
   ))

; (display-stream (sqrt-stream 2))

;; pi/4 = 1 - 1/3 + 1/5 - 1/7 + ...

;; summands are the recipricols of the odd integers, with alternating signs


;; each value is pi to more and more precision.



; (display-stream (euler-transform pi-stream))


; (display-stream (accelerated-sequence euler-transform pi-stream))

;; ex 3.63 - alyssa is right.  yes, this relies on memo-proc working.

;; [done to here]

;; ex 3.64

;; see stream-limit and (sqrt)

;; (sm/sqrt 2 0.00000000000001)

;; ex 3.65

;; ln 2 = 1 - 1/2 + 1/3 - 1/4 + ...


; (display-stream (ln-2-summands 1))
; (display-stream ln-2-stream)

;; does not converge rapidly...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Infinite streams of pairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; int-pairs - all integers (i, j) where i<= j
;;
;; s and t are the infinite series that i and j are pulled from....

;; see sm/prime-sum-pairs-stream

;; convenience for repl

; (stream-take 5 sm/prime-sum-pairs-stream)
; (finite 5 sm/prime-sum-pairs-stream)
; (finite 5 sm/int-pairs)

; (finite 200 (sm/pairs-on-or-above-diagonal sm/integers sm/integers))

;; (stream->seq (stream-take 5 sm/prime-sum-pairs-stream))

;;
;; composed of three parts:
;; 1) s0, t0
;; 2) rest of the pairs in the first rows
;; 3) pair(stream-cdr s, stream-cdr t)

;; first piece is:

; (stream-car s) (stream-car t) ;; #1

;; second piece is:
; (stream-map #(list (stream-car s) %)
;             (stream-cdr t))

  
;; Exercise 3.66

;; first element grows very slowly
;; about 200 preceed 1,100


;; (stream-find-index-of '(1 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=> 197

;; (stream-find-index-of '(2 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=> 392

;; (stream-find-index-of '(3 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=> 778

;; (stream-find-index-of '(4 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=> 1542

;; (stream-find-index-of '(n 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=>200^n

; (stream-find-index-of '(99 100) (sm/pairs-on-or-above-diagonal sm/integers sm/integers))
;;=>200^100

;; Exercise 3.67

;; see (finite 50 (sm/all-pairs sm/integers sm/integers))

;; Exercise 3.68

(defn probably-bad-pairs [s t]
  (stream-interleave
   (stream-map #(list (stream-car s) %) t)
   (probably-bad-pairs (stream-cdr s) (stream-cdr t))))

;; there's no base case to the recursion - it recurses forever.
;; 
;; (finite 50 (probably-bad-pairs sm/integers sm/integers))
;;;=> StackOverflow

;; Exercise 3.69

;; see (three-d-pairs-on-or-above-diagonal)


;; x^2 + y^2 = z^2
; (finite 10 sm/int-triples)
                                        ; (finite 2 sm/pythagorean-triples)
;; Exercise 3.70

;; see stream-merge-weighted

;; a:

(def positive-ints-by-sum
  (sm/pairs-on-or-above-diagonal sm/int-pairs
                                 sm/int-pairs
                                 (fn [s1 s2]
                                   (stream-merge-weighted s1 s2 #(+ (first %) (second %))))))

(defn divisible-by [n divisor]
  (= 0
     (mod n divisor)))

(defn not-divisible-by-2-3-or-5 [n]
  (not (or (divisible-by n 2)
            (divisible-by n 3)
            (divisible-by n 5))))

(def ints-but-not-divisible-by-2-3-or-5
  (stream-filter not-divisible-by-2-3-or-5 sm/integers))

(def weird
  (sm/pairs-on-or-above-diagonal ints-but-not-divisible-by-2-3-or-5
                                 ints-but-not-divisible-by-2-3-or-5
                                 (fn [s1 s2]
                                   (stream-merge-weighted s1 s2 #(+ (* 2 (first %))
                                                                    (* 3 (second %))
                                                                    (* 5 (* (first %)
                                                                            (second %))))))))

(finite 3 weird)

;; Exercise 3.71

(defn weight-by-sum-of-cubes [[a b]]
  (+ (* a a a)
     (* b b b)))

(def int-pairs-weighted-by-sum-of-cubes
  (sm/pairs-on-or-above-diagonal sm/integers
                                 sm/integers
                                 #(stream-merge-weighted %1 %2 weight-by-sum-of-cubes)))

(defn is-ramanujan-pair? [a b]
  (let [sum1 (weight-by-sum-of-cubes a)
        sum2 (weight-by-sum-of-cubes b)
        ret (= sum1 sum2)]
;    (println "is-ramanujan-pair? [" a "=" sum1 " " b "=" sum2 "] = " ret)
    ret))

(defn pretty-print-weight-by-sum-of-cubes [a]
  (print-str a "=" (weight-by-sum-of-cubes a)))

(map pretty-print-weight-by-sum-of-cubes (finite 480 int-pairs-weighted-by-sum-of-cubes))

;; 1729 = (1 12) and (9 10)

;; (1 1) = 2" "(1 2) = 9" "(2 2) = 16" "(1 3) = 28" "(2 3) = 35" "(3 3) = 54" "(1 4) = 65" "(2 4) = 72" "(3 4) = 91" "(1 5) = 126" "(4 4) = 128" "(2 5) = 133" "(3 5) = 152" "(4 5) = 189" "(1 6) = 217" "(2 6) = 224" "(3 6) = 243" "(5 5) = 250" "(4 6) = 280" "(5 6) = 341"

; (def ramanujan-numbers
;  (stream-filter-pairs is-ramanujan-pair? int-pairs-weighted-by-sum-of-cubes))

; (map #(weight-by-sum-of-cubes (first %))
;      (finite 6 ramanujan-numbers))
                                        ;= => (1729 4104 13832 20683 32832 39312)

;; Exercise 3.72

(defn weight-by-sum-of-squares [[a b]]
  (+ (* a a)
     (* b b)))

(def int-pairs-weighted-by-sum-of-squares
  (sm/pairs-on-or-above-diagonal sm/integers
                                 sm/integers
                                 #(stream-merge-weighted %1 %2 weight-by-sum-of-squares)))

(defn is-sum-of-squares-three-ways? [a b c]
  (let [sum1 (weight-by-sum-of-squares a)
        sum2 (weight-by-sum-of-squares b)
        sum3 (weight-by-sum-of-squares c)
        ret (= sum1 sum2 sum3)]
;    (println "is-sum-of-squares-three-ways? [" a "=" sum1 " " b "=" sum2 "] = " ret)
    ret))

(def sum-of-squares-three-ways-numbers
  (stream-filter-triplets
   is-sum-of-squares-three-ways?
   int-pairs-weighted-by-sum-of-squares))


(map #(weight-by-sum-of-squares (first %))
     (finite 6 sum-of-squares-three-ways-numbers))
; => (50 65 85 125 130 145)


(defn pretty-print-weight-by-sum-of-squares [a]
  (print-str a "=" (weight-by-sum-of-squares a)))

(map pretty-print-weight-by-sum-of-squares (finite 10 int-pairs-weighted-by-sum-of-squares))
;;=> ("(1 1) = 2" "(1 2) = 5" "(2 2) = 8" "(1 3) = 10" "(2 3) = 13" "(1 4) = 17" "(3 3) = 18" "(2 4) = 20" "(3 4) = 25" "(1 5) = 26")

(defn pretty-print-triplets [[a b c]]
  (print-str (pretty-print-weight-by-sum-of-squares a)
             (pretty-print-weight-by-sum-of-squares b)
             (pretty-print-weight-by-sum-of-squares c)))

(first (finite 10 sum-of-squares-three-ways-numbers))

(map pretty-print-triplets
     (finite 10 sum-of-squares-three-ways-numbers))

;; => ("(1 18) = 325 (6 17) = 325 (10 15) = 325" "(5 20) = 425 (8 19)
;; = 425 (13 16) = 425" "(5 25) = 650 (11 23) = 650 (17 19) = 650" "(7
;; 26) = 725 (10 25) = 725 (14 23) = 725" "(2 29) = 845 (13 26) =
;; 845 (19 22) = 845" "(3 29) = 850 (11 27) = 850 (15 25) = 850" "(5
;; 30) = 925 (14 27) = 925 (21 22) = 925" "(1 32) = 1025 (8 31) =
;; 1025 (20 25) = 1025" "(4 33) = 1105 (9 32) = 1105 (12 31) =
;; 1105" "(9 32) = 1105 (12 31) = 1105 (23 24) = 1105")


;; Streams as signals

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; integrator == summer == this:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; S_i = sum of values of stream
;; C = initial value
;; S_i = C + Sum_j=1_to_i x_j*dt

(defn integral [integrand initial-value dt]
  "Sum across a series, assuming that each entry in 'integrand'
  represents a time period increased by 't' from the time before.
  Returns a stream of the sum of the initial stream, where each
  entry represents the next sum after a time delta of 'dt'"
  (lr/letrec [inte (cons-stream initial-value
                                (add-streams (scale-stream integrand dt)
                                             inte))]
    inte))

(finite 10 (integral sm/integers 0 1))
;;=> (0 1 3 6 10 15 21 28 36 45)
;;    + + + +
;;    0 0 0 0
;;      1 1 1
;;        2 2
;;          3

(finite 10 (integral sm/integers 0 0.5))
;; => (0 0.5 1.5 3.0 5.0 7.5 10.5 14.0 18.0 22.5)

;; Exercise 3.73

;; RC circuit
;;
;; v = voltage response of the circuit
;; i = injected current
;;
;; v = v_0 + (1/C) * (Sum_0..t i*dt) + R*i

(defn rc [r c dt]
  "Given numbers r, c and dt, return a function that takes in a stream
   of current i at the point in time and an initial value for the
   capaciter voltage (v0).  This function returns the value of the
   stream of voltages out the back."
  (fn [i v0]
    (add-streams (scale-stream (integral i v0 dt) (/ 1 c))
                 (scale-stream i r))))


(def example-rc-circuit (rc 5 1 0.5))

;; Exercise 3.74

;; (defn make-zero-crossings [input-stream last-value]
;;  (cons-stream
;;   (sign-change-detector (stream-car input-stream) last-value)
;;   (make-zero-crossings (stream-cdr input-stream)
;;                        (stream-car input-stream))))

;; (def zero-crossings-1 (make-zero-crossings sense-data 0))

;; (def zero-crossings-2 (stream-map sign-change-detector sense-data (stream-cdr sense-data)))

;; Exercise 3.75

;; (defn make-zero-crossings-2 [input-stream last-value]
;;  (let [avpt (/ (+ (stream-car input-stream) last-value)
;;                2)]
;;    (cons-stream (sign-change-detector avpt last-value)
;;                 (make-zero-crossings (stream-cdr input-stream)
;;                                      avpt))))


;; (defn make-zero-crossings-3 [input-stream last-value last-avpt]
;;  (let [value (stream-car input-stream)
;;        avpt (/ (+ value last-value) 2)]
;;    (cons-stream (sign-change-detector avpt last-avpt)
;;                 (make-zero-crossings (stream-cdr input-stream)
;;                                      value
;;                                      avpt))))
;; Exercise 3.76

;; (defn average [a b]
;;  (/ (+ a b) 2))

;; to deal with the first value, you could either add it as the first eleement, or not.
;; (defn smooth [input-stream]
;;   (stream-map average input-stream (stream-cons 0 input-stream)))

;; (make-zero-crossings (smooth input-stream) 0)

;; Section 3.5.4
