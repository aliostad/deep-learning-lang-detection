;; Exercise 3.55
;; Define a procedure partial-sums that takes as argument a stream S and returns
;; the stream whose elements are S0, S0+S1, S0+S1+S2, ...  For example,
;; (partial-sums integers) should be the stream 1,3,6,10,15,...

(ns sicp-mailonline.exercises.3-55
  (:require [sicp-mailonline.examples.3-5-1 :as strm]
            [sicp-mailonline.exercises.3-50 :refer [stream-map]]))

(defn- add-streams [s1 s2]
  (stream-map + s1 s2))

(defn partial-sums [s]
  (add-streams s
               (strm/cons-stream 0
                                 (partial-sums s))))
