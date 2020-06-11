(ns cities.card-test
  (:require
   [clojure.test :refer :all]
   [clojure.spec.test.alpha :as stest]
   [clojure.spec.gen.alpha :as gen]
   [cities.card :as card]
   [clojure.spec.alpha :as s]))

(deftest label
  (is (= "blue-5" (card/label (card/number :blue 5))))
  (is (= "green-wager-1" (card/label (card/wager-1 :green)))))

(deftest description
  (is (= "Blue 5" (card/description (card/number :blue 5))))
  (is (= "a Green wager card" (card/description (card/wager-1 :green)))))

(stest/instrument)
(stest/check (stest/enumerate-namespace 'cities.card))
