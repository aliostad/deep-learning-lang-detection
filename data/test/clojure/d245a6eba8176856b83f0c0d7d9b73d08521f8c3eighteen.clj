(ns adventofcode1.eighteen
  "http://adventofcode.com/2016/day/4"
  (:require
   [clojure.spec :as s]
   [clojure.spec.gen :as gen]
   [clojure.spec.test :as stest]
   [com.gfredericks.test.chuck.generators :as gen']
   [clojure.test.check :as tc]
   [clojure.test.check.generators :as tcgen]
   [clojure.test.check.properties :as tcprop]

   [clojure.core.match :refer [match]]

   spyscope.core
   adventofcode1.spec-test-instrument-debug))


(s/def ::cell #{\^ \.})
(s/def ::parents (s/coll-of ::cell :count 3))
(s/def ::row (s/coll-of ::cell))

(s/fdef next-char
  :args (s/cat :parents ::parents)
  :ret  ::cell)

(defn next-char
  [parents]
  (cond
    (= parents [\^ \^ \.]) \^
    (= parents [\. \^ \^]) \^
    (= parents [\^ \. \.]) \^
    (= parents [\. \. \^]) \^
    :else \.))

(s/fdef next-row-1
        :args (s/cat :row ::row)
        :ret ::row)


(defn next-row-1
  [row]
  (if (< (count row) 3) []
      (concat [(next-char (take 3 row))]
              (next-row-1 (rest row)))))

(s/fdef next-row
        :args (s/cat :row ::row)
        :ret ::row)

(defn next-row
  [row]
  (->> (concat [\.] row [\.])
       next-row-1))

(defn main
  ([s](main 10 (seq s)))
  ([n s](main (count (filter #{\.} (seq s))) n (seq s)))
  ([acc n row]
   ;; (println (clojure.string/join row))
   ;; n<2 since we count the input row too
   (if (< n 2) acc
       (let [res (next-row row)
             safe (count (filter #{\.} res))]
         (recur (+ acc safe) (dec n) res)))))


(defn puzzle-a
  []
  (main 40 (seq ".^^^.^.^^^^^..^^^..^..^..^^..^.^.^.^^.^^....^.^...^.^^.^^.^^..^^..^.^..^^^.^^...^...^^....^^.^^^^^^^")))

(defn puzzle-b
  []
  (main 400000 (seq ".^^^.^.^^^^^..^^^..^..^..^^..^.^.^.^^.^^....^.^...^.^^.^^.^^..^^..^.^..^^^.^^...^...^^....^^.^^^^^^^")))


;; (clojure.spec.test/instrument)
