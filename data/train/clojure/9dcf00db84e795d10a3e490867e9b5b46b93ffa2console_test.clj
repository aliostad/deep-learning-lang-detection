(ns game.console-test
  (:require [game.console :refer :all]
            [game.board :refer :all]
            [clojure.test :refer [is testing deftest]]
            [clojure.spec.test.alpha :as stest]))

(stest/instrument `glyph)

(deftest glyph-test
  (let [match-up {:p1 {:name "Me" :mark "X"}
                  :p2 {:name "You" :mark "O"}}]
    (testing "blanks become friendly coordinates (i.e. the numbers 1-9)"
      (let [b empty-board
            read-glyph #(glyph b :p1 match-up %)]
        (is (= (map str (range 1 10))                          ;; integers 1-9 as strings
               (map read-glyph (sort (keys empty-board)))))))   ;; the glyphs of coordinates in order
    (testing "Players' marks are glyphed correctly"
      (let [b  {[0 0] :blank
                [0 1] :blank
                [0 2] :blank
                [1 0] :p1
                [1 1] :p1
                [1 2] :p1
                [2 0] :p2
                [2 1] :p2
                [2 2] :p2}
            read-glyph #(glyph b :p1 match-up %)]
        (is (every? #(= "X" %) [(read-glyph [1 0]) (read-glyph [1 1]) (read-glyph [1 2])]))
        (is (every? #(= "O" %) [(read-glyph [2 0]) (read-glyph [2 1]) (read-glyph [2 2])]))))))
