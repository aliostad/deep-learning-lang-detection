(ns clojure.com.intelliarts.starasov.sicp.stream.stream)

(defn stream-car [stream]
  (first stream))

(defn stream-cdr [stream]
  (force (second stream)))

(defmacro stream-cons [x stream]
  (list 'list x (list 'delay stream)))

(defn stream-ref [stream n]
  (if (= n 0)
    (stream-car stream)
    (stream-ref (stream-cdr stream) (dec n))))

(def empty-stream '(:empty-stream ))
(defn empty-stream? [stream]
  (= stream empty-stream))

(defn stream-map [proc stream]
  (do
    (if-not (empty-stream? stream)
    (stream-cons (proc (stream-car stream)) (stream-map proc (stream-cdr stream)))
    empty-stream)))

(defn lazy-range [start end]
  (if (= start end)
    empty-stream
    (stream-cons start (lazy-range (inc start) end))))

(defn show [x]
  (do
    (println "x =" x)
    x))

(defn add-streams [s1 s2]
  (stream-cons
    (+ (stream-car s1) (stream-car s2))
    (add-streams (stream-cdr s1) (stream-cdr s2))))

(defn mul-streams [s1 s2]
  (stream-cons
    (* (stream-car s1) (stream-car s2))
    (mul-streams (stream-cdr s1) (stream-cdr s2))))

(def ones (stream-cons 1 ones))
(def doubled (stream-cons 1 (add-streams doubled doubled)))
(def integers (stream-cons 1 (add-streams ones integers)))
(def factorial (stream-cons 1 (mul-streams factorial integers)))

"Exercise 3.55: Define a procedure partial-sums that takes as argument a stream
S and returns the stream whose elements are S0, S0 + S1, S0 + S1 + S2, ...
For example, (partial-sums integers) should be the stream 1, 3, 6, 10, 15, ..."

(defn partial-sums [s]
  (defn iter [prev-sum s]
    (let [sum (+ prev-sum (stream-car s))]
      (stream-cons sum (iter sum (stream-cdr s)))))
  (iter 0 s))

"Exercise 3.56.  A famous problem, first raised by R. Hamming, is to enumerate, in ascending order with no
repetitions, all positive integers with no prime factors other than 2, 3, or 5. One obvious way to do this is to
simply test each integer in turn to see whether it has any factors other than 2, 3, and 5. But this is very
inefficient, since, as the integers get larger, fewer and fewer of them fit the requirement. As an alternative,
let us call the required stream of numbers S and notice the following facts about it:
  - S begins with 1.
  - The elements of (scale-stream S 2) are also elements of S.
  - The same is true for (scale-stream S 3) and (scale-stream 5 S).
  - These are all the elements of S."

(defn stream-scale [stream scale]
  (stream-cons
    (* (stream-car stream) scale)
    (stream-scale (stream-cdr stream) scale)))

(defn stream-merge [s1 s2]
  (cond
    (empty-stream? s1) s2
    (empty-stream? s2) s1
    :else (let [h1 (stream-car s1) h2 (stream-car s2)]
            (cond
              (< h1 h2) (stream-cons h1 (stream-merge (stream-cdr s1) s2))
              (> h1 h2) (stream-cons h2 (stream-merge s1 (stream-cdr s2)))
              :else (stream-cons h1 (stream-merge (stream-cdr s1) (stream-cdr s2)))))))

(def S (stream-cons 1
         (merge (stream-scale S 2) (merge (stream-scale S 3) (stream-scale S 5)))))

(def fibs (stream-cons 0 (stream-cons 1 (add-streams (stream-cdr fibs) fibs))))

(defn expand [num den radix]
  (stream-cons
    (quot (* num radix) den)
    (expand (rem (* num radix) den) den radix)))

"Exercise 3.59.  In section 2.5.3 we saw how to implement a polynomial arithmetic system representing
polynomials as lists of terms. In a similar way, we can work with power series."

(defn integrate-series [stream]
  (defn scale-stream [n]
    (stream-cons (/ 1 n) (scale-stream (inc n))))
  (mul-streams stream (scale-stream 1)))

(def exp-series (stream-cons 1 (integrate-series exp-series)))

;(def cosine-series
;  (stream-cons 1 (stream-scale (integrate-series sine-series) -1)))

;(def sine-series
;  (stream-cons 0 (integrate-series cosine-series)))

(defn sqrt-improve [guess x]
  (/ (+ guess (/ x guess)) 2.0))

(defn sqrt-stream [x]
  (def guesses (stream-cons 1.0
                 (stream-map (fn [guess] (do (sqrt-improve guess x))) guesses)))
  guesses)

"Exercise 3.64.  Write a procedure stream-limit that takes as arguments a stream and a number (the
tolerance). It should examine the stream until it finds two successive elements that differ in absolute value
by less than the tolerance, and return the second of the two elements. Using this, we could compute square
roots up to a given tolerance by:

  (define (sqrt x tolerance)
    (stream-limit (sqrt-stream x) tolerance))"

(defn stream-limit [stream tolerance]
  (defn good-enough? [current last]
    (< (Math/abs (- current last)) tolerance))

  (defn iter [last current-stream]
    (if (good-enough? last (stream-car current-stream))
      empty-stream
      (stream-cons (stream-car current-stream) (iter (stream-car current-stream) (stream-cdr current-stream)))))

  (iter (stream-car stream) (stream-cdr stream)))

(defn pi-summands [n]
  (stream-cons (/ 1.0 n) (stream-map - (pi-summands (+ n 2)))))

(defn ln-summands [n]
  (stream-cons (/ 1.0 n) (stream-map - (ln-summands (+ n 1)))))