(ns problem03
  (:require clojure.contrib.math))

; Decreasing lazy stream, stop at 1
(defn lazy-stream 
  ([start]
    (lazy-stream start 2))
  ([start stop]
    (if (< start stop)
    '()
    (lazy-seq (cons start (lazy-stream (- start 1) stop))))))

; Increasing lazy stream, start at 2
(defn lazy-stream-inc
  ([stop]
    (lazy-stream-inc 2 stop))
  ([nbr stop]
  (if (> nbr stop)
    '()
    (lazy-seq (cons nbr (lazy-stream-inc (+ nbr 1) stop))))))

; Test if two nbrs are divisible
(defn is-divisor-of [toTest nbr]
  (= 0 (mod nbr toTest)))

; Get lazy list of divisors of nbr
(defn divisors [nbr]
  (let [stream (lazy-stream-inc (bigint (clojure.contrib.math/ceil (/ nbr 2))))]
    (lazy-seq (filter (fn[n](is-divisor-of n nbr)) stream))))

; Check if number is prime (naive)
(defn is-prime? [n]
  (nil? (first (divisors n))))
(def is-prime-main (memoize is-prime?))

; Find first greatest prime factor of number ...
(defn get-factors [n]
  (let [fprimediv 
          (first (filter is-prime-main (divisors n)))]
    (if (nil? fprimediv)
      (list n)
      (concat (list fprimediv) (get-factors (/ n fprimediv))))))

;(reduce max (get-factors 600851475143)) ; 600851475143