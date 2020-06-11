;; GCD.

(defn gcd  [a b]
  (if (zero? b)
    a
    (recur b (mod a b))))

;; Square Root.

(defn sqrt [n] (Math/sqrt n))

;; Random Number Generator represented as a computational object
;; with local, mutable and independent state (that is why we used
;; atoms here).

(defn random []
  (let [x (atom (rand-int 1000000000))]
    (fn [] (reset! x (rand-int 1000000000)))))

;; Stream (infinite sequence) of random numbers.

(def random-numbers
  (repeatedly #((random))))

;; Monte Carlo method.

(defn monte-carlo [experiment-as-stream passed failed]
  (letfn [(next [passed failed]
            (cons (/ passed (+ passed failed))
                  (lazy-seq (monte-carlo (rest experiment-as-stream)
                                         passed
                                         failed))))]
    (if (first experiment-as-stream)
      (next (inc passed) failed)
      (next passed (inc failed)))))

;; Experiment - approximating `pi` with Caesaro test.
;; Stream (infinite sequence) of coprime numbers.

(defn map-successive-pairs [f stream]
  (cons (f (first stream) (first (rest stream)))
        (lazy-seq (map-successive-pairs f (rest (rest stream))))))

(def caesaro-stream
  (map-successive-pairs #(= (gcd %1 %2) 1) random-numbers))

(def pi
  (map #(sqrt (/ 6.0 %))
       (monte-carlo caesaro-stream 0 0)))

(println (last (take 1000000 pi)))
