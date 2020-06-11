(ns section-3-5-4.core
  (:require
   [clojure.core :exclude [delay force]]
   [section-3-5-4.streams :refer :all]
   [section-3-5-4.letrec :as lr])
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

;;
;; Differential equations
;;
;; Mapping component applies f to the input signal, linked in a feedback loop to an integrator
;;
;; dy/dt = f(y)
;;

(defn integral-eager [integrand initial-value dt]
  "Sum across a series, assuming that each entry in 'integrand'
  represents a time period increased by 't' from the time before.
  Returns a stream of the sum of the initial stream, where each
  entry represents the next sum after a time delta of 'dt'"
  (lr/letrec [inte (cons-stream initial-value
                                (add-streams (scale-stream integrand dt)
                                             inte))]
    inte))

;; (defn solve-diff-eq-bad [f y0 dt]
;;  (lr/letrec [y (integral-orig dy y0 dt)
;;              dy (stream-map f y)]
;;    y))


(defn integral-delayed [integrand-ref initial-value dt]
  "Sum across a series, assuming that each entry in 'integrand'
  represents a time period increased by 't' from the time before.
  Returns a stream of the sum of the initial stream, where each
  entry represents the next sum after a time delta of 'dt'"
  (lr/letrec [inte (cons-stream initial-value
                                (let [integrand @integrand-ref]
                                  (add-streams (scale-stream integrand dt)
                                               inte)))]
             inte))

;; dy/dt = f(y)

(defn solve-diff-eq [f y0 dt]
  (let [dy-ref (promise)
        y (integral-delayed dy-ref y0 dt)]
    (deliver dy-ref (stream-map f y))
    y))

(stream-ref (solve-diff-eq identity 1 0.001) 1000)
;;=> 2.716923932235896

;; Exercise 3.77

(defn integral-eager-2 [integrand initial-value dt]
  (cons-stream initial-value
               (if (stream-null? integrand)
                 the-empty-stream
                 (integral-eager-2 (stream-cdr integrand)
                                   (+ (* dt (stream-car integrand))
                                      initial-value)
                                   dt))))

(defn integral-delayed-2 [integrand-ref initial-value dt]
  (cons-stream initial-value
               (let [integrand @integrand-ref]
                 (if (stream-null? integrand)
                   the-empty-stream
                   (integral-eager-2 (stream-cdr integrand)
                                     (+ (* dt (stream-car integrand))
                                        initial-value)
                                     dt)))))

;; Exercise 3.78

(def scale-stream-by-ref)

(defn solve-2nd [a b dt y0 dy0]
  (let [ddy-ref (promise)
        dy (integral-delayed ddy-ref dy0 dt)
        y (integral-eager dy y0 dt)]
    (deliver ddy-ref  (add-streams (scale-stream dy a)
                                   (scale-stream y b)))
    y))

;; Exercise 3.79

(defn rlc [r l c dt]
  (fn [vc0 il0]
    (let [dil-ref (promise)
          il (integral-delayed dil-ref il0 dt)
          dvc (scale-stream il (/ -1 c))
          vc (integral-eager dvc vc0 dt)]
      (deliver dil-ref (add-streams (scale-stream vc (/ 1 l))
                                    (scale-stream il (/ (* -1 r)))))
      [vc il])))

(let [[[s1 s2]] ((rlc 1 1 0.2 0.1) 10 0)]
     ;; woohoo
     )

