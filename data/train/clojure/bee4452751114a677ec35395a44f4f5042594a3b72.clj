(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-72
(defn sqr-sum [pair]
    (+ (sqr (first pair)) (sqr (second pair))))

(def sqr-sum-pairs
    (weighted-pairs integers integers sqr-sum))

(defn find-sqr-ram [pairs]
    (let [w1 (sqr-sum (stream-car pairs))
        rp1 (stream-cdr pairs)
        w2 (sqr-sum (stream-car rp1))
        rp2 (stream-cdr rp1)
        w3 (sqr-sum (stream-car rp2))]
        (cond 
            (= w1 w2 w3)
                (cons-stream w1 (find-sqr-ram (stream-cdr rp2)))
            (= w2 w3)
                (find-sqr-ram rp1)
            :else
                (find-sqr-ram rp2))))

(def sqr-ram-stream (find-sqr-ram sqr-sum-pairs))
