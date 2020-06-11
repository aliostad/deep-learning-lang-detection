;; Exercise 3.64
;; Write a procedure stream-limit that takes as arguments a stream and a number
;; (the tolerance).  It should examine the stream until it finds two successive
;; elements that differ in absolute value by less than the tolerance, and return
;; the second of the two elements.
;; Using this, we could compute square roots up to a given tolerance by
;;
;; (define (sqrt x tolerance)
;;   (stream-limit (sqrt-stream x) tolerance))

(ns sicp-mailonline.exercises.3-64
  (:require [sicp-mailonline.examples.3-5-1 :as strm]))

(defn within-tolerance? [a b tolerance]
  (< (Math/abs (- a b))
     tolerance))

(defn stream-limit [stream tolerance]
  (if-not (strm/stream-null? stream)
    (let [current (strm/stream-car stream)
          next (strm/stream-car (strm/stream-cdr stream))]
      (if (within-tolerance? current next tolerance)
        next
        (recur (strm/stream-cdr stream) tolerance)))))
