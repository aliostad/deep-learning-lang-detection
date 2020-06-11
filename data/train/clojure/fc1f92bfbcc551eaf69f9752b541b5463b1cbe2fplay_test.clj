(ns game.play-test
  (:require  [clojure.test :refer [deftest testing is]]
             [game.players :refer [ask-for-move]]
             [game.referee :refer [Referee begin]]
             [game.board :refer :all]
             [clojure.spec.alpha :as s]
             [clojure.spec.test.alpha :as stest])
  (:import game.players.FormidableComputer
           game.console.ConsolePlayer))

(stest/instrument `ask-for-move)
(stest/instrument `game.referee/introduce-player)
(stest/instrument `game.referee/mark-player)
(stest/instrument `game.referee/round)

(deftest data-access-test
  (let [human (ConsolePlayer. "Robert" "X")
        computer (FormidableComputer. "Robbie" "O")]
    (is (:name human) "Robert")
    (is (:name computer) "Robbie")
    (is (:mark human) "X")
    (is (:mark computer) "O")))

(deftest smart-computer-test
  (let [artoo (FormidableComputer. "R2-D2" "X")]
    (testing "a computer going first plays center"
      (is (= [1 1] (ask-for-move artoo empty-board :p1))))))

(deftest optimality-test
  (testing "two computers should play to a tie"
    (let [artoo (FormidableComputer. "R2-D2" "X")
          ship (FormidableComputer. "GSV Anticipation of a New Lover's Arrival, The" "O")
          referee (reify Referee
                     (introduce [_ _] nil)
                     (nudge [_ _] nil)
                     (announce [_ _ _] nil)
                     (conclude [_ outcome _] outcome)
                     (display [_ _ _ _] nil))]
      (is (= :tie (begin referee {:p1 artoo, :p2 ship})))
      #_(dotimes [n 20]
        (is :tie (begin referee {:p1 artoo :p2 ship}))))))

