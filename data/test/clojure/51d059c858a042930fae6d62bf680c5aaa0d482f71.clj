(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-71
(defn cube-sum [pair]
    (+ (cube (first pair)) (cube (second wpair))))

(def cube-sum-pairs
    (weighted-pairs integers integers cube-sum))

(defn find-ram [pairs]
    (let [w1 (cube-sum (stream-car pairs))
        w2 (cube-sum (stream-car (stream-cdr pairs)))]
        (if (= w1 w2)
            (cons-stream w1 (find-ram (stream-cdr (stream-cdr pairs))))
            (find-ram (stream-cdr pairs))
            )
        )
    )

(def ramanujan-stream (find-ram cube-sum-pairs))
