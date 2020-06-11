(ns section-3-5-1.core
  (:gen-class))

(defn enqueue [sieve n factor]
  (let [m (+ n factor)]
    (assoc sieve m (conj (sieve m) factor))))

(defn next-sieve
  "sieve is a map from the next non-prime numbers to their factors"
  [sieve candidate]
  ;; if the candidates is non-prime...
  (if-let [factors (sieve candidate)]
    (reduce #(enqueue %1 candidate %2)
            (dissoc sieve candidate)
            factors)
    (enqueue sieve candidate candidate)))

(defn primes [max]
  (apply concat (vals (reduce next-sieve {} (range 2 max)))))

(defn prime? [n] (some #(= n %) (primes (inc n))))

(defn force [delayed-object]
  (delayed-object))

(defn- already-run? [state]
  (first state))

(defn- result-of-last-run [state]
  (second state))

(defn memo-proc [proc]
  (let [state-atom (atom [false nil])]
    (fn []
      (let [state @state-atom
            already-run (already-run? state)
            result (result-of-last-run state)]
        (if (not already-run)
          (do (reset! state-atom [true (proc)])
              (result-of-last-run @state-atom))
          result)))))

(defn sum-primes [a b]
  (loop [count a accum 0]
    (cond (> count b) accum
          (prime? count) (recur (+ count 1) (+ count accum))
          :else (recur (inc count) accum))))

(defn accumulate [f first-val coll]
  (reduce f first-val coll))

(defn enumerate-interval [low high]
  (if (> low high)
      nil
      (cons low (enumerate-interval (inc low) high))))

(defn sum-primes [a b]
     (accumulate +
                 0
                 (filter prime? (enumerate-interval a b))))

(sum-primes 1 10)


(defn stream-car [stream]
  (first stream))


(defn stream-cdr [stream]
  (if (empty? (rest stream))
    nil
    (force (first (rest stream)))))

(defn stream-ref [s n]
  (if (= n 0)
    (stream-car s)
    (recur (stream-cdr s) (dec n))))

(defn stream-null? [s]
  (empty? s))

(def the-empty-stream '())

(defmacro my-delay [a]
  `(memo-proc 
    (fn []
      ~a)))

(defmacro cons-stream [a b]
  `(list ~a (my-delay ~b)))

(defn stream-map [proc s]
  (if (stream-null? s)
    the-empty-stream
    (cons-stream (proc (stream-car s))
                 (stream-map proc (stream-cdr s)))))

(defn stream-for-each [proc s]
  (if (stream-null? s)
    :done
    (do
      (proc (stream-car s))
      (stream-for-each proc (stream-cdr s)))))

(defn display [x]
  (print x))

(defn display-line [s]
  (newline)
  (display s))

(defn display-stream [s]
  (stream-for-each display-line s))

(defn stream-enumerate-interval [low high]
  (if (> low high)
    the-empty-stream
    (cons-stream
     low
     (stream-enumerate-interval (inc low) high))))

(defn stream-filter [pred stream]
  (cond (stream-null? stream) the-empty-stream
        (pred (stream-car stream)) (cons-stream (stream-car stream)
                                                (stream-filter pred (stream-cdr stream)))
        :else (stream-filter pred (stream-cdr stream))))


(stream-car (stream-filter prime? (stream-enumerate-interval 1 10000000)))

;; exercise 3.50

(defn stream-map [proc & argstreams]
  (if (empty? (first argstreams))
    the-empty-stream
    (cons-stream
     (apply proc (map stream-car argstreams))
     (apply stream-map (cons proc (map stream-cdr argstreams))))))


;; exercise 3.51

(defn show [x]
  (display-line x)
  x)

(def y (stream-enumerate-interval 0 10))
(def x (stream-map show (stream-enumerate-interval 0 10)))


(stream-ref y 5)
(stream-ref x 5)
(stream-ref x 7)

;; ex 3.52

(def sum (atom 0))
(defn accum [x]
  (swap! sum + x)
  @sum)
(def seq (stream-map accum (stream-enumerate-interval 1 20)))
(def y (stream-filter even? seq))
(defn remainder [a b]
  (rem a b))
(def z (stream-filter #(= (remainder % 5) 0)
                      seq))
(stream-ref y 7)
(display-stream z)
(display-stream seq)



