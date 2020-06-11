(ns game.board-test
  (:require  [clojure.test :refer [deftest testing is]]
             [clojure.spec.test.alpha :as stest]
             [game.board :refer :all]))

(stest/instrument `cell)
(stest/instrument `cells)
(stest/instrument `row)
(stest/instrument `rows)
(stest/instrument `col)
(stest/instrument `cols)
(stest/instrument `neg-diag)
(stest/instrument `pos-diag)
(stest/instrument `diags)
(stest/instrument `winning-triple)
(stest/instrument `game-over)
(stest/instrument `play)

(deftest getters-test
  (let [b {[0 0] :blank
           [0 1] :blank
           [0 2] :blank
           [1 0] :p1
           [1 1] :p1
           [1 2] :p1
           [2 0] :p2
           [2 1] :p2
           [2 2] :p2}]
    (testing "rows"
      (let [coords (map keys (rows b))]
        ;; Every row should have the same first coordinate.
        (for [row coords]
          (is (apply = (map first row))))
        ;; Every row should have distinct second coordinates.
        (for [row coords]
          (is (distinct (map second row))))
        (let [marks (map vals (rows b))]
          ;; In the example board, all marks in a row are equal.
          (for [row marks]
            (is (apply = row))))))
    (testing "cols"
      (let [coords (map keys (cols b))]
        ;; Every column should have distinct first coordinates.
        (for [col coords]
          (is (distinct (map first col))))
        ;; Every column should have the same second coordinates.
        (for [col coords]
          (is (apply = (map second col))))
        ;; In the example board, all marks in a col are distinct.
        (let [marks (map vals (cols b))]
          (for [col marks]
            (is (distinct col))))))
    (testing "diagonals"
      (testing "negative diagonal"
        (let [coords (keys (neg-diag b))]
          ;; Coordinates of a negative diagonal match.
          (for [coord coords]
            (is (apply = coord))))
        (let [marks (vals (sort (neg-diag b)))] ;; NOTE: This happens to sort in the order ;; From the sample board.               ;; one would expect, but it feels fragile.
          (is (= marks '(:blank :p1 :p2)))))
      (testing "positive diagonal"
        (let [coords (keys (pos-diag b))]
          ;; Coordinates of a positive diagonal sum to 2.
          (for [coord coords]
            (is (= 2 (+ (first coord) (second coord))))))
        (let [marks (vals (sort (pos-diag b) ))] ;; NOTE: See previous.
          ;; From the sample board.
          (is (= marks '(:blank :p1 :p2))))))))

(deftest winning-triple-test
  (testing "triples"
    (let [b {[0 0] :p1
             [0 1] :p1
             [0 2] :p1
             [1 0] :blank
             [1 1] :blank
             [1 2] :blank
             [2 0] :p1
             [2 1] :p1
             [2 2] :p2}]
      (is (winning-triple (row b 0)))
      (is (not (winning-triple (row b 1))))
      (is (not (winning-triple (row b 2)))))))

(deftest game-over-test
  (testing "ongoing"
    (let [ongoing-game {[0 0] :p1
                        [0 1] :p1
                        [0 2] :blank
                        [1 0] :p2
                        [1 1] :p2
                        [1 2] :blank
                        [2 0] :p1
                        [2 1] :p2
                        [2 2] :blank}]
      (is (not (game-over ongoing-game)))))
  (testing "wins"
    (let [p1-win {[0 0] :p1 ;; Row win by p1
                  [0 1] :p1
                  [0 2] :p1
                  [1 0] :p2
                  [1 1] :p2
                  [1 2] :p1
                  [2 0] :p2
                  [2 1] :blank
                  [2 2] :blank}]
      (is (= (game-over p1-win) :p1)))
    (let [p2-win {[0 0] :p2 ;; Diagonal win by p2
                  [0 1] :p2
                  [0 2] :p1
                  [1 0] :p1
                  [1 1] :p2
                  [1 2] :p2
                  [2 0] :p1
                  [2 1] :blank
                  [2 2] :p2}]
      (is (= (game-over p2-win) :p2))))
  (testing "ties"
    (let [tie-game {[0 0] :p1
                    [0 1] :p1
                    [0 2] :p2
                    [1 0] :p2
                    [1 1] :p2
                    [1 2] :p1
                    [2 0] :p1
                    [2 1] :p2
                    [2 2] :p1}]
      (is (= (game-over tie-game) :tie)))))

;; TODO: Specify that for any board, the number of 1s minus the number of 2s is 0 or 1.
;; TODO: Move from small sets of test cases to generative tests.

(deftest play-test
  (testing "the coordinate is unmarked, therefore playable"
    (let [b (play empty-board :p1 [0 0])]
      (is (= :p1 (first (cells b))))
      (is (and (apply = (rest (cells b)))
               (= :blank (first (rest (cells b)))))))
    )
  (testing "the coordinate is marked, therefore unplayable"
    (let [tie-game {[0 0] :p1
                    [0 1] :p1
                    [0 2] :p2
                    [1 0] :p2
                    [1 1] :p2
                    [1 2] :p1
                    [2 0] :p1
                    [2 1] :p2
                    [2 2] :p1}]
      (for [r [0 1 2]
            c [0 1 2]]
        (is (not (or (not (play tie-game :p1 [r c]))
                     (not (play tie-game :p2 [r c])))))))))
