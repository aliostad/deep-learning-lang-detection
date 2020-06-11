(ns section-3-5-3.stream-math
  (:require [section-3-5-3.streams :refer :all]
            [section-3-5-3.math :refer :all]
            [section-3-5-3.letrec :as lr]))

(defn sqrt-stream [x]
  (lr/letrec [s
              (cons-stream 1.0 (stream-map #(sqrt-improve % x) s))]
             s))

(defn sqrt [x tolerance]
  (stream-limit (sqrt-stream x) tolerance))

;; 1 - 1/3 + 1/5 - 1/7 + ...
;;
(defn- pi-summands [n]
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))

;;and then scale stream by 4, to go from pi/4 to pi
(def ^:private pi-stream
  (scale-stream
   (partial-sums (pi-summands 1))
   4))

(defn euler-transform [s]
  "Stream accelerator that works with with sequences that are partial
  sums of alternating series (series of terms with alternating
  signs.)"
  (let [s0 (stream-ref s 0)
        s1 (stream-ref s 1)
        s2 (stream-ref s 2)]
    ;; takes first three values of streams band 
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(defn- ln-2-summands [n]
  (cons-stream (/ 1.0 n)
               (stream-map - (ln-2-summands (inc n)))))

(def ln-2-stream
  (partial-sums (ln-2-summands 1)))

(defn integers-starting-from [n]
  (cons-stream n (integers-starting-from (inc n))))

(def integers (integers-starting-from 1))

(declare primes)

(defn prime? [n]
  (loop [ps primes]
    (cond (> (square (stream-car ps)) n) true
          (divisible? n (stream-car ps)) false
          :else (recur (stream-cdr ps)))))

(def primes
  (cons-stream
   2
   (stream-filter prime? (integers-starting-from 3))))

(defn pairs-on-or-above-diagonal
  "Given two infinite stream of items, visualized as a two dimensional
  array infinite on both axes, produce all pairs which lie on or above
  the diagonal"
  ([s t]
   (pairs-on-or-above-diagonal s t stream-interleave))
  ([s t merge-fn]
   (cons-stream
    (list (stream-car s) (stream-car t)) ;; #1
    (merge-fn
     (stream-map #(list (stream-car s) %) ;; E2
                 (stream-cdr t))
     (pairs-on-or-above-diagonal (stream-cdr s) (stream-cdr t) merge-fn)))))

(def int-pairs
  "sequence of all pairs of integers (i,j) with i<=j"
  (pairs-on-or-above-diagonal integers integers))

(def prime-sum-pairs-stream
  (stream-filter #(prime? (+ (first %) (second %))) int-pairs))

(defn all-pairs
  [s t]
  (cons-stream
   (list (stream-car s) (stream-car t)) ;; #1
   (stream-interleave
    (stream-map #(list (stream-car s) %) (stream-cdr t)) ;; #2
    (stream-map #(list % (stream-car t)) (stream-cdr s)) ;; #3
    (pairs-on-or-above-diagonal (stream-cdr s) (stream-cdr t))))) ;; #4

(defn- three-d-6 [i j k]
  (stream-map #(list (first %) (stream-car j) (second %)) ;; # 6
              (pairs-on-or-above-diagonal
               (stream-filter #(<= % (stream-car j)) (stream-cdr i))
               (stream-filter #(>= % (stream-car j)) (stream-cdr k)))))

;; (finite 3 (pairs-on-or-above-diagonal (stream-cdr integers) (stream-cdr integers)))
;; (finite 3 (three-d-6 integers integers integers))
;;=> ((2 1 2) (2 1 3) (3 1 3))

;; (finite 10 (three-d-7 integers integers integers))

(defn three-d-pairs-on-or-above-diagonal
  "Given three infinite stream of items, visualized as a three
  dimensional array infinite on both axes, produce all triplits which lie
  on or above the diagonal, such that i<=j<=k"
  [i j k]
  (cons-stream
   (list (stream-car i) (stream-car j) (stream-car k)) ;; #1
   (stream-interleave
    ;; #2 did not make the cut
    ;; #3 did not make the cut
    (stream-map #(list (stream-car i) (stream-car j) %) ;; #4
                (stream-cdr k)) ;; #4
    ;; #5 did not make the cut
    ;; #6 did not make the cut
    (stream-map #(list (stream-car i) (first %) (second %))  ;; # 7
                (pairs-on-or-above-diagonal
                 (stream-filter #(>= % (stream-car i)) (stream-cdr j))
                 (stream-filter #(>= % (stream-car i)) (stream-cdr k))))
    (three-d-pairs-on-or-above-diagonal (stream-cdr i) (stream-cdr j) (stream-cdr k))))) ;; #8


(def int-triples
  "sequence of all tirples of integers (i,j,k) with i<=j<=k"
  (three-d-pairs-on-or-above-diagonal integers integers integers))

(defn third [list]
  (nth list 2))

(defn is-pythagorean-triple? [triple]
  (=
   (+ (square (first triple))
      (square (second triple)))
   (square (third triple))))

(def pythagorean-triples (stream-filter is-pythagorean-triple? int-triples))

(defn stream-merge [s1 s2]
  (stream-merge-weighted s1 s2 <))
