(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-54
(defn mul-streams [st1 st2]
    (stream-map * st1 st2))

(def factorials
    (cons-stream 1
        (mul-streams factorials (integers-starting-from 2))))

; 3-55
(defn partial-sum [st]
    (cons-stream
        (stream-car st)
        (add-streams
            (stream-cdr st)
            (partial-sum st))))

; 3-56
; 복잡해 보이는데 결국 그냥 이거 아닌가?
(def S
    (cons-stream 1
        (merge (scale-stream S 2)
            (merge (scale-stream S 3)
                   (scale-stream S 5)))))
