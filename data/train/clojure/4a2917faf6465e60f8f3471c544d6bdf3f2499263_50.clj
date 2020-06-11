;; Exercise 3.50
;; Complete the following definition, which generalizes stream-map to allow
;; procedures that take multiple arguments, analogous to map in section 2.2.3,
;; footnote 12.
;;
;; (define (stream-map proc . argstreams)
;;   (if (<??> (car argstreams))
;;     the-empty-stream
;;     (<??>
;;      (apply proc (map <??> argstreams))
;;      (apply stream-map (cons proc (map <??> argstreams))))))

;; (define (stream-map proc . argstreams)
;;   (if (stream-null? (car argstreams))
;;     the-empty-stream
;;     (cons-stream
;;       (apply proc (map stream-car argstreams))
;;       (apply stream-map
;;         (cons proc (map stream-cdr argstreams))))))

(ns sicp-mailonline.exercises.3-50
  (:require [sicp-mailonline.examples.3-5-1 :as strm]))

(defn stream-map [proc & argstreams]
  (if (strm/stream-null? (first argstreams))
    strm/the-empty-stream
    (strm/cons-stream
      (apply proc (map strm/stream-car argstreams))
      (apply stream-map
             (cons proc (map strm/stream-cdr argstreams))))))
