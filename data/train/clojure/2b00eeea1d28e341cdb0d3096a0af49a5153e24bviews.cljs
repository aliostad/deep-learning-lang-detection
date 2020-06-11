(ns checkers.views
  (:require [re-frame.core :as re-frame]
            [goog.events :as event]
            [checkers.draw :refer [drawBoardState]]
            [checkers.validators :refer [validMove? validJump?]]))

(defn displayTurn [turn]
  (str "It's "
       (if (= @turn "w")
         "White"
         "Red")
       "'s turn!"))

(defn clickListener
  [a]
  (event/listen a goog.events.EventType.CLICK
                #(do (re-frame/dispatch [:select [(.-offsetX %) (.-offsetY %)]])
                   (.setTimeout js/window drawBoardState 50))))

(defn move
  [board turn selected dest]
  (let [[[sxr syr] color] @selected [[dxr dyr] _] @dest sx (/ sxr 100) sy (/ syr 100) dx (/ dxr 100) dy (/ dyr 100)]
    (re-frame/dispatch [:setToggle 0])
    (if (validMove? sx sy dx dy board turn)
      (do (re-frame/dispatch [:move [color sx sy dx dy]])
        (re-frame/dispatch [:changeTurn @turn])
        (re-frame/dispatch [:select [0 0]])
      ;(re-frame/dispatch [:select [(* dx 100) (* dy 100)]])
      ))))

(defn jump
  [board turn selected dest]
  (let [[[sxr syr] color] @selected [[dxr dyr] _] @dest sx (/ sxr 100) sy (/ syr 100) dx (/ dxr 100) dy (/ dyr 100)]
    (re-frame/dispatch [:setToggle 0])
    (if (validJump? sx sy dx dy board turn)
      (do (re-frame/dispatch [:jump [color sx sy dx dy (/ (+ sx dx) 2) (/ (+ sy dy) 2)]])
        (re-frame/dispatch [:pieces @turn])
        (re-frame/dispatch [:changeTurn @turn])
        (re-frame/dispatch [:select [0 0]])
        )
      (re-frame/dispatch [:select [(* dx 100) (* dy 100)]])
      )))

(defn main-panel []
  (let [turn (re-frame/subscribe [:turn]) selected (re-frame/subscribe [:selected]) board (re-frame/subscribe [:boardState])
        dest (re-frame/subscribe [:dest]) pieces (re-frame/subscribe [:pieces])]
    [:div
     (displayTurn turn)
     (str " White has " (:w @pieces) " pieces and red has " (:r @pieces) " pieces remaining ")
     [:button {:on-click #((do (re-frame/dispatch [:initialize-db]) (.setTimeout js/window drawBoardState 50)))} "Restart"]
     (move board turn selected dest)
     (jump board turn selected dest)]))

