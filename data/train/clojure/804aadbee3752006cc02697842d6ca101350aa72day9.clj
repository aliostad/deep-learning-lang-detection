(ns advent2016.day9
  (:require [clojure.string :as sub-stream]))

(def example-1-1 "ADVENT")
(def example-1-2 "A(1x5)BC")
(def example-1-5 "(6x1)(1x3)A")

(def example-2-2 "X(8x2)(3x3)ABCY")
(def example-2-5 "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")

(def puzzle (slurp "../day9.data"))

(defn parse-next-instruction [stream]
  (let [ins (take-while #(not= % \)) (drop 1 stream))]
    [(drop (inc (inc (count ins))) stream)
     (map #(Integer/parseInt %) (s/split (apply str ins) #"x"))]))

(defn stream->tree
  ([stream recurse?]
   (stream->tree stream recurse? "" []))

  ([stream recurse? acc result]
   (let [ch              (first stream)
         result-with-acc (conj result (list 1 acc))]
     (condp = ch
       nil result-with-acc
       \(  (let [[stream [n rep]] (parse-next-instruction stream)
                 sub-stream       (apply str (take n stream))]
             (recur (drop n stream)
                    recurse?
                    ""
                    (conj result-with-acc
                          (list rep (if recurse?
                                      (stream->tree sub-stream recurse?)
                                      sub-stream)))))
       (recur (drop 1 stream)
              recurse?
              (str acc ch)
              result)))))

(defn sum-tree [tree]
  (->> tree
       (map (fn [[rep data]]
              (* rep (if (vector? data)
                       (sum-tree data)
                       (count data)))))
       (apply +)))

(def solution1 (sum-tree (stream->tree puzzle false)))
(def solution2 (sum-tree (stream->tree puzzle true)))
