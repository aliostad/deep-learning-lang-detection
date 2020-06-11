(ns project-euler-solutions.core
  (:require [clojure.math.numeric-tower :as math]
            [clojure.spec :as s]
            [clojure.spec.test :as stest]))


;; Problem 4 - Largest palindrome product
(defn is-palindrome?
  "Returns true if 'num' is a palindrome."
  [num]
  (= (str num) (clojure.string/reverse (str num))))

(defn largest-palindrome
  "Returns the largest palindrome made from the product of two
  'digit'-digit numbers."
  [digit]
  (let [min-product (math/expt 10 (dec digit))
        max-product (dec (* min-product 10))
        all-elements (range min-product (inc max-product))]
    (apply max
           (filter is-palindrome?
                   (for [x1 all-elements x2 all-elements] (* x1 x2))))))

;; Problem 7 - 10001st prime
(defn is-prime?
  "Returns true if 'num' is prime."
  [num]
  (not (some #(= 0 (mod num %))
             (range 2 (inc (math/floor (math/sqrt num)))))))

(defn find-prime
  "Returns the 'i-th' prime number."
  [i-th]
  (nth (filter is-prime? (drop 2 (range))) (dec i-th)))


;; Function specs
(s/def ::check-pos-int (s/and (s/cat :arg int?) #(pos? (:arg %))))

(s/fdef project-euler-solutions.core/largest-palindrome
  :args ::check-pos-int
  :ret int?)
(stest/instrument `largest-palindrome)

(s/fdef project-euler-solutions.core/find-prime
  :args ::check-pos-int
  :ret #(.isProbablePrime (new java.math.BigInteger (str %)) 100))
(stest/instrument `find-prime)


(defn -main [& args]
  (do
    (println "Problem 4:" (largest-palindrome 3))
    (println "Problem 7:" (find-prime 10001))))
