(ns section-3-5-2.core)

(defn- already-run? [state]
  (first state))

(defn- result-of-last-run [state]
  (second state))

(defn memo-proc [proc]
  (let [state-atom (atom [false nil])]
    (fn []
      (let [state @state-atom
            already-run (already-run? state)
            result (result-of-last-run state)]
        (if (not already-run)
          (do (reset! state-atom [true (proc)])
              (result-of-last-run @state-atom))
          result)))))

(defmacro my-delay [a]
  `(memo-proc 
    (fn []
      ~a)))

(defmacro cons-stream [a b]
  `(list ~a (my-delay ~b)))

(defn integers-starting-from [n]
  (cons-stream n (integers-starting-from (inc n))))

(def integers (integers-starting-from 1))

(defn remainder [a b]
  (rem a b))

(defn divisible? [x y]
  (= (remainder x y) 0))

(defn stream-null? [s]
  (empty? s))

(def the-empty-stream '())

(defn stream-car [stream]
  (first stream))

(defn force [delayed-object]
  (delayed-object))

(defn stream-cdr [stream]
  (if (empty? (rest stream))
    '()
    (force (first (rest stream)))))

(defn stream-filter [pred stream]
  (cond (stream-null? stream) the-empty-stream
        (pred (stream-car stream)) (cons-stream (stream-car stream)
                                                (stream-filter pred (stream-cdr stream)))
        :else (stream-filter pred (stream-cdr stream))))

(def no-sevens
  (stream-filter #(not (divisible? % 7)) 
                 integers))

(defn stream-ref [s n]
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (dec n))))

(stream-cdr no-sevens) ;= should evaluate to another list, but fails

(stream-ref no-sevens 100)

(defn fibgen [a b]
  (cons-stream a (fibgen b (+ a b))))

(def fibs (fibgen 0 1))

(defn sieve [stream]
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           #(not (divisible? % (stream-car stream)))
           (stream-cdr stream)))))

(def primes (sieve (integers-starting-from 2)))

(stream-ref primes 50)

(def ones (cons-stream 1 ones))

(defn stream-map [proc & argstreams]
  (if (empty? (first argstreams))
    the-empty-stream
    (cons-stream
     (apply proc (map stream-car argstreams))
     (apply stream-map (cons proc (map stream-cdr argstreams))))))

(defn add-streams [s1 s2]
  (stream-map + s1 s2))

(def integers (cons-stream 1 (add-streams ones integers)))

(def fibs
  (cons-stream 0
               (cons-stream 1
                           (add-streams (stream-cdr fibs)
                                        fibs))))

(defn scale-stream [stream factor]
  (stream-map #(* % factor)
              stream))

(def double (cons-stream 1 (scale-stream double 2)))

(defn square [n] (* n n))

(defn prime? [n]
  (loop [ps primes]
    (cond (> (square (stream-car ps)) n) true
          (divisible? n (stream-car ps)) false
          :else (recur (stream-cdr ps)))))

(def primes
  (cons-stream
   2
   (stream-filter prime? (integers-starting-from 3))))

;; ex 3.53

; 1 -> 2 -> 4 -> 8 -> 16 -> ...

;; ex 3.54

(defn mul-streams [s1 s2]
  (stream-map * s1 s2))

(def factorials
  "stream those nth element is n+1 factorial"
  (cons-stream 1
               (mul-streams factorials integers)))

(stream-ref factorials 5)

(defn partial-sums [s]
  (cons-stream (stream-car s)
               (add-streams (stream-cdr s)
                            (partial-sums s))))

(def int-partial-sums (partial-sums integers))
(stream-ref int-partial-sums 0) ;= 1
(stream-ref int-partial-sums 1) ;= 3
(stream-ref int-partial-sums 2) ;= 6
(stream-ref int-partial-sums 3) ;= 10
(stream-ref int-partial-sums 4) ;= 15

;; ex 3.56

;; all positive integers with no prime factors other than 2, 3, or 5



(defn merge [s1 s2]
  (cond (stream-null? s1) s2
        (stream-null? s2) s1
        :else (let [s1car (stream-car s1)
                    s2car (stream-car s2)]
                (cond (< s1car s2car)
                      (cons-stream s1car (merge (stream-cdr s1) s2))

                      (> s1car s2car)
                      (cons-stream s2car (merge s1 (stream-cdr s2)))
                      
                      :else
                      (cons-stream s1car (merge (stream-cdr s1) (stream-cdr s2)))))))

;; *) S begins with 1
;; *) the elements of (scale-stream S 2) are also elements of S
;; *) the same is true for (scale-stream S 3) and (scale-stream S 5)
;; *) these are all elements of S

;; S is the required stream of numbers with no prime factors other than 2, 3 or 5.
(def S (cons-stream 1 
                    (merge (scale-stream integers 2)
                           (merge (scale-stream integers 3)
                                  (scale-stream integers 5)))))


;; ex 3.57

;; nth fib

;; 0th = 0
;; 1st = 0
;; 2nd = 1
;; 3rd = 2

;; n additions.  otherwise, it'd be n + (n-1) + (n-2) + ... + 1

;; ex 3.58

(def quotient quot)

(defn expand [num den radix]
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

(expand 1 7 10) ;= (1 (expand 3 7 10)
(expand 1 7 10) ;= (1 4 (expand 2 7 10))
(expand 1 7 10) ;= (1 4 2 (expand 6 7 10))
(expand 1 7 10) ;= (1 4 2 8 5 7 1 4 2 8...)

(stream-ref
 (expand 1 7 10)
 6)

(expand 3 8 10) ;= 3 7 5 0 0 0 0


;; ex 3.59

;; integral of a_0 + a_1 x + a_2 x^2 + a_3 x^3 + ...

;; is  c + a_0 x + (1/2) a_1 x^2 + (1/3) a_2 x^3 + (1/4) * a_3 x^4 + ...

;; a

(defn div-streams [s1 s2]
  (stream-map / s1 s2))

(defn integrate-series [s]
  "s is a list of coefficients representing a power series of a_0 + a_1 * x^1 + ..."
  (div-streams s integers))

;; b

;; f(x) = e^x is its own derivative

(def exp-series 
  "e^x"
  (cons-stream 1 (integrate-series exp-series)))

(declare cosine-series)

;; derivative of sine is cosine
;; d(sine)/dx = cos x

;; sine = int(cos x) + c
(def sine-series
  (cons-stream 0 
               (integrate-series cosine-series)))

;; derivative of cosine is the negative of sine

;; d/dx cos(x) = -sine(x)
;; cos(x) = c - integrate(sine(x))

(def neg-ones (cons-stream -1 neg-ones))

(def cosine-series
  (cons-stream 1 
               (mul-streams
                neg-ones
                (integrate-series sine-series))))

;; derivative of cosine is the negative of sine


(stream-ref cosine-series 0) ;= 1
(stream-ref cosine-series 1) ;= 0
(stream-ref cosine-series 2) ;= -1/2
(stream-ref cosine-series 3) ;= 0
(stream-ref cosine-series 4) ;= 1/24
(stream-ref sine-series 0) ;= 0
(stream-ref sine-series 1) ;= 1
(stream-ref sine-series 2) ;= 0
(stream-ref sine-series 3) ;= -1/6
(stream-ref sine-series 4) ;= 0
(stream-ref sine-series 5) ;=  1/120

;; ex 3.60

;; not mul-streams, this multiplies power series
(def add-series add-streams)

(defn always [c]
  (cons-stream c
               (always c)))

(defn mul-series [s1 s2]
  (cons-stream
   (* (stream-car s1) (stream-car s2))
   (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                (mul-series (stream-cdr s1)
                            s2))))

(def x 
  (add-series
   (mul-series sine-series sine-series)
   (mul-series cosine-series cosine-series)))

;; x should be the series (1 0 0 0 0 0 0 0 0...)


(stream-ref x 0) ;= 1
(stream-ref x 1) ;= 0
(stream-ref x 2) ;= 0
(stream-ref x 3) ;= 0
(stream-ref x 4) ;= 0
(stream-ref x 5) ;= 0
(stream-ref x 6) ;= 0
(stream-ref x 7) ;= 0
(stream-ref x 8) ;= 0

;; ex 3.61

;; S:
;;; power series whose constant term is 1

;; we want to calculate poewr series X = 1/S
;;    - i.e., (mul-series S X) = (1 0 0 0 ...)

;; S = 1 + S_R
;;   S_R is the part of S after the constant term.
;;         S * X = 1
;; (1 + S_R) * X = 1
;;   X + S_R * X = 1
;;             X = 1 - S_R * X

;;;;;;;; i.e., X is the power series whose constant term is 1 and whose
;;;;;;;; higher order terms are given by the negative of S_R times X

(def zeroes (cons-stream 0 zeroes))


(def constant-one (cons-stream 1 zeroes))

(stream-ref neg-ones 0) ;= -1
(stream-ref neg-ones 1) ;= -1
(stream-ref neg-ones 2) ;= -1
(stream-ref neg-ones 3) ;= -1
(stream-ref neg-ones 4) ;= -1
(stream-ref neg-ones 5) ;= -1
(stream-ref neg-ones 6) ;= -1

(defn negate-stream [s]
  (mul-streams neg-ones s))

(def should-be-ones (negate-stream neg-ones))

(stream-ref should-be-ones 0) ;= 1
(stream-ref should-be-ones 1) ;= 1
(stream-ref should-be-ones 2) ;= 1
(stream-ref should-be-ones 3) ;= 1
(stream-ref should-be-ones 4) ;= 1
(stream-ref should-be-ones 5) ;= 1
(stream-ref should-be-ones 6) ;= 1


(defn sub-streams [a b]
  (add-streams a
               (negate-stream b)))

(def should-be-zeroes (sub-streams constant-one constant-one))

(stream-ref should-be-zeroes 0) ;= 0
(stream-ref should-be-zeroes 1) ;= 0
(stream-ref should-be-zeroes 2) ;= 0
(stream-ref should-be-zeroes 3) ;= 0
(stream-ref should-be-zeroes 4) ;= 0
(stream-ref should-be-zeroes 5) ;= 0
(stream-ref should-be-zeroes 6) ;= 0

(defn invert-unit-series [s]
  (let [s_r (stream-cdr s)
        myx (fn myx [] (cons-stream 1
                                    (negate-stream 
                                     (mul-series s_r (myx)))))]
    (myx)))

(defn invert-unit-series [s]
  (let [myx (fn myx [] (cons-stream 1
                                    (negate-stream 
                                     (mul-series (stream-cdr s) (myx)))))]
    (myx)))

(defn invert-unit-series [s]
  (cons-stream 1
               (negate-stream 
                (mul-series (stream-cdr s) (invert-unit-series s)))))


sine-series

(def inverted-cosine-series (invert-unit-series cosine-series))

(def should-be-one (mul-series inverted-cosine-series cosine-series))
(stream-ref should-be-one 0) ;= 1
(stream-ref should-be-one 1) ;= 0
(stream-ref should-be-one 2) ;= 0
(stream-ref should-be-one 3) ;= 0
(stream-ref should-be-one 4) ;= 0
(stream-ref should-be-one 5) ;= 0
(stream-ref should-be-one 6) ;= 0




(stream-ref x 0) ;= 1

; .1/S implies S * X = 1

;; ex 3.62

(defn error [& msg] (throw (IllegalStateException. (apply str msg))))

(defn invert-stream [s]
  (cons-stream (/ 1 (stream-car s))
               (invert-stream (stream-cdr s))))

(defn div-series [num den]
  (let [den0 (stream-car den)]
    (if (= den0 0)
      (error "den cannot start with zero")
      (let [unit-den (scale-stream den (/ 1 den0))
            inverted-unit-den (invert-unit-series unit-den)
            unit-result (mul-series num inverted-unit-den)]
        (scale-stream unit-result (/ 1 den0))))))


(def tangent-series (div-series sine-series cosine-series))



;; div-series should work for any two series, provided that the
;; denominator series begins with a non-zero constant term.  if the
