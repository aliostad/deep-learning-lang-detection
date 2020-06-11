;; Board module
;; Provides methods that deal with operations concerning battleship board:
;; creating board, placing ships, getting/setting state of board cells.
;; Also provides helper functions to display the board.

(ns battleship.board
    (:gen-class))

(def board-size 10)

;; Hold information about a board cell.
;; Content is one of (`:empty`, `:ship`) and keeps info about board owner's ships.
;; State is one of (`:clear`, `:hit`, `:missed`) and holds info about other player's
;; attacks.
(defrecord Cell [content state])

(def board (vec (repeat board-size (vec (repeat board-size (Cell. :empty :clear))))))

(def ships {:carrier 5
            :battleship 4
            :submarine 3
            :cruiser 2
            :patrol 1})

;; How many times do we try to place a ship before giving up.
(def ^:const max-placement-attempts 1000)

(declare placement-validator)
(declare repeat-while-nil)
(declare place-ship-randomly)
(declare set-cells)
(declare get-cells)

;; Public interface
;; ================

(defn get-cell
  "Returns cell at x y coordinates."
  [board x y]
  (nth (nth board y) x))


(defn set-cell
  "Returns board with cell at x y coordinates set to `new-state`."
  [board x y new-state]
  (let [row (nth board y)]
    (assoc board y (assoc row x new-state))))


(defn place-ship
  "Returns a board with piece placed at x y coordinates.
  `horizontal?` determines ship orientation."
  [board x y length horizontal?]
  (let [is-valid (placement-validator board x y length horizontal?)]
    (when is-valid
      (set-cells board x y length horizontal? (Cell. :ship :clear)))))

(defn create-board []  board)

(defn create-random-board
  "Returns a new board with ships randomly placed. 
  Returns `nil` if the placement algortihm did not manage to place pieces randomly."
  []
  (let [placer-fun (fn [board1 [_ ship-length]]
                       ;; Try to place the ship at random coords 
                       (when-not (nil? board1)
                                 (repeat-while-nil
                                   max-placement-attempts
                                   #(place-ship-randomly board1 ship-length))))]
    (reduce placer-fun board ships)))

;; Private
;; =======

(defn- get-cells
  "Returns vector of `n` cells starting at x y with given orientation."
  [board x y n horizontal?]
  (if horizontal?
    (subvec (nth board y) x (+ x n))
    (let [col (vec (map #(nth % x) board))]
      (subvec col y (+ y n)))))


(defn- set-cells
  "Set `n` cells starting at x y coordinates with given orientation
  to new value `val`. Returns new board."
  [board x y n horizontal? val]
  (let [update-fun (fn [board1 [x1 y1]] (set-cell board1 x1 y1 val))]
    (if horizontal?
      (reduce update-fun board (map vector (range x (+ x n)) (repeat y)))
      (reduce update-fun board (map vector (repeat x) (range y (+ y n)))))))


(defn- placement-validator
  "Returns `true` iff piece can be placed a x y coordinates with given orientation."
  [board x y length horizontal?]
  (let [cells (get-cells board x y length horizontal?)]
    (not-any? #(= (:content %) :ship) cells)))


(defn- place-ship-randomly
  "Places piece with length `n` randomly on the board. Returns new board."
  [board length]
  (let [horizontal? (= (rand-int 2) 0)
        x (rand-int (- board-size length))
        y (rand-int board-size)]
    (if horizontal?
      (place-ship board x y length horizontal?)
      (place-ship board y x length horizontal?))))

(defn- repeat-while-nil
  "Repeatedly invokes `fun` till we get a non-nil result or till `max-attempts`
  calls is reached."
  ([max-attempts fun] (first (remove nil? (repeatedly max-attempts fun))))
  ([fun] (first (remove nil? (repeatedly fun)))))


;; Display helpers 
;; ===============


(defn- display-row
  "Prints a row of the board."
  [row format-cell]
  (map format-cell row))

(defn display-board-content
  "Prints the whole game board (content, i.e. ship or empty)."
  [board]
  (let [display-map {:ship "S" :empty "."}
        format-cell #(display-map (:content %))]
    (doall (map #(println %) (map #(display-row % format-cell) board)))
    nil))

(defn display-board-state
  "Prints the whole game board (status, i.e., hit, missed or clear)."
  [board]
  (let [display-map {:clear "." :hit "H" :missed "M"}
        format-cell #(display-map (:state %))]
    (doall (map #(println %) (map #(display-row % format-cell) board)))
    nil))
