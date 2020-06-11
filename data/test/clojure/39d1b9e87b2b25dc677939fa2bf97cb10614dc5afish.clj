(ns spec-guide.fish
  (:require [clojure.spec :as s]))

(def fish-numbers {0 "Zero"
                   1 "One"
                   2 "Two"})
(s/def ::fish-number (set (keys fish-numbers)))

(s/def ::color #{"Red" "Blue" "Dun"})

(defn one-bigger? [{:keys [n1 n2]}]
  (= n2 (inc n1)))

(defn fish-number-rhymes-with-color? [{n :n2 c :c2}]
  (or
   (= [n c] [2 "Blue"])
   (= [n c] [1 "Dun"])))

(s/def ::first-line (s/and (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color)
                           one-bigger?
                           #(not= (:c1 %) (:c2 %))
                           fish-number-rhymes-with-color?))

(s/explain ::first-line [1 2 "Red" "Black"])

(s/explain ::first-line [2 1 "Red" "Red"])

(s/exercise ::first-line 5)

(defn fish-line [n1 n2 c1 c2]
  (clojure.string/join " "
                       (map #(str % " fish.")
                            [(get fish-numbers n1)
                             (get fish-numbers n2)
                             c1
                             c2])))
(s/fdef fish-line
        :args ::first-line
        :ret string?)
(s/instrument #'fish-line)

(fish-line 1 2 "Red" "Blue")

#_(fish-line 2 1 "Red" "Blue")
