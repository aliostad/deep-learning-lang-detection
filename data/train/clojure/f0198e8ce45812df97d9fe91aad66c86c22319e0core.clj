(ns section-3-5-5.core
  (:require
   [clojure.core :exclude [rand next map]]
   [section-3-5-5.streams :refer :all]
   [section-3-5-5.stream-math :refer :all]
   [section-3-5-5.math :refer :all]
   [section-3-5-5.letrec :as lr])
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

(defn make-random-stream [random-init rand-update]
  (lr/letrec [random-numbers (cons-stream random-init
                                          (stream-map rand-update random-numbers))]
             random-numbers))

;; to be defined eventually, I suppose
(def system-random-init 0) ;; ignored
(defn system-random-update [_]
  (rand-int Integer/MAX_VALUE))

(def random-numbers (make-random-stream system-random-init system-random-update))

(defn map-successive-pairs [f s]
  (cons-stream
   (f (stream-car s)
      (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))

(def cesaro-stream (map-successive-pairs #(= (gcd %1 %2) 1)
                                         random-numbers))

(defn safe-div [a b]
  (if (zero? b)
    Double/POSITIVE_INFINITY
    (/ a b)))

(defn monte-carlo
  "Produces a stream of estimates of probabilities"
  [experiment-stream passed failed]
  (let [next-items (fn [passed failed]
                     (cons-stream
                      (/ (double passed) (+ passed failed))
                      (monte-carlo (stream-cdr experiment-stream) passed failed)))]
    (if (stream-car experiment-stream)
      (next-items (inc passed) failed)
      (next-items passed (inc failed)))))

(def monte-carlo-cesaro-stream
  (monte-carlo cesaro-stream 0 0))

(finite 50 monte-carlo-cesaro-stream)

(def pi
  (stream-map #(Math/sqrt (safe-div 6 %))
              monte-carlo-cesaro-stream))

(finite 1000 pi)

;; Exercise 3.81

;; the old way
;; (def rand-in-principle-with-reset
;;   (let [x (atom random-init)]
;;     (fn [directive]
;;       (case directive 
;;         :reset (fn [new-val] (swap! x (constantly new-val)))
;;         :generate (do (swap! x rand-update)
;;                       @x)))))

(defn make-generator [rand-update random-init]
  (fn stream-random-generator
    ([requests]
     (stream-random-generator requests random-init))
    ([requests current-value]
     (let [request (first (stream-car requests))]
       (cond (= request :generate)
             (cons-stream random-init
                          (stream-random-generator (stream-cdr requests) (rand-update current-value)))
             (= request :reset)
             (stream-random-generator (stream-cdr requests) (second request)))))))

;; Exercise 3.82

;;;;;;;;;;;;;;;;;
;; Balmer peak ;;
;;;;;;;;;;;;;;;;;

(defn rand-double-in-range [lower upper]
  (+ lower (* (Math/random) (- upper lower))))

(defn random-coordinate [x-upper x-lower y-upper y-lower]
  [(rand-double-in-range x-lower x-upper)
   (rand-double-in-range y-lower y-upper)])

(defn stream-of-zero-arg-fn-calls [f]
  (cons-stream (f)
               (stream-of-zero-arg-fn-calls f)))

(defn make-experiment-stream [shape-pred x-upper x-lower y-upper y-lower]
  (let [random-coordinate-stream
        (stream-of-zero-arg-fn-calls #(random-coordinate x-upper x-lower y-upper y-lower))]
    (stream-map #(apply shape-pred %) random-coordinate-stream)))

(defn estimate-integral-stream
  [shape-pred x-upper x-lower y-upper y-lower]
  (let [area-of-trial (* (- x-upper x-lower) (- y-upper y-lower))]
    (scale-stream (-> (make-experiment-stream shape-pred x-upper x-lower y-upper y-lower)
                      (monte-carlo 0 0))
                  area-of-trial)))


(defn radius-3-circle [x y]
;;  (println "(radius-3-circle " x " " y ")")
  (let [ret (<= 
             (+ (square (- x 5))
                (square (- y 7)))
             (square 3))]
    ret))


;; (finite 50 (make-experiment-stream radius-3-circle 15 -15 15 -15))

;;=> (false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false false)

(def radius-3-circle-integral-stream
  (estimate-integral-stream radius-3-circle 15 -15 15 -15)) ;= 0

;; (last (finite 100000 radius-3-circle-integral-stream))
;;=> 28.134000000000004

;; ;; integral (area) should be pi * r * r = 9 * pi = 28.274333882308138

(defn unit-circle [x y]
  (let [ret (<= 
             (+ (square x)
                (square y))
             1)]
    ret))

;; pi * r^2

(def unit-circle-integral-stream
  (estimate-integral-stream unit-circle 2 -2 2 -2)) ;= 0

;; (last (finite 100000 unit-circle-integral-stream))
;;=> 3.1248
