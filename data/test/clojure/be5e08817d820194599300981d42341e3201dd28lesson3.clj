(ns sicp-exercises.lesson3
  (:require [sicp-exercises.lesson1]
            [sicp-exercises.graphics :as g]
            [sicp-exercises.pairs]
            [sicp-exercises.queue]
            [sicp-exercises.constraints]
            [sicp-exercises.circuits]
            )
  (:import (sicp_exercises.pairs Pair))
  (:use [sicp-exercises.pairs]
        [sicp-exercises.queue]
        [sicp-exercises.constraints]
        [sicp-exercises.circuits]))

;; Withdraw examples
(defn new-withdraw []
  (let [balance (atom 100)]
    (fn withdraw [amount]
      (if (> @balance amount)
        (do
          (swap! balance #(- % amount))
          balance)
        "Insuficient funds"))))

;; Exercise 3.1
(defn make-accumulator [initial-value]
  (let [accumulator (atom initial-value)]
    (fn [amount]
      (swap! accumulator #(+ % amount))
      @accumulator)))

(defn show-accumulators[]
  (let [A (make-accumulator 5)]
    (println (A 10))
    (println (A 10))))

;; Exercise 3.2
(defn make-monitored[f]
  (let [internal-counter (atom 0)]
    (fn dispatch[arg]
      (cond
        (= arg 'how-many-calls) @internal-counter
        (= arg 'reset-count) (reset! internal-counter 0)
        :else
          (do
            (swap! internal-counter inc)
            (f arg))))))

;; Exercise 3.3 and 3.4
(defn make-account [balance password]
  (let [ inner-balance (atom balance)
         wrong-pass-counter (atom 0)
         withdraw (fn [amount]
                    (if (>= balance amount)
                      (do
                        (swap! inner-balance #(- % amount))
                        @inner-balance)))

         deposit (fn [amount]
                   (swap! inner-balance #(+ % amount))
                   @inner-balance)

         call-the-cops (fn [args]
                         (reset! wrong-pass-counter 0)
                         (println "SOMEONE CALL THE COPS!!!! STOLEN PASSWORD!!!"))

         dispatch (fn [pass m]
                    (if (= pass password)
                      (do
                        (reset! wrong-pass-counter 0)
                        (cond
                          (= m 'withdraw) withdraw
                          (= m 'deposit) deposit
                          :else (throw (Exception. "Unkwnown request -- MAKE-ACCOUNT"))))
                      (do
                        (swap! wrong-pass-counter inc)
                        (if (> @wrong-pass-counter 7)
                          call-the-cops
                          (throw (Exception. "Incorrect password"))))
                      ))]
    dispatch))

;; Exercise 3.5
(defn monte-carlo [trials experiment]
  (loop [trials-remaining trials
         trials-passed 0]
    (cond
      (== trials-remaining 0) (/ trials-passed trials)
      (experiment) (recur (dec trials-remaining) (inc trials-passed))
      :else        (recur (dec trials-remaining) trials-passed))))

(defn random [ini end]
  (let [span (- end ini)]
    (+ ini (* span (rand)))))

(defn cesaro-test[]
  (== (sicp-exercises.lesson1/gcd (int (random 1 10000)) (int (random 1 10000))) 1))

(defn estimate-pi [trials]
  (Math/sqrt (/ 6 (monte-carlo trials cesaro-test))))

(defn estimate-integral [P x1 x2 y1 y2 trials]
  (let [predicate (fn []
                    (let [x (random x1 x2)
                          y (random y1 y2)]
                      (P x y)))
        length (- x2 x1)
        width (- y2 y1)]
    (* length width (monte-carlo trials predicate))))

(defn show-estimate-integral[]
  (let [circle-3 (fn [x y]
                   (<= (+ (Math/pow (- x 5) 2) (Math/pow (- y 7) 2)) 9))
        circle-1 (fn [x y]
                   (<= (+ (Math/pow x 2) (Math/pow y 2)) 1))
        ]
    (println "Area of the circle with radious 3= " (estimate-integral circle-3 2.0 8.0 4.0 10.0 1000000))
    (println "Pi estimation using unit circle= " (estimate-integral circle-1 -1.0 1.0 -1.0 1.0 10000000))
    ))

;; Exercise 3.6
(defn make-random-generator []
  (let [ current (atom 1)
         a 1664525
         b 1013904223
         m (Math/pow 2 32)
         generate (fn []
                    (do
                      (swap! current #(rem (+ (* a %) b) m))
                      @current))

         set-new (fn [value]
                   (reset! current value))]

    (fn [arg]
      (cond
        (= 'generate arg) (generate)
        (= 'reset) set-new))))

;; Exercise 3.7
(defn make-joint [account old-password new-password]
  (fn [pass m]
    (if (= pass new-password)
      (account old-password m)
      (throw (Exception. "Incorrect password")))))

;; Exercise 3.8
(defn make-f []
  (let [ counter (atom 1) ]
    (fn [n]
      (do
        (swap! counter dec)
        (- (* @counter n))))))

(defn show-f[]
  (let [ f1 (make-f)
         f2 (make-f)]
    (println "F1: " (+ (f1 0) (f1 1)))
    (println "F2: " (+ (f2 1) (f2 0)))))

;; Exercise 3.17
(defn count-pairs-wrong [x]
  (if (not (is-pair? x))
    0
    (+ (count-pairs-wrong (.getCar x))
       (count-pairs-wrong (.getCdr x))
       1)))

(defn count-pairs[x]
  (loop [ to-test #{x}
          tested #{}]
    (if (= (count to-test) 0)
      (count tested)
      (let [extracted (first to-test)]
        (if (and (is-pair? extracted) (not (tested extracted)))
          (recur (conj (conj (disj to-test extracted) (.getCar extracted)) (.getCdr extracted)) (conj tested extracted))
          (recur (disj to-test extracted) tested))))))

(defn show-count-pairs[]
  (let [
        test-pair (pair-from-list '(a b c d))
         pair1 (Pair. 'a (Pair. 'b nil))
         pair2 (Pair. pair1 pair1)
         ]
    (println "Wrong count (right result): " (count-pairs-wrong test-pair))
    (println "Wrong count (wrong result): " (count-pairs-wrong pair2))
    (println "Right count: " (count-pairs test-pair))
    (println "Right count: " (count-pairs pair2))
    ))

;; Exercise 3.18
(defn loops? [p]
  (loop [ to-test #{p}
          tested-cdrs #{}]
    (if (= (count to-test) 0)
      false
      (let [extracted (first to-test)]
        (cond
          (and (is-pair? extracted) (tested-cdrs extracted)) true
          (and (is-pair? extracted) (not (tested-cdrs extracted))) (recur (conj (conj (disj to-test extracted) (.getCar extracted)) (.getCdr extracted)) (conj tested-cdrs extracted))
          :else (recur (disj to-test extracted) tested-cdrs))))))

(defn show-loops[]
  (let [ test-pair (pair-from-list '(a b c d))
         pair1 (Pair. 'a (Pair. 'b nil))]

    (.setCdr (.getCdr pair1) pair1)
    (println "Loops in test-pair: " (loops? test-pair))
    (println "Loops in pair1: " (loops? pair1))))

;; Exercise 3.19
(defn loops-cte? [p]
  (loop [ to-test #{p} ]
    (if (= (count to-test) 0)
      false
      (let [extracted (first to-test)]
        (cond
          (and (is-pair? extracted) (= :loop_indicator (.getCar extracted)))
            true
          (and (is-pair? extracted) (not (= :loop_indicator (.getCar extracted))))
            (do
              (.setCar extracted :loop_indicator)
              (recur (conj (disj to-test extracted) (.getCdr extracted))))
          :else
            (recur (disj to-test extracted)))))))

(defn show-loops-cte[]
  (let [ test-pair (pair-from-list '(a b c d))
         pair1 (Pair. 'a (Pair. 'b nil))]

    (.setCdr (.getCdr pair1) pair1)
    (println "Loops in test-pair: " (loops-cte? test-pair))
    (println "Loops in pair1: " (loops-cte? pair1))))

;; Exercise 3.21
(defn print-queue[q]
  (let [ print-list (fn print-list[l]
                      (loop [ current l
                              result "" ]
                        (if (nil? current)
                          result
                          (recur (.getCdr current) (str result (.getCar current) " "))
                          ))) ]

    (if (nil? q)
      "( )"
      (str "( " (print-list (front-ptr q)) ")"))))


(defn show-print-queue[]
  (let [q1 (make-queue)]
    (println (print-queue q1))
    (println (print-queue (insert-queue! q1 'a)))
    (println (print-queue (insert-queue! q1 'b)))
    (println (print-queue (delete-queue! q1)))
    (println (print-queue (delete-queue! q1)))
    ))

;; Exercise 3.22
(defn make-proc-queue[]
  (let [ front-ptr (atom nil)
         rear-ptr (atom nil)
         is-empty? (fn []
                     (nil? front-ptr))

         pushq! (fn [v]
                  (let [ new-pair (Pair. v nil) ]
                    (if (nil? @rear-ptr)
                      (do
                        (reset! rear-ptr new-pair)
                        (reset! front-ptr new-pair))
                      (do
                        (.setCdr @rear-ptr new-pair)
                        (reset! rear-ptr new-pair)))))

         popq! (fn []
                 (let [ result @front-ptr ]
                   (reset! front-ptr (.getCdr result))
                   (.getCar result)
                   ))

         peekq (fn []
                 (.getCar @front-ptr))

         deleteq (fn []
                   (if (nil? @front-ptr)
                     (throw (Exception. "Tried to remove an item from an empty queue"))
                     (reset! front-ptr (.getCdr @front-ptr))))

         printq (fn []
                  (str "("
                       (loop [current @front-ptr
                              result ""]
                         (if (nil? current)
                           result
                           (recur (.getCdr current) (str result (.getCar current) " " ))))
                       ")" ))

         dispatch (fn [m]
                    (cond
                      (= m 'is-empty?) is-empty?
                      (= m 'pushq!) pushq!
                      (= m 'popq!) popq!
                      (= m 'peekq) peekq
                      (= m 'deleteq) deleteq
                      (= m 'printq) printq
                      :else (throw (Exception. "Unknown operation for procedural queue"))))]
    dispatch))

(defn show-proc-queue []
  (let [q1 (make-proc-queue)]
    (println "Q1: " ((q1 'printq)))
    ((q1 'pushq!) :a)
    (println "Q1: " ((q1 'printq)))
    ((q1 'pushq!) :b)
    (println "Q1: " ((q1 'printq)))
    (println "Pop Q1: " ((q1 'popq!)))
    (println "Q1: " ((q1 'printq)))
    (println "Pop Q1: " ((q1 'popq!)))
    (println "Q1: " ((q1 'printq)))
  ))

;; Exercise 3.23
(defn make-dequeue []
  (Pair. nil nil))

(defn front-dequeue [q]
  (.getCar q))

(defn rear-dequeue [q]
  (.getCdr q))

(defn empty-dequeue? [q]
  (nil? (front-dequeue q)))

(defn set-front-dequeue! [q v]
  (.setCar q v))

(defn set-rear-dequeue! [q v]
  (.setCdr q v))

(defn print-dequeue [queue]
  (str "( "
       (loop [current (front-dequeue queue)
              result ""]
         (if (nil? current)
           result
           (recur (.getCdr current) (str result (.getCar (.getCar current)) " ")))) ")"))

(defn front-insert-dequeue! [queue item]
  (let [ new-pair (Pair. item nil)
         indirection (Pair. new-pair nil)]
    (if (empty-queue? queue)
      (do
        (set-front-dequeue! queue indirection)
        (set-rear-dequeue! queue indirection)
        queue)
      (do
        (println "Setting indirection")
        (.setCdr indirection (front-dequeue queue))
        (println "Setting new car. FD: " (front-dequeue queue) )
        (.setCdr (.getCar (front-dequeue queue)) indirection)
        (set-front-dequeue! queue indirection)
        queue
        ))))

(defn rear-insert-dequeue! [queue item]
  (let [ new-pair (Pair. item nil)
         indirection (Pair. new-pair nil)]
    (if (empty-queue? queue)
      (do
        (set-front-dequeue! queue indirection)
        (set-rear-dequeue! queue indirection)
        queue)
      (do
        (.setCdr (rear-dequeue queue) indirection)
        (.setCdr new-pair (rear-dequeue queue))
        (set-rear-dequeue! queue indirection)
        queue))))

(defn front-delete-dequeue! [queue]
  (if (empty-queue? queue)
    (throw (Exception. "DELETE! called with an empty queue"))
    (do
      (set-front-dequeue! queue (.getCdr (front-dequeue queue)))
      (.setCdr (front-dequeue queue) nil)
      queue
      )))

(defn rear-delete-dequeue! [queue]
  (if (empty-queue? queue)
    (throw (Exception. "DELETE! called with an empty queue"))
    (let [ but-last-item (.getCdr (.getCar (rear-dequeue queue))) ]
      (set-rear-dequeue! queue but-last-item)
      (.setCdr but-last-item nil)
      queue
      )))

(defn show-double-linked[]
  (let [ q1 (make-dequeue) ]
    (println "Q1: " (print-dequeue q1))
    (front-insert-dequeue! q1 :m)
    (front-insert-dequeue! q1 :f)
    (rear-insert-dequeue! q1 :r)
    (println "Q1: " (print-dequeue q1))
    (rear-delete-dequeue! q1)
    (println "Q1: " (print-dequeue q1))
    (front-delete-dequeue! q1)
    (println "Q1: " (print-dequeue q1))
    ))

;; Exercise 3.26
(defn make-tree-table []
  (let [ local-table (Pair. '*table* nil)

         lookup-node (fn lookup-node [key1 current]
                           (let [ current-key (.getCar (.getCar current))
                                  left (.getCar (.getCdr current))
                                  right (.getCdr (.getCdr current)) ]
                             (cond
                               (= current-key key1) (.getCdr (.getCar current))
                               (< (compare key1 current-key) 0) (if (nil? left)
                                                      false
                                                      (lookup-node key1 left))
                               (> (compare key1 current-key) 0) (if (nil? right)
                                                      false
                                                      (lookup-node key1 right)))))

         lookup (fn lookup [key1]
                  (if (nil? (.getCdr local-table))
                    false
                    (lookup-node key1 (.getCdr local-table))))

         make-empty-node (fn make-empty-node[key1 value]
                           (Pair. (Pair. key1
                                         value)
                                  (Pair. nil
                                         nil)))

         insert-in-node! (fn insert-in-node![key1 value current]
                           (let [ current-key (.getCar (.getCar current))
                                  left (.getCar (.getCdr current))
                                  right (.getCdr (.getCdr current)) ]
                             (cond
                               (= current-key key1) (.setCdr (.getCar current) value)
                               (< (compare key1 current-key) 0) (if (nil? left)
                                                      (.setCar (.getCdr current) (make-empty-node key1 value))
                                                      (insert-in-node! key1 value left))

                               (> (compare key1 current-key) 0) (if (nil? right)
                                                      (.setCdr (.getCdr current) (make-empty-node key1 value))
                                                      (insert-in-node! key1 value right)))))

         insert! (fn insert! [key1 value]
                   (let [ root (.getCdr local-table) ]
                     (if (nil? root)
                       (.setCdr local-table (make-empty-node key1 value))
                       (insert-in-node! key1 value root))))

         dispatch (fn dispatch [m]
                    (cond
                      (= m 'lookup-proc) lookup
                      (= m 'insert-proc) insert!
                      :else (throw (Exception. "Unknown operation for tree table"))))]
    dispatch))

(defn show-tree-table[]
  (let [ tree-table (make-tree-table) ]
    ((tree-table 'insert-proc) :math :+)
    ((tree-table 'insert-proc) :letters :a)
    ((tree-table 'insert-proc) :aircraft :plane)
    ((tree-table 'insert-proc) :zealots :fenix)
    (println "Value for key :math = " ((tree-table 'lookup-proc) :math))
    (println "Value for key :aircraft = " ((tree-table 'lookup-proc) :aircraft))))

;; Exercise 3.29 (Composed OR gate)
(defn composed-or [i1 i2 o]
  (let [ a (make-wire)
         b (make-wire)
         c (make-wire) ]
    (inverter i1 a)
    (inverter i2 b)
    (probe 'and-i1 a)
    (probe 'and-i2 b)
    (probe 'and-output c)
    (and-gate a b c)
    (inverter c o)))

(defn show-composed-or[]
  (let [ input-1 (make-wire)
         input-2 (make-wire)
         output-1 (make-wire)]

    (probe 'input1 input-1)
    (probe 'input2 input-2)
    (probe 'composed output-1)
    (composed-or input-1 input-2 output-1)
    (set-signal! input-1 0)
    (set-signal! input-2 1)
    (println "Propagating signal.....")
    (propagate)
    (println "Output signal (0 OR 1): " (get-signal output-1))
    (set-signal! input-1 0)
    (set-signal! input-2 0)
    (println "Propagating signal.....")
    (propagate)
    (println "Output signal (0 OR 0): " (get-signal output-1))
    ))

;; Exercise 3.33
(defn averager [a b c]
  (let [ s (make-connector)
         d (make-connector) ]
    (adder a b s)
    (multiplier d c s)
    (constant 2 d)
    'ok))

(defn show-averager[]
  (let [ v1 (make-connector)
         v2 (make-connector)
         result1 (make-connector)
         v3 (make-connector)
         v4 (make-connector)
         result2 (make-connector) ]
    (const-probe "Input1: " v1)
    (const-probe "Input2: " v2)
    (const-probe "Result: " result1)
    (averager v1 v2 result1)
    (set-value! v1 12 'user)
    (set-value! v2 8 'user)
    (const-probe "Input3: " v3)
    (const-probe "Input3: " v4)
    (const-probe "Result2: " result2)
    (averager v4 v3 result2)
    (set-value! v4 10 'user)
    (set-value! result2 6 'user)
    ))

;; Exercise 3.36
(defn squarer [a b]
  (letfn [ (process-new-value []
                              (if (has-value? b)
                                (if (< (get-value b) 0)
                                  (throw (Exception. (str "Square less than 0 -- SQUARER" (get-value b))))
                                  (set-value! a
                                              (Math/sqrt (get-value b))
                                              me))
                                (set-value! b
                                            (* (get-value a) (get-value a))
                                            me)))

           (process-forget-value []
                                 (forget-value! a me)
                                 (forget-value! b me)
                                 (process-new-value))

           (me [request]
               (cond
                 (= request 'I-have-a-value) (process-new-value)
                 (= request 'I-lost-my-value) (process-forget-value)
                 :else (throw (Exception. "Unknown request --- SQUARER")))) ]
    (connect a me)
    (connect b me)
    me))

(defn show-squarer[]
  (let [ v1 (make-connector)
         v2 (make-connector)
         result1 (make-connector)
         result2 (make-connector) ]
    (const-probe "Input1: " v1)
    (const-probe "Input2: " v2)
    (const-probe "Result: " result1)
    (const-probe "Result2: " result2)
    (squarer v1 result1)
    (set-value! v1 12 'user)
    (squarer v2 result2)
    (set-value! result2 25 'user)
    ))

;; Exercise 3.37
(defn c+ [x y]
  (let [z (make-connector)]
    (adder x y z)
    z))

(defn c- [x y]
  (let [z (make-connector)]
    (adder z y x)
    z))

(defn c* [x y]
  (let [z (make-connector)]
    (multiplier x y z)
    z))

(defn c-div [x y]
  (let [z (make-connector)]
    (multiplier y z x)
    z))

(defn cv [x]
  (let [z (make-connector)]
    (constant x z)
    z))

(defn celsius-farenheit-converter [x]
  (c+ (c* (c-div (cv 9.0) (cv 5.0))
          x)
      (cv 32)))

(defn show-temp-converters[]
  (let [ C (make-connector)
         F (celsius-farenheit-converter C) ]
    (const-probe "Celsius temperature: " C)
    (const-probe "Farenheit temperature: " F)
    (set-value! C 27 'user)))

;; Theory section 3.5
(def the-empty-stream nil)

(defn memo-proc [proc]
  (let [ already-run? (atom false)
         result (atom false) ]
    (fn []
      (if (not @already-run?)
        (do
          (reset! result (proc))
          (reset! already-run? true)
          @result)
        @result))))

(defmacro delayed [expression]
  (list 'memo-proc (list 'fn [] expression)))

(defn forced [expression]
  (expression))

(defmacro cons-stream [expression1 expression2]
  (list 'Pair. expression1
        (list 'delayed expression2)))

(defn stream-car [stream]
  (.getCar stream))

(defn stream-cdr [stream]
  (forced (.getCdr stream)))

(defn stream-null? [stream]
  (nil? stream))

(defn stream-ref [s n]
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))))

(defn stream-map-single [proc s]
  (if (stream-null? s)
    nil
    (cons-stream (proc (stream-car s))
                 (stream-map-single proc (stream-cdr s)))))

(defn stream-for-each [proc s]
  (if (stream-null? s)
    'done
    (do
      (proc (stream-car s))
      (stream-for-each proc (stream-cdr s)))))

(defn stream-filter [pred stream]
  (cond
    (stream-null? stream) the-empty-stream
    (pred (stream-car stream)) (cons-stream (stream-car stream)
                                            (stream-filter pred
                                                           (stream-cdr stream)))
    :else (stream-filter pred (stream-cdr stream))))

(defn display-line [x]
  (println x))

(defn display-stream [s]
  (stream-for-each display-line s))

(defn stream-enumerate-interval [low high]
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (inc low) high))))

(defn show-streams []
  (let [ str1 (stream-enumerate-interval 4 10) ]
    (println "The sequence: " str1)
    (println "The forced sequence: ")
    (display-stream str1)
    (display-stream (stream-filter #(= 0 (rem % 2)) str1))
    (display-stream (stream-map-single #(* % 20) str1))
    ))

;; Exercise 3.50
(defn stream-map [proc & argstreams]
  (if (stream-null? (first argstreams))
          the-empty-stream
          (cons-stream
            (apply proc (map stream-car argstreams))
            (apply stream-map
                   (cons proc (map stream-cdr argstreams))))))

(defn show-stream-map[]
  (let [
         str1 (stream-enumerate-interval 1 5)
         str2 (stream-enumerate-interval 6 10)
         str3 (stream-enumerate-interval 11 15) ]
    (display-stream (stream-map + str1 str2 str3))))

;; Exercise 3.51
(defn show [x]
  (println x)
  x)

(defn show-evaluation-order []
  (let [x (stream-map show (stream-enumerate-interval 0 10)) ]
    (println "Printing the value for the 5th element" (stream-ref x 5))
    (println "Printing the value for the 7th element" (stream-ref x 7))))

;; Exercise 3.52
(defn show-exercise-3-52 []
  (let [ sum (atom 0)
         accum (fn [x]
                 (println "Accumulating for x = " x)
                 (reset! sum (+ x @sum))
                 @sum)
         sequ (stream-map accum (stream-enumerate-interval 1 20))
         y (stream-filter even? sequ)
         z (stream-filter #(= (rem % 5) 0) sequ) ]

    (println "The value of @sum is " @sum)
    (println "The 7th element: " (stream-ref y 7))
    (println "The value of @sum is " @sum)
    (display-stream z)
    (println "The value of @sum is " @sum)
    ))


;; Theory section 3.5.2
(defn integers-starting-from [n]
  (cons-stream n (integers-starting-from (+ n 1))))

(defn sieve [stream]
  (cons-stream
    (stream-car stream)
    (sieve (stream-filter
             (fn [x]
               (not (= 0 (rem x (stream-car stream)))))
             (stream-cdr stream)))))

(def primes (sieve (integers-starting-from 2)))

(def ones (cons-stream 1 ones))

(defn add-streams [s1 s2]
  (stream-map + s1 s2))

(def integers (cons-stream 1 (add-streams ones integers)))

(def fibs (cons-stream 0
                       (cons-stream 1
                                    (add-streams (stream-cdr fibs)
                                                 fibs))))

(defn scale-stream [stream factor]
  (stream-map (fn [x] (* x factor)) stream))

(def doubled (cons-stream 1 (scale-stream doubled 2)))

;; Exercise 3.53
(def s (cons-stream 1 (add-streams s s)))

;; Exercise 3.54
(defn mul-streams [s1 s2]
  (stream-map * s1 s2))

(def factorials (cons-stream 1 (mul-streams (stream-cdr integers) factorials)))

;; Exercise 3.55
(defn partial-sums [s]
  (cons-stream 1 (add-streams (stream-cdr s) (partial-sums s))))

;; Exercise 3.56
(defn merge-stream [s1 s2]
  (cond
    (stream-null? s1) s2
    (stream-null? s2) s1
    :else (let [ s1car (stream-car s1)
                 s2car (stream-car s2) ]
            (cond
              (< s1car s2car) (cons-stream s1car (merge-stream (stream-cdr s1) s2))
              (> s1car s2car) (cons-stream s2car (merge-stream s1 (stream-cdr s2)))
              :else           (cons-stream s1car (merge-stream (stream-cdr s1)
                                                        (stream-cdr s2)))))))

(def S (cons-stream 1 (merge-stream (scale-stream S 2) (merge-stream (scale-stream S 3) (scale-stream S 5)))))

;; Exercise 3.58
(defn expand-stream [nu den radix]
  (cons-stream
    (quot (* nu radix) den)
    (expand-stream (rem (* nu radix) den) den radix)))

;; Exercise 3.59
(defn display-limited-stream [s i e]
  (display-stream (stream-map #(stream-ref s %) (stream-enumerate-interval i e))))

(defn integrate-series [stream]
  (mul-streams stream (stream-map #(/ 1 %) integers)))

(def exp-series
  (cons-stream 1 (integrate-series exp-series)))

(declare sine-series)

(def cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))

(def sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; Exercise 3.60
(defn mul-series [s1 s2]
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
                 (add-streams
                   (scale-stream (stream-cdr s2) (stream-car s1))
                   (scale-stream (stream-cdr s1) (stream-car s2)))
                 (mul-series (stream-cdr s1) (stream-cdr s2))
                 )))

(def product (add-streams (mul-series cosine-series cosine-series) (mul-series sine-series sine-series)))

(defn evaluate[series x n]
  (loop [ result 0
          i 0
          s series ]
    (if (= i n)
      result
      (recur
        (+ result (* (stream-car s) (Math/pow x i)))
        (inc i)
        (stream-cdr s)))))

;; Exercise 3.61
(defn invert-unit-series [s1]
  (cons-stream 1.0
               (scale-stream (mul-series (stream-cdr s1)
                                         (invert-unit-series s1))
                             -1.0)))

;; (display-limited-stream (invert-unit-series integers) 0 10)
;; (evaluate (mul-streams (invert-unit-series integers) integers) 1.0 20)

;; Exercise 3.62
(defn div-series[s1 s2]
  (if (= (stream-car s2) 0)
    (throw (Exception. "Trying to divide by zero"))
    (mul-streams s1
                 (invert-unit-series s2))))

(def tangent-stream (div-series sine-series cosine-series))

;; TODO: Exercises 3.61 and 3.62 don't throw the appropriate results, but the code
;; seems pretty straightforward. Will have to revisit again in the future.

;; Theory 3.5.3
(defn sqrt-improve [guess x]
  (/ (+ guess (/ x guess)) 2))

(defn sqrt-stream [x]
  (let [ guesses (atom nil)]
    (reset! guesses (cons-stream 1.0
                                 (stream-map #(sqrt-improve % x)
                                             @guesses)))
    @guesses))

(defn pi-stream[]
  (let [ pi-summands (fn pi-summands[n]
                       (cons-stream (/ 1.0 n)
                                    (stream-map - (pi-summands (+ n 2)))))]
    (scale-stream (partial-sums (pi-summands 1)) 4)
    ))


(defn euler-transform[s]
  (let [s0 (stream-ref s 0)
        s1 (stream-ref s 1)
        s2 (stream-ref s 2)]
    (cons-stream (- s2 (/ (Math/pow (- s2 s1) 2)
                         (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))


(defn make-tableau[transform s]
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(defn accelerated-sequence [transform s]
  (stream-map stream-car
              (make-tableau transform s)))


;; Exercise 3.64
(defn stream-limit [stream tolerance]
  (loop [last-value 1000000
         s stream]
    (let [current-value (stream-car s)]
      (if (< (Math/abs (- current-value last-value)) tolerance)
        current-value
        (recur current-value (stream-cdr s))))))

(defn sqrt-tol [x tolerance]
  (stream-limit (sqrt-stream x) tolerance))


;; Exercise 3.65
(defn ln2-stream []
  (let [ ln2-summands (fn ln2-summands[n]
                        (cons-stream (/ 1.0 n)
                                     (stream-map - (ln2-summands (inc n)))))]
    (partial-sums (ln2-summands 1))))

(defn show-ln2[]
  (stream-limit (accelerated-sequence euler-transform (ln2-stream)) 0.00001))

;; Theory 3.5.3
(defn stream-interleave[s1 s2]
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (stream-interleave s2 (stream-cdr s1)))))

(defn pairs[s t]
  (cons-stream
   (list (stream-car s) (stream-car t))
   (stream-interleave
    (stream-map #(list (stream-car s) %)
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

;; Exercise 3.67
(defn all-pairs[s t]
  (cons-stream (list (stream-car s) (stream-car t))
               (stream-interleave
                (stream-interleave
                 (stream-map #(list (stream-car s) %)
                             (stream-cdr t))
                 (stream-map #(list % (stream-car t))
                             (stream-cdr s)))

                (all-pairs (stream-cdr s) (stream-cdr t)))))

(defn show-all-pairs[]
  (display-limited-stream (all-pairs integers integers) 0 20))

;; Exercise 3.68
(defn pairs-single-row[s t]
  (stream-interleave
   (stream-map #(list (stream-car s) %)
               t)
   (pairs-single-row (stream-cdr s) (stream-cdr t))))

;; Exercise 3.69
(defn most-triples[s t u]
  (cons-stream (list (stream-car u) (stream-car s) (stream-car t))
               (stream-interleave (stream-interleave (stream-map #(list (stream-car u) (stream-car s) %) (stream-cdr t))
                                                     (stream-map #(list (stream-car u) % (stream-car t)) (stream-cdr s)))
                                  (stream-interleave (stream-map #(list (stream-car u) (first %) (second %)) (pairs (stream-cdr s) (stream-cdr t)))
                                                     (most-triples (stream-cdr s) (stream-cdr t) (stream-cdr u))))))

(defn triples[s t u]
  (stream-filter #(and (<= (first %) (second %)) (<= (second %) (second (rest %)))) (most-triples s t u)))


(defn pythagorean-triples[]
  (stream-filter #(= (+ (* (first %) (first %)) (* (second %) (second %))) (second (rest %))) (triples integers integers integers)))

;; Exercise 3.70
(defn merge-weighted [s1 s2 weight]
  (cond
    (stream-null? s1) s2
    (stream-null? s2) s1
    :else (let [ s1car (stream-car s1)
                 s2car (stream-car s2) ]
            ;;(println "Comparing [" s1car "] with weight= " (weight s1car) " with [" s2car "] with weight " (weight s2car))
            (cond
              (<= (weight s1car) (weight s2car)) (cons-stream s1car (merge-weighted (stream-cdr s1)
                                                                                   s2
                                                                                   weight))
              (> (weight s1car) (weight s2car)) (cons-stream s2car (merge-weighted s1
                                                                                   (stream-cdr s2)
                                                                                   weight))))))

(defn weighted-pairs[s t weight]
  (cons-stream (list (stream-car s) (stream-car t))
               (merge-weighted
                (stream-interleave
                 (stream-map #(list (stream-car s) %)
                             (stream-cdr t))
                 (stream-map #(list % (stream-car t))
                             (stream-cdr s)))

                (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
                weight)))


(defn sum-ordered[]
  (weighted-pairs integers
                  integers
                  #(+ (first %) (second %))))

(defn special-sum-stream[]
  (let [ not-divisible (stream-filter #(and (not= (rem % 2) 0)
                                            (not= (rem % 3) 0)
                                            (not= (rem % 5) 0))
                                      integers)]
    (stream-filter #(< (first %) (second %))
                   (weighted-pairs not-divisible
                                   not-divisible
                                   #(+ (* 2.0 (first %)) (* 3.0 (second %)) (* 5.0 (first %) (second %)))))))

(display-limited-stream (special-sum-stream) 0 10)

;; Exercise 3.71
(defn ramanujan-numbers[]
  (let [weight #(+ (* (first %) (first %) (first %))
                   (* (second %) (second %) (second %)))
        tripled-stream (stream-filter #(< (first %) (second %))
                                      (weighted-pairs integers
                                                      integers
                                                      weight))
        ramanujan-stream (fn ramanujan-stream[s]
                           (let [s0 (stream-ref s 0)
                                 s1 (stream-ref s 1)]
                              (if (= (weight s0) (weight s1))
                               (cons-stream (weight s0) (ramanujan-stream (stream-cdr s)))
                               (ramanujan-stream (stream-cdr s)))))]
    (ramanujan-stream tripled-stream)))


;; Exercise 3.73
(defn integral[integrand initial-value dt]
  (let [ integ (atom nil)]
    (reset! integ (cons-stream initial-value
                               (add-streams (scale-stream integrand dt)
                                            @integ)))
      @integ))

(defn RC [R C dt]
  (fn RC1 [i-stream v0]
    (add-streams (scale-stream i-stream R)
                 (integral (scale-stream i-stream (/ 1 C))
                           v0
                           dt))))

;; Exercise 3.74
(defn sign-change-detector[v2 v1]
  (cond
    (and (< v1 0) (>= v2 0)) 1
    (and (< v2 0) (>= v1 0)) -1
    :else 0))

(defn make-zero-crossings[input-stream last-value]
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))

(defn show-crossings[]
  (let [sense-data cosine-series
        zero-crossings (make-zero-crossings sense-data 0)
        zero-crossings-alt (stream-map sign-change-detector (stream-cdr sense-data) sense-data)]

    (println "--------------------- Origin --------------------------")
    (display-limited-stream cosine-series 1 20)
    (println "--------------------- z-cross --------------------------")
    (display-limited-stream zero-crossings 1 20)
    (println "--------------------- z-cross-alt --------------------------")
    (display-limited-stream zero-crossings-alt 1 20)
    ))

;; Exercise 3.76
(defn smooth [stream]
  (let [avg-x (/ (+ (stream-ref stream 0) (stream-ref stream 1)) 2)]
    (cons-stream avg-x
                 (smooth (stream-cdr stream)))))

(defn show-smoothed-cross[]
  (let [sense-data cosine-series
        zero-crossings (make-zero-crossings (smooth sense-data) 0)]
    (println "--------------------- Origin --------------------------")
    (display-limited-stream (smooth sense-data) 1 20)
    (println "--------------------- z-cross --------------------------")
    (display-limited-stream zero-crossings 1 20)
    ))

;; Theory 3.5.4
;; TODO: The current implementation of lazy streams in the exercises has some problems
;; regarding the maximum number of function calls. The following calculation of the value
;; of e works as expected (though the error in this number of iterations is huge):
;;
;;  (stream-ref (solve identity 1 0.001) 50)
;;
;; but the same exact execution for as low as 80 iterations raise an StackOverflow error.
;; The problem most probably lies in a malfunction of the "delayed" function that stands
;; for Scheme's "delay" function in these exercises (or maybe the memoization function).
;; This problem will require careful examination, so the rest of the Exercises of this
;; section will be delayed until this problem has been dealt with.
(defn integral [delayed-integrand initial-value dt]
  (let [ integ (atom nil)]
    (reset! integ (cons-stream initial-value
                               (let [integrand (forced delayed-integrand)]
                                 (add-streams (scale-stream integrand dt)
                                              @integ))))
    @integ))

(defn solve [f y0 dt]
  (letfn [(y [] (integral (delayed (dy)) y0 dt))
          (dy [] (stream-map f (y))) ]
    (y)))


