(ns clojure.com.intelliarts.starasov.sicp.stream.pairs
  (:require [clojure.com.intelliarts.starasov.sicp.stream.stream :as s]))

(def integers (s/stream-cons 1 (s/stream-map inc integers)))

(defn stream-interleave [s1 s2]
  (if s/empty-stream? s1)
  s2
  (s/stream-cons (s/stream-car s1) (stream-interleave s2 (s/stream-cdr s1))))

(defn pairs [s1 s2]
  (s/stream-cons (list (s/stream-car s1) (s/stream-car s2))
    (stream-interleave
      (s/stream-map (fn [x] (list (s/stream-car s1) x)) (s/stream-cdr s2))
      (pairs (s/stream-cdr s1) (s/stream-cdr s2)))))

(defn stream-append [s1 s2]
  (s/stream-cons (list (s/stream-car s1) (s/stream-car s2))
    (stream-append (s/stream-cdr s1) (s/stream-cdr s2))))

(defn stream-filter [pred s]
  (loop [stream s]
    (if (pred (s/stream-car stream))
        (s/stream-cons (s/stream-car stream) (stream-filter pred (s/stream-cdr stream)))
      (recur (s/stream-cdr stream)))))

"Exercise 3.66.
Examine the stream (pairs integers integers). Can you make any general
comments about the order in which the pairs are placed into the stream? For example, about how many
pairs precede the pair (1,100)? the pair (99,100)? the pair (100,100)? (If you can make precise mathematical
statements here, all the better. But feel free to give more qualitative answers if you find yourself getting
bogged down.)"

(def indexed-pairs (stream-append integers (pairs integers integers)))

"Exercise 3.67.
Modify the pairs procedure so that (pairs integers integers) will produce the
stream of all pairs of integers (i,j) (without the condition i < j). Hint: You will need to mix in an additional
stream."

(defn pairs-modified [s1 s2]
  (s/stream-cons (list (s/stream-car s1) (s/stream-car s2))
    (stream-interleave
      (stream-interleave
        (s/stream-map (fn [x] (list (s/stream-car s1) x)) (s/stream-cdr s2))
        (pairs (s/stream-cdr s1) (s/stream-cdr s2)))
      (s/stream-map (fn [x] (list x (s/stream-car s1))) (s/stream-cdr s2)))))

"Exercise 3.69: Write a procedure triples that takes three inﬁnite
streams, S, T , and U, and produces the stream of triples (S i , T j ,U k )
such that i ≤ j ≤ k.   Use triples to generate the stream of all
Pythagorean triples of positive integers, i.e., the triples (i, j, k) such
that i ≤ j and i^2 + j^2 = k^2."

(defn triples [s1 s2 s3]
  (s/stream-cons (list (s/stream-car s1) (s/stream-car s2) (s/stream-car s3))
    (stream-interleave
      (s/stream-map
        (fn [x] (cons (s/stream-car s1) x)) (pairs s2 s3))
      (triples (s/stream-cdr s1) (s/stream-cdr s2) (s/stream-cdr s3)))))

(defn pythagorean-predicate [i, j, k]
  (= (+ (* i i) (* j j)) (* k k)))

(def pythagorean
  (stream-filter
    (fn [triple]
        (apply pythagorean-predicate triple))
    (triples integers integers integers)))

"Exercise 3.70:

It would be nice to be able to generate streams in
which the pairs appear in some useful order,  rather than in the
order  that  results  from  an  ad  hoc  interleaving  process.   We  can
use a technique similar to the merge procedure of Exercise 3.56,
if we deﬁne a way to say that one pair of integers is “less than” an-
other. One way to do this is to deﬁne a “weighting function” W (i, j )
and stipulate that (i1, j1 ) is less than (i2, j2 ) if W (i1, j1 ) < W (i2, j2 ).
Write a procedure merge-weighted that is like merge, except that
merge-weighted takes an additional argument weight, which is a
procedure that computes the weight of a pair, and is used to de-
termine the order in which elements should appear in the result-
ing merged stream.69   Using this, generalize pairs to a procedure
weighted-pairs that takes two streams, together with a procedure
that computes a weighting function, and generates the stream of
pairs, ordered according to weight.  Use your procedure to gener-
ate

a.  the stream of all pairs of positive integers (i, j) with i ≤ j or-
dered according to the sum i + j ,

b.  the stream of all pairs of positive integers (i, j) with i ≤ j , where
neither i nor j is divisible by 2, 3, or 5, and the pairs are ordered
according to the sum 2i + 3 j + 5ij."

(defn merge-weighted [s1 s2 weight]
  (cond
    (s/empty-stream? s1) s2
    (s/empty-stream? s2) s1
    :else
      (let [h1 (s/stream-car s1) h2 (s/stream-car s2) w1 (apply weight h1) w2 (apply weight h2)]
        (cond
          (< w1 w2) (s/stream-cons h1 (merge-weighted (s/stream-cdr s1) s2 weight))
          (> w1 w2) (s/stream-cons h2 (merge-weighted s1 (s/stream-cdr s2) weight))
          :else (s/stream-cons h1 (s/stream-cons h2 (merge-weighted (s/stream-cdr s1) (s/stream-cdr s2) weight)))))))

(defn pairs-weighted [s1 s2 weight]
  (s/stream-cons (list (s/stream-car s1) (s/stream-car s2))
    (merge-weighted
      (s/stream-map (fn [x] (list (s/stream-car s1) x)) (s/stream-cdr s2))
      (pairs-weighted (s/stream-cdr s1) (s/stream-cdr s2) weight)
      weight)))


(def pairs-a (pairs-weighted integers integers (fn [i, j] (+ i j))))

(def filtered-integers (stream-filter (fn [i] (and (> (mod i 2) 0) (> (mod i 3) 0) (> (mod i 5) 0))) integers))
(def pairs-b (pairs-weighted filtered-integers filtered-integers (fn [i, j] (+ (* 2 i) (* 3 j) (* 5 i j)))))

"Exercise 3.71.

Numbers that can be expressed as the sum of two cubes in more than one way are
sometimes called Ramanujan numbers, in honor of the mathematician Srinivasa Ramanujan.70 Ordered
streams of pairs provide an elegant solution to the problem of computing these numbers. To find a number
that can be written as the sum of two cubes in two different ways, we need only generate the stream of pairs
of integers (i,j) weighted according to the sum i3 + j3 (see exercise 3.70), then search the stream for two
consecutive pairs with the same weight. Write a procedure to generate the Ramanujan numbers. The first
such number is 1,729. What are the next five?"

(defn stream-finder [pred s]
  (loop [stream s]
    (let [first (s/stream-car stream) rest (s/stream-cdr stream) second (s/stream-car rest)]
      (if (= (apply pred first) (apply pred second))
        (s/stream-cons (apply pred first) (stream-finder pred (s/stream-cdr rest)))
        (recur (s/stream-cdr stream))))))

(def pred-ramanujan (fn [i, j] (+ (* i i i) (* j j j))))

(def pairs-ramanujan (stream-finder pred-ramanujan (pairs-weighted integers integers pred-ramanujan)))
(println pairs-ramanujan)
