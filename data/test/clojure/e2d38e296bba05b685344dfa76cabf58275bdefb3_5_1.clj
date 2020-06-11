;; Example 3.5.1 Streams are Delayed Lists
;;
;;; Note that Clojure has lazy sequences, providing stream-like behaviour as a built-in.
;;;
;;; Note that Clojure provides delay/force as a built-in, supporting laziness.
;;; While the implementation differs from that of SICP, it is conceptually similar, with
;;; the added benefit that the function is guaranteed to only be executed once, even in
;;; the event of concurrent invocation across multiple threads.
;;; Delay is a macro in Clojure, in order to avoid evaluating the argument function.

(ns sicp-mailonline.examples.3-5-1)

(def ^:const the-empty-stream '())

;; non-memoized delay to assist with testing exercise 3.52
;; (defmacro delay [exp]
;;   `(fn [] ~exp))

;; (defn force [delayed-object]
;;   (delayed-object))

;; as per footnote 56, cons-stream must be a "special form" to avoid evaluation of b
;; we can use a macro to achieve this avoidance of evaluation
(defmacro cons-stream [a b]
  `(vector ~a (delay ~b)))
 
(defn stream-car [s]
  (first s))

(defn stream-cdr [s]
  (force (second s)))

(defn stream-null? [s]
  (empty? s))

;; equivalent of nth
(defn stream-ref [s n]
  (if (zero? n)
    (stream-car s)
    (recur (stream-cdr s) (dec n))))

(defn stream-map [proc s]
  (if (stream-null? s)
    the-empty-stream
    (cons-stream (proc (stream-car s))
                 (stream-map proc (stream-cdr s)))))

(defn stream-for-each [proc s]
  (if (stream-null? s)
    'done
    (do
      (proc (stream-car s))
      (recur proc (stream-cdr s)))))

(defn display-line [x]
  (printf "%n%s" x))

(defn display-stream [s]
  (stream-for-each display-line s))

(defn stream-enumerate-interval [low high]
  (if (> low high)
    the-empty-stream
    (cons-stream low
                 (stream-enumerate-interval (inc low) high))))

(defn stream-filter [pred stream]
  (cond (stream-null? stream)
          the-empty-stream
        (pred (stream-car stream))
          (cons-stream (stream-car stream)
                       (stream-filter pred (stream-cdr stream)))
          :else (stream-filter pred (stream-cdr stream))))
