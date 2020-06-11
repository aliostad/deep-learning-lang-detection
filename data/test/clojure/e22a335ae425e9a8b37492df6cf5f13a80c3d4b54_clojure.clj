(ns fourclojure.4-clojure
  (:require [clojure.set :as cs]))

;problem 69 merge with function
((fn [f & ms]
   (into {} (for [[k v]
                  (group-by first
                            (for [m ms [k v] m]
                              [k v]))]
              {k (reduce f (map second v))}))) concat {:a [3], :b [6]} {:a [4 5], :c [8 9]} {:b [7]})

;problem 70 camel casing
((fn [s]
   (let [[a & others] (clojure.string/split s (re-pattern "-"))]
     (apply str a
            (map #(let [[x & ys] %]
                   (apply str (Character/toUpperCase x) ys)) others)))) "multi-word-key")

;problem Euler's totient function
((fn [x] (letfn [(gcd [a b]
                   (loop [ia a ib b]
                     (if (= ib 0)
                       ia
                       (recur ib (mod ia ib)))))]
           (count (filter #(= 1 (gcd % x)) (range 1 (inc x)))))) 99)

;problem 86 happy numbers
((fn [x]
   (letfn [(square-ch [y] (let [n (Integer/parseInt (str y))] (* n n)))]
     (loop [s (str x) ctrl #{}]
       (let [s2 (reduce + (map #(square-ch %) s))]
         (cond
           (= s2 1) true
           (ctrl s2) false
           :else (recur (str s2) (conj ctrl s2))))))) 7)

;problem 78 reimplement trampoline
(letfn [(triple [x] #(sub-two (* 3 x)))
        (sub-two [x] #(stop? (- x 2)))
        (stop? [x] (if (> x 50) x #(triple x)))]
  ((fn my-trampo [f & args]
     (loop [g (apply f args)]
       (if (ifn? g)
         (recur (g))
         g))) triple 2))

;problem 115 the balance of n
((fn balance-n [x]
   (letfn [(divide [s]
             (let [len (count s) half (int (/ len 2))]
               (if (even? len) (partition half s) [(take half s) (drop (inc half) s)])))
           (sum [chs] (reduce + 0 (map #(Integer/parseInt (str %)) chs)))]
     (let [sx (str x) [l r] (divide sx)]
       (= (sum l) (sum r))))) 11)

;problem 85 - powerset
; As per "Disc. Math and FP"
; 1. Pick an element a of A
; 2. Find the powerset of the set without a, that is A - {a}
; 3. Find the set formed by adding a to every element in the set found in part 2
; 4. Combine sets found in parts 2 and 3
; Well, didn't manage to find correct solution as per above, now trying wikipedia way:
; https://en.wikipedia.org/wiki/Power_set
(defn- op-f [e t]
  (map #(conj % e) t))

(defn powerset [s]
  (if (seq s)
    (let [e (first s) t (powerset (disj s e))]
      (cs/union t (op-f e t)))
    #{#{}}))

(defn tic-tac-toe [board]
  (let [players (into #{} (apply concat board))]
    (cond
      (empty? (rest players)) nil)))