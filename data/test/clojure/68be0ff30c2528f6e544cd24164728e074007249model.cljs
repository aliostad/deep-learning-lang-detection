(ns goban.model
  (:require [one.dispatch :as dispatch]))

(def state (atom {}))

(add-watch state :state-change
           (fn [k r o n]
             (dispatch/fire :state-change n)))

(defn next-turn [color] (if (= color :black) :white :black))

(defn update [changes
              {board :board
               turn :turn
               state :state
               :as old}]
  (let [new-board
        (reduce (fn [board [change color pos]]
                  (cond (= change :add) (assoc board pos color)
                        (= change :remove) (dissoc board pos)))
                board
                changes)
        new-turn (next-turn turn)]
    {:board new-board
     :turn new-turn
     :state :in-progress
     :last-changes changes}))

(dispatch/react-to #{:update}
                   (fn [_ changes]
                     (swap! state (partial update changes))))
