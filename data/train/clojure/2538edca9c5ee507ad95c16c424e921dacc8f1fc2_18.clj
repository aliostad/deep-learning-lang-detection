;; Exercise 2.18
;; Define a procedure reverse that takes a list as argument and returns a list
;; of the same elements in reverse order:
;;
;;  (reverse (list 1 4 9 16 25))
;;  => (25 16 9 4 1)

(ns sicp-mailonline.exercises.2-18)

;; Note that this functionality is provided built-in by clojure.core/reverse
(defn reverse-a [values]
  (letfn [(iter [in out]
            (if (empty? in)
              out
              (recur (rest in) (cons (first in) out))))]
    (iter values '())))

;; a more idiomatic Clojure solution using reduce to manage the accumulation
(defn reverse-b [values]
  (reduce conj '() values))
