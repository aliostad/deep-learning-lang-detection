(ns game.strategy-test
  (:require  [clojure.test :refer [deftest testing is]]
             [clojure.spec.test.alpha :as stest]
             [game.strategy :refer :all]
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
(stest/instrument `winning-play?)
(stest/instrument `winning-plays)
(stest/instrument `blocking-plays)
(stest/instrument `forking-plays)

(deftest winning-play?-test
  (testing "You cannot win on your first play."
    (for [r [0 1 2]
          c [0 1 2]]
      (is (not (winning-play? empty-board :p1 [r c])))))
  (testing "A board with one winning play for each player."
    (let [b {[0 0] :p1
             [0 1] :p1
             [0 2] :blank   ;; a win for p1
             [1 0] :p2
             [1 1] :p2      ;; an invalid move
             [1 2] :blank   ;; a win for p2
             [2 0] :blank
             [2 1] :blank
             [2 2] :blank}] ;; not a winning move for anyone
      (is (winning-play? b :p1 [0 2]))
      (is (winning-play? b :p2 [1 2]))
      (is (not (winning-play? b :p2 [1 1])))
      (is (not (winning-play? b :p2 [2 2]))))))

(deftest winning-plays-test
  (testing "subjunctive: how many win threats given various plays"
    (let [b {[0 0] :p1     ;; invalid play
             [0 1] :blank  ;; sets up 1 win for p1
             [0 2] :blank  ;; sets up 2 wins for p1 ("fork")
             [1 0] :blank  ;; sets up 1 win for p1
             [1 1] :p2     ;; invalid play
             [1 2] :blank  ;; sets up 1 win for p1
             [2 0] :blank  ;; sets up 2 wins for p1 ("fork")
             [2 1] :blank  ;; sets up 1 win for p1
             [2 2] :p1}]   ;; invalid play
      (is (= 1 (count (winning-plays (play b :p1 [0 1]) :p1))))
      (is (= 1 (count (winning-plays (play b :p1 [1 0]) :p1))))
      (is (= 1 (count (winning-plays (play b :p1 [1 2]) :p1))))
      (is (= 1 (count (winning-plays (play b :p1 [2 1]) :p1))))
      (is (= 2 (count (winning-plays (play b :p1 [0 2]) :p1))))
      (is (= 2 (count (winning-plays (play b :p1 [2 0]) :p1)))))))

(deftest blocking-play-test
  (testing "A board with a block for p2 at [0 2]"
    (let [b {[0 0] :p1
             [0 1] :p1
             [0 2] :blank ;; here's the block
             [1 0] :blank
             [1 1] :blank
             [1 2] :blank ;; not a block
             [2 0] :p2    ;; not a valid move
             [2 1] :blank
             [2 2] :blank}]
      (is (some #{[0 2]} (blocking-plays b :p2)))
      (is (not (some #{[1 2]} (blocking-plays b :p2))))
      (is (not (some #{[2 0]} (blocking-plays b :p2)))))))

(deftest forking-play-test
  (testing "same board from winning-plays test"
    (let [b {[0 0] :p1     ;; invalid play
             [0 1] :blank  ;; sets up 1 win for p1
             [0 2] :blank  ;; sets up 2 wins for p1 ("fork")
             [1 0] :blank  ;; sets up 1 win for p1
             [1 1] :p2     ;; invalid play
             [1 2] :blank  ;; sets up 1 win for p1
             [2 0] :blank  ;; sets up 2 wins for p1 ("fork")
             [2 1] :blank  ;; sets up 1 win for p1
             [2 2] :p1}]
      (is (= 2 (count (forking-plays b :p1))))
      (is (some #{[0 2]} (forking-plays b :p1)))
      (is (some #{[2 0]} (forking-plays b :p1)))
      (is (not (some #{[0 0]
                       [0 1]
                       [1 0]
                       [1 1]
                       [1 2]
                       [2 1]
                       [2 2]} (forking-plays b :p1)))))))

(deftest fork-blocking-1-test
  (let [b {[0 0] :p1
           [0 1] :blank
           [0 2] :blank ;; a bad play for p2: it gives p1 a fork
           [1 0] :blank ;; a better play for p2: it threatens to win
           [1 1] :p2
           [1 2] :blank
           [2 0] :blank
           [2 1] :blank
           [2 2] :p1}]
    (testing "correct board setup"
      (is (not-empty (forking-plays (play b :p2 [0 2]) :p1)))
      (is (not-empty (winning-plays (play b :p2 [1 0]) :p2))))
    (testing "should not suggest a play that sets up a fork"
      (is (not (some #{0 2} (fork-blocking-plays-1 b :p2))))
      (is (some #{[1 0]} (fork-blocking-plays-1 b :p2))))))

(deftest fork-blocking-2-test
  (let [b {[0 0] :p1
           [0 1] :blank
           [0 2] :blank ;; A forking play for p1.
           [1 0] :blank
           [1 1] :p2
           [1 2] :blank
           [2 0] :blank ;; Another forking play for p1.
           [2 1] :blank
           [2 2] :p1}]
    ;; The right move for p2 is to threaten to win, with a fork-block-1 move.
    ;; But we can still use the board to test for fork-block-2.
    (is (some #{[0 2]} (fork-blocking-plays-2 b :p2)))
    (is (some #{[2 0]} (fork-blocking-plays-2 b :p2)))
    ;; A better move, but not in the fork-blocking-2 class.
    (is (not (some #{[1 0]} (fork-blocking-plays-2 b :p2)) ))))

(deftest center-play-test
  (testing "center available"
    (let [b empty-board]
      (is #{[1 1]} (center-play empty-board :p1))))
  (testing "center unavailable"
    (let [b (play empty-board :p1 [1 1])]
      (is (empty? (center-play b :p2))))))

(deftest opposite-corner-plays-test
  (testing "no opponent occupied corners"
    (is (empty? (opposite-corner-plays empty-board :p1))))
  (testing "opponent in corners, opposite is available"
    (let [b {[0 0] :p1
             [0 1] :blank
             [0 2] :blank ;; A forking play for p1.
             [1 0] :blank
             [1 1] :p2
             [1 2] :blank
             [2 0] :blank ;; Another forking play for p1.
             [2 1] :blank
             [2 2] :blank}]
      (is (some #{[2 2]} (opposite-corner-plays b :p2)))))
  (testing "opponent in corners, but no corner to play in"
    (let [b {[0 0] :p1
             [0 1] :blank
             [0 2] :p2
             [1 0] :blank
             [1 1] :blank
             [1 2] :blank
             [2 0] :p2
             [2 1] :blank
             [2 2] :p1}]
      (is (empty? (opposite-corner-plays b :p1))))))

(deftest empty-corner-plays-test
  (testing "all corners available"
    (is (= 4 (count (empty-corner-plays empty-board :p1)) )))
  (testing "no corners available"
    (let [b {[0 0] :p1
             [0 1] :blank
             [0 2] :p1
             [1 0] :blank
             [1 1] :blank
             [1 2] :blank
             [2 0] :p1
             [2 1] :blank
             [2 2] :p1}]
      (is (empty? (empty-corner-plays b :p2)))))
  (testing "one opponent corner available"
    (let [b {[0 0] :p1
             [0 1] :blank
             [0 2] :p2
             [1 0] :blank
             [1 1] :blank
             [1 2] :blank
             [2 0] :blank
             [2 1] :blank
             [2 2] :blank}]
      (is (some #{[2 2]} (empty-corner-plays b :p2))))))

(deftest empty-side-plays-test
  (testing "all middle-sides available"
    (is (= 4 (count (empty-side-plays empty-board))))
    (is (some #{[0 1]} (empty-side-plays empty-board)))
    (is (some #{[1 0]} (empty-side-plays empty-board)))
    (is (some #{[1 2]} (empty-side-plays empty-board)))
    (is (some #{[2 1]} (empty-side-plays empty-board))))
  (testing "no middle-sides available"
    (let [b {
             [0 0] :blank
             [0 1] :p2
             [0 2] :blank
             [1 0] :p1
             [1 1] :blank
             [1 2] :p2
             [2 0] :blank
             [2 1] :p1
             [2 2] :blank}]
      (is (empty? (empty-side-plays b :p1))))))
