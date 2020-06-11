(ns advent-of-code.day-4
  (:require [clojure.spec :as s]
            [clojure.spec.test :as stest]
            [digest]))

; http://adventofcode.com/2015/day/4

(def input-base "iwrupvqb")
(def input (map #(str input-base %)
                (range)))

(defn hash-qualifies? [a-hash num-zeroes]
  (= (take num-zeroes a-hash)
     (repeat num-zeroes \0)))

(s/fdef hash-qualifies?
  :args (s/cat :a-hash string?
               :num-zeroes nat-int?)
  :ret boolean?)

(stest/instrument `hash-qualifies?)

(defn md5-until-num-zeroes [num-zeroes]
  (first (drop-while #(not (hash-qualifies? (% :hash) num-zeroes))
                     (map (fn [msg]
                            {:input msg
                             :hash  (digest/md5 msg)})
                          input))))

(def part-1
  (md5-until-num-zeroes 5))

(def part-2
  (md5-until-num-zeroes 6))

(comment

  (digest/md5 "foo")


  part-1
  part-2
  )

