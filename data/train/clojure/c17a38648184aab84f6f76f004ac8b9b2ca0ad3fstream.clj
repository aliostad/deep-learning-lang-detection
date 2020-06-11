(ns logjure.utils.stream
  (:use logjure.utils.pair)
  )

(def the-empty-stream nil)

(defn stream-null? 
  [stream]
  (nil? stream)
  )

(defmacro cons-stream 
  [x s]
    `(cons-pair ~x (delay ~s))
  )

(defn stream-car 
  [stream] 
  (car stream)
  )

(defn stream-cdr 
  [stream] 
  (force (cdr stream))
  )

(defn singleton-stream 
  [x]
  (cons-stream x the-empty-stream)
  )

(defn stream-append 
  [s1 s2]
  (if (stream-null? s1)
    s2
    (cons-stream
      (stream-car s1)
      (stream-append (stream-cdr s1) s2)))
  )

(defn stream-append-delayed 
  [s1 delayed-s2]
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (stream-append-delayed (stream-cdr s1) delayed-s2)))
  )

(defn interleave-delayed 
  [s1 delayed-s2]
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (interleave-delayed (force delayed-s2) (delay (stream-cdr s1)))))
  )

(defn flatten-interleave-stream 
  [stream]
  (if (stream-null? stream)
    the-empty-stream
    (interleave-delayed
      (stream-car stream)
      (delay (flatten-interleave-stream (stream-cdr stream)))))
  )

(defn flatten-stream
  "if the stream is infinite, this function will get stuck on it, 
and following streams will never have a chance to contribute to result stream"
  [stream]
  (if (stream-null? stream)
    the-empty-stream
    (stream-append-delayed
      (stream-car stream)
      (delay (flatten-stream (stream-cdr stream)))))
  )

(defn stream-map 
  [proc stream]
  (if (stream-null? stream)
    the-empty-stream
    (cons-stream 
      (proc (stream-car stream)) 
      (stream-map proc (stream-cdr stream))))
  )

(defn stream-nth 
  [n stream]
  (if (stream-null? stream)
    the-empty-stream
    (if (= n 0)
      (stream-car stream) 
      (recur (dec n) (stream-cdr stream))))
  )

(defn stream-nth-2 
  [stream n not-found]
  (let [x (stream-nth n stream)]
    (if (= x the-empty-stream)
      not-found
      x))
  )

(defn seq-to-stream [the-seq]
  (if (seq the-seq)
    (cons-stream (first the-seq) (seq-to-stream (rest the-seq)))
    the-empty-stream)
  )

(defn stream-to-seq [stream]
  (lazy-seq
    (when (not (stream-null? stream))
      (cons (stream-car stream) (stream-to-seq (stream-cdr stream)))))
  )