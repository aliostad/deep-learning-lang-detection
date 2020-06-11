(ns sicp.ch3.stream
  "since we are going impl our own version of force and delay"
  (:refer-clojure :excludes [force delay])
)
;; reason for failure, this need to be a macro , parameter should not be eval
(def ^:private hit (atom 0))
(def ^:private not-hit (atom 0))

(defn- log-hit-rate [pred]
      (cond pred  (swap! not-hit inc)
            :else (swap! hit inc)))

(defn memo-proc 
  [proc]
  (let [*already-run*? (atom false)
        *result* (atom false)]
    (fn []
     ;; (log-hit-rate @*already-run*?)
      (if-not @*already-run*?
        (do
          (swap! *result* (fn [_] (proc)))
          (swap! *already-run*? (fn [_] true))
          @*result*)
        @*result*))))


(defn delay-eval
  [proc]
  (memo-proc proc))


(defn force-eval
  [delay]
  (delay))

;;; construct a stream

;;; defs 
;;; given any stream , matches (stream-car (cons-stream x y) ) => x
;;; and (stream-cdr (cons-stream x y)) => y

;; (defmacro cons-proc-macro 
;;   "sytacs macro makes user have no aware of the fn wrap"
;;   [element proc]
;;   `(list ~element
;;          (delay-eval (fn [] (~@proc))))
;;   )

(defmacro cons-stream
  "sytacs macro makes user have no aware of the fn wrap"
  [x proc]
  `(list ~x (delay-eval (fn [] ~proc))))


;; (defn cons-stream 
;;   [x f]
;;   (list x (delay-eval f)))

(defn stream-car 
  [stream]
  (first stream))

;;(def ^:private the-empty-stream  (fn [] :the-empty-stream))
(def ^:private the-empty-stream  (cons-stream :the-empty-stream (fn [] :the-empty-stream)))

(defn stream-null?
  [stream]
  (= :the-empty-stream (stream-car stream)))

(defn stream-cdr
  [stream]
  (if (stream-null? stream)  stream
      (force-eval  (last stream))))

(defn stream-ref 
  [stream n]
  (if (zero? n)
    (stream-car stream)
    (stream-ref (stream-cdr stream) (dec n))))


(defn stream-for-each
  [proc stream]
  (if (stream-null? stream )
    stream
    (do (proc (stream-car stream))
        (stream-for-each (proc (stream-cdr stream))))))

(defn stream-map
  [proc stream]
  (if (stream-null? stream)
    the-empty-stream
    (cons-stream (proc (stream-car stream))
                 (stream-map proc (stream-cdr stream)))))

(defn stream-filter
  [pred stream]
  (cond (stream-null? stream) the-empty-stream
        (pred (stream-car stream))
        (cons-stream (stream-car stream)  (stream-filter pred (stream-cdr stream)))
        :else (stream-filter pred (stream-cdr stream))))

;;; book example
(defn dived-by-3?
  [x]
  (zero? (mod x 3)))

(defn stream-enumerate-interval
  [low high]
  (if (> low high)
        the-empty-stream
        (cons-stream low (stream-enumerate-interval (inc low) high))))


(defn integers-starting-from 
  [n]
  (cons-stream n  (integers-starting-from (inc n))))

(def integers (integers-starting-from 1))

(defn- divisible? 
  [x y]
  (zero? (mod x y)))

(defn sieve 
  [stream]
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter 
           #(not (divisible? %1 (stream-car stream)))
           (stream-cdr stream)))))

(def primes (sieve (integers-starting-from 2)))

(defn stream-maps 
  [proc & streams]
  (if (stream-null? (first streams))
    the-empty-stream
    (cons-stream
     (apply proc (map stream-car streams))
     (apply stream-maps (cons proc (map stream-cdr streams))))))

;;def integer in manner of church number
(defn add-stream 
  [s1 s2]
  (stream-maps + s1 s2))

(def ONES (cons-stream 1 ONES))

(def integers
  (cons-stream 1 (add-stream ONES integers)))


;;this wont work, since no delay
;; (def fibs
;;   (cons-stream 0
;;                (cons-stream 1
;;                             (add-stream (stream-cdr fibs)
;;                                         fibs))))

(def fibs
  (cons-stream 0
               (cons-stream 1
                            (add-stream (stream-cdr fibs)
                                        fibs))))

(defn- square
  [n]
  (* n n))

;;seems we cant do this in clojure recur def 

;; (defn primes-of-stream-concat
;;   []
;;   (cons-stream 2
;;                (fn [] (stream-filter  prime? (integers-starting-from 3)))))

;; (defn prime? 
;;   [n]
;;   (defn- iter
;;     [ps]
;;     (cond ((< (square (stream-car ps)) n)) true
;;           ((divisible? n (stream-car ps))) false
;;           :else (iter (stream-cdr ps))))
  
;;   (fn [] (iter primes-of-stream-concat)))

(defn mul-stream
  [s1 s2]
  (stream-maps * s1 s2))

(def factorials
  (cons-stream 1
               (mul-stream factorials
                           (stream-cdr integers))))


(defn partial-sums
  [stream]
  (if (stream-null? stream) stream
      (cons-stream (stream-car stream)
                   (add-stream (stream-cdr stream) 
                               (partial-sums stream)))))


(defn merge-stream 
  [s1 s2]
  (cond (stream-null? s1) s2
        (stream-null? s2) s1
        :else (let [s1car (stream-car s1)
                    s2car (stream-car s2)]
                (cond (< s1car s2car) 
                      (cons-stream s1car  (merge-stream (stream-cdr s1) s2))
                      
                      (> s1car s2car) 
                      (cons-stream s2car (merge-stream s1 (stream-cdr s2)))
                      
                      :else (cons-stream s1car (merge-stream (stream-cdr s1) (stream-cdr s2)))))))

(defn scale-stream 
  [stream factor]
  (stream-map (partial * factor) stream))

(def S (cons-stream 1 
                    (merge-stream (scale-stream S 2)
                                  (merge-stream (scale-stream S 3)
                                                (scale-stream S 5)))))

(defn integrate-series
  [s1 s2]
  (stream-map / s1 s2))

(def sqrt-stream
  (fn
    [x]
    (defn- average
      [x y]
      (/ (+ x y) 2))
    (defn- sqrt-improve 
      [guess x]
      (average guess (/ x guess)))
    (defn- guesses
      []
      (cons-stream 1.0 (stream-map (fn [guess] (sqrt-improve guess x))
                                   (guesses))))
  (guesses)))


;; (defn pi-summands
;;   [n]
;;   (cons-stream (/ 1.0 n)
;;                (stream-map - (pi-summands (+ n 2)))))

(defn- inner-summands 
  [n step-fn]
  (cons-stream (/ 1.0 n)
               (stream-map - (inner-summands (step-fn n) step-fn))))

(defn pi-summands
  [n]
  (inner-summands n #(+ % 2)))

(defn sqrt-summands
  [n]
  (inner-summands n inc))

(def pi-stream 
  (scale-stream (partial-sums (pi-summands 1)) 
                4))


(defn euler-transform
  "accucelorator of computing a value. e.g pi"
  [stream]
  (let [s0 (stream-ref stream 0)
        s1 (stream-ref stream 1)
        s2 (stream-ref stream 2)]
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr stream)))))


(defn make-tableau
  [transform stream]
  (cons-stream stream 
               (make-tableau transform (transform stream))))

(defn accelerated-sequence 
  [tranform stream]
  (stream-map stream-car (make-tableau tranform stream)))

(defn stream-limit
  [stream tolerance]
  (if  (> tolerance 
          ((fn abs [x] (max x (- x)))
           (- (stream-ref stream 0)
              (stream-ref stream 1)))
          )
     (stream-ref stream 0)
     (stream-limit (-> stream stream-cdr stream-cdr) tolerance)
    ))

(defn sqrt-by-stream 
  [x tolerance]
  (stream-limit (sqrt-stream x) tolerance))


