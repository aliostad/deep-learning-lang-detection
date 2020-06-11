(ns section-3-5-5.streams
  (:require [clojure.core :exclude [delay force]]
            [section-3-5-5.memo-proc :as mp]
            [section-3-5-5.display :refer :all]
            [section-3-5-5.math :refer :all]))

(defmacro my-delay [a]
  `(mp/memo-proc 
    (fn []
      ~a)))

(defmacro cons-stream [a b]
  `(list ~a (my-delay ~b)))

(def the-empty-stream '())

(defn stream-car [stream]
  (first stream))

(defn my-force [delayed-object]
  (delayed-object))

(defn stream-cdr [stream]
  (if (empty? (rest stream))
    '()
    (my-force (first (rest stream)))))

(defn stream-map [proc & argstreams]
  (if (empty? (first argstreams))
    the-empty-stream
    (cons-stream
     (apply proc (map stream-car argstreams))
     (apply stream-map (cons proc (map stream-cdr argstreams))))))

(defn stream-null? [s]
  (empty? s))

(defn stream-for-each [proc s]
  (if (stream-null? s)
    :done
    (do
      (proc (stream-car s))
      (stream-for-each proc (stream-cdr s)))))

(defn scale-stream [stream factor]
  "mulitply each value in stream by factor"
  (stream-map #(* % factor)
              stream))

(defn add-streams [s1 s2]
  (stream-map + s1 s2))

(defn partial-sums [s]
  "Takes a stream and returns the stream whose elements are s_0,
   s_0+s_1, s_0+s_1+s_2, etc."
  (cons-stream (stream-car s)
               (add-streams (stream-cdr s)
                            (partial-sums s))))

(defn make-tableau [transform s]
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(defn accelerated-sequence [transform s]
  (stream-map stream-car
              (make-tableau transform s)))

(defn stream-ref [s n]
  (if (= n 0)
    (stream-car s)
    (recur (stream-cdr s) (dec n))))

(defn stream-limit
  "Examines stream until two successive elements differ less than
  tolerance and returns the second of the elements"
  [s tolerance]
  (let [s0 (stream-ref s 0)
        s1 (stream-ref s 1)]
    (if (< (abs (- s1 s0)) tolerance)
      s1
      (recur (stream-cdr s) tolerance))))

(defn stream-interleave
  ([s1 s2]
     (if (stream-null? s1)
       s2
       (cons-stream (stream-car s1)
                    (stream-interleave s2 (stream-cdr s1)))))
  ([s1 s2 & r]
     (stream-interleave
      s1
      (apply stream-interleave s2 r))))

(defn stream-filter [pred stream]
  (cond (stream-null? stream) the-empty-stream
        (pred (stream-car stream)) (cons-stream (stream-car stream)
                                                (stream-filter pred (stream-cdr stream)))
        :else (stream-filter pred (stream-cdr stream))))

(defn stream-take [n s]
  (if (= n 0) the-empty-stream
      (cons-stream (stream-car s)
                   (stream-take (dec n) (stream-cdr s)))))

(defn display-stream
  ([s] (stream-for-each display-line s))
  ([n s] (display-stream (stream-take n s))))

(defn stream->seq
  ([s]
     (if (stream-null? s)
       '()
       (cons (stream-car s) (lazy-seq (stream->seq (stream-cdr s)))))))

(defn finite
  "Convert an infinite stream into a finite stream of n items"
  [n s]
  (->> s
       stream->seq
       (take n)))

(defn stream-find-index-of [item stream]
  "Find the zero-indexed index of the stream item equal to 'item' in the stream"
  (loop [index 0
         stream stream]
    (if (stream-null? stream)
      nil
      (if (= item (stream-car stream))
        index
        (recur (inc index) (stream-cdr stream))))))

(defn stream-merge-weighted [s1 s2 weight]
  (cond (stream-null? s1) s2
        (stream-null? s2) s1
        :else (let [s1car (stream-car s1)
                    s2car (stream-car s2)
                    s1weight (weight s1car)
                    s2weight (weight s2car)]
                (if (<= s1weight s2weight)
                      (cons-stream s1car (stream-merge-weighted (stream-cdr s1) s2 weight))
                      (cons-stream s2car (stream-merge-weighted s1 (stream-cdr s2) weight))))))

(defn stream-filter-pairs [pred stream]
  (if (or (stream-null? stream) (stream-null? (stream-cdr stream)))
    the-empty-stream
    (let [first-item (stream-car stream)
          second-item (stream-car (stream-cdr stream))]
      (if (pred first-item second-item)
        (cons-stream (list first-item second-item)
                     (stream-filter-pairs pred (stream-cdr stream)))
        (stream-filter-pairs pred (stream-cdr stream))))))

(defn stream-filter-triplets [pred stream]
  (if (or
       (stream-null? stream)
       (stream-null? (stream-cdr stream))
       (stream-null? (stream-cdr (stream-cdr stream))))
    the-empty-stream
    (let [first-item (stream-car stream)
          second-item (stream-car (stream-cdr stream))
          third-item (stream-car (stream-cdr (stream-cdr stream)))]
      (if (pred first-item second-item third-item)
        (cons-stream (list first-item second-item third-item)
                     (stream-filter-triplets pred (stream-cdr stream)))
        (recur pred (stream-cdr stream))))))
