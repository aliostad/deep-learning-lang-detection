(ns mastermind-kata.core-test
  (:require [clojure.test :refer :all]
            [mastermind-kata.core :as c]
            [clojure.spec.test :as st])
  (:import (mastermind_kata Game Score)))

(use-fixtures :once #(do (st/instrument)
                         (%1)
                         (st/unstrument)))

(deftest game-starts-empty
  (is (empty? (.guesses (Game. "rrrrrr")))))

(deftest can-add-guess
  (doto
    (Game. "rrrrrr")
    (.guess "rrrrrr")
    (#(is (= 1 (count (.guesses %1)))))))

(deftest adding-guess-returns-score
  (is (instance? Score (c/start-and-guess "rrrrrr" "rrrrrr"))))

(deftest aprox-correct-score
  (is (= 1 (.inexactMatches (c/start-and-guess "yyyyyr" "rbbbbb")))))

(deftest exact-matches
  (is (= 6 (.exactMatches (c/start-and-guess "rrrrrr" "rrrrrr")))))

(deftest correct-mixed-score
  (let [score (c/start-and-guess "rrrybb" "rrycyc")]
    (is (= 2 (.-exactMatches score)))
    (is (= 1 (.-inexactMatches score)))))

(deftest spec-test
  (->> (st/check ['c/start-and-guess])
       (first)
       :clojure.spec.test.check/ret
       :result
       (is true?)))
