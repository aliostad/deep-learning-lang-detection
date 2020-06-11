(ns clojure-ttt.ui-spec
  (:require [speclj.core :refer :all]
        [clojure-ttt.ui :refer :all]))

(describe "Manage the input from the user and display appropriate messages."
  (it "Basic prompt accepts and returns input."
    (should= "Test" (with-in-str "Test" (prompt-for-input (with-out-str "Test the prompt.")))))

  (it "Welcomes the player."
    (should= "Welcome to tic-tac-toe.\n" (with-out-str (welcome-message))))

  (it "There are 0 human players."
    (should= 0 (with-in-str "0" (how-many-humans))))
  (it "There is 1 human player."
    (should= 1 (with-in-str "1" (how-many-humans))))
  (it "There are 2 human players."
    (should= 2 (with-in-str "2" (how-many-humans))))

  (it "Accepts X as the piece should return X."
    (should= "X" (with-in-str "X" (get-piece))))
  (it "Accepts O as the piece should return O."
    (should= "O" (with-in-str "O" (get-piece))))
  (it "Accepts x as the piece should return X."
    (should= "X" (with-in-str "x" (get-piece))))
  (it "Accepts o as the piece should return O."
    (should= "O" (with-in-str "o" (get-piece))))

  (it "Gets move 1 for player2"
    (should= 1 (with-in-str "1" (get-move "player2"))))
  (it "Gets move 5 for player1"
    (should= 5 (with-in-str "5" (get-move "player1"))))
  ; (it "Sends an error message if get-move is given a letter."
  ;   (should= (with-out-str (input-error)) (with-in-str "q" (get-move "player1")))


  (it "Displays the winner is Player 1."
    (should= "The winner is Player 1!!! Perhaps you'd like to play again.\n"
      (with-out-str (winner-message "Player 1"))))
  (it "Displays the winner is Player 2."
    (should= "The winner is Player 2!!! Perhaps you'd like to play again.\n"
      (with-out-str (winner-message "Player 2"))))
  (it "Displays there has been a tie."
    (should= "There seems to have been a tie, you should play again.\n" 
      (with-out-str (tie-message)))))

(describe "Error occurs."
  (it "Tells the user there was an input error."
    (should= "Invalid input.\n" (with-out-str (input-error)))))

(describe "Rendering Board"

  (it "Empty board should look empty"
    (should= (str "___|___|___\n"
                  "___|___|___\n"
                  "   |   |   \n") (with-out-str (render-board {}))))

  (it "Should fill in the appropriate spaces automatically."
    (should= (str "_X_|_O_|_X_\n"
                  "_O_|_X_|_O_\n"
                  "   |   |   \n")
      (with-out-str (render-board {1 "X" 2 "O" 3 "X" 4 "O" 5 "X" 6 "O"} )))))
