(ns practical-clojure.chpt5)

;; sequences
;; a unified way to read, write, modify any data structure that is logically a collection of items
;; hence applies to all of map, list, vector etc

(defn printall [s]
  (if (not (empty? s))
    (do
      (println (str "Item: " (first s)))
      (recur (rest s)))))

(printall [1 2 3])
(printall '(1 2 3))
(printall "hello")
(printall {:a 1, :b 2, :c 3})

(seq? [1 2 3]) ;; false - collections are not seqs, but can be easily turned into one
(seq? (seq [1 2 3])) ;; true

;; internally almost all collections just call seq on their args

(sequential? [1 2 3]) ;; true - indicates that seq will work?

;; all sequences are implemented as a singly linked list in terms of first and rest
;; the sequence ends when rest returns empty
;; aha, hence cons

;; first / rest
(cons 4 [1 2 3])

;; thought a bit confusing the conj reverses it!
(conj [1 2 3] 4)
(conj '(1 2 3) 4)

;; aha!
;; conj doesn't call seq on its args, hence when you pass it a vector, it adds to the end
;; since that is the most efficient place to add to a vector
;; for a list the most efficient place is at the front
(conj [1 2 3] 4) ;; [1 2 3 4]
(conj (seq [1 2 3]) 4) ;; (4 1 2 3)

(defn make-int-seq [max]
  (loop [acc nil n max]
    (if (zero? n)
      acc
      (recur (cons n acc) (dec n)))))

(make-int-seq 4)

;; to re-iterate
;; (first (rest))
;; (first (first (rest)))
;; this structure of a seq is the basis for lazy sequences
;; "Laziness is made possible by the observation that logically, the rest of a sequence
;; doesn't need to actually exists, provided it can be created when necessary"

;; once it has been realized it is cached for efficiency

(defn square [x]
  (do
    (println (str "Processing: " x))
    (* x x)))

;; map always returns a lazy sequence, hence the println is interleaved as the rest is calculated
(def map-result (map square '( 1 2 3 4 5 6 7 8)))
(nth map-result 2)

;; do this in the repl in stages - can see that it caches the result when you repeat it
;; see http://www.maybetechnology.com/2011/07/lazy-sequences.html

;; to create a lazy sequence either
;; 1. generate using lazy-seq
;; 2. construct using sequence generator functions

(def integers (iterate inc 0))

;; if you hold a reference then once realized it is taking up memory

;; "When writing idiomatic Clojure, one cannot use sequences too much. Any point in code where
;; there is more than one object is a candidate for using a sequence to manage the collection.
;; Doing so provides for free all the sequence functions, both built-in and user generated"
