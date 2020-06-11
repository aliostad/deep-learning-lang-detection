(ns ^:figwheel-always game.core
  (:require-macros
    [cljs.core.async.macros :refer [go go-loop alt!]])
  (:require
    [cljs.reader :refer [read-string]]
    [game.board :refer [piece-fits?
                        rotate-piece
                        start-position
                        empty-board
                        get-drop-pos
                        get-rand-piece
                        get-rand-diff-piece
                        write-piece-to-board
                        write-piece-behind-board
                        create-drawable-board
                        get-filled-row-indices
                        clear-rows
                        game-over-row
                        collapse-rows
                        highlight-rows
                        write-to-board
                        n-rows
                        n-cols
                        rows-cutoff
                        next-piece-board
                        tower-height]]
    [game.rules :refer [get-points
                        level-up?
                        grav-speed
                        initial-shift-speed
                        shift-speed]]
    [game.paint :refer [size-canvas!
                        cell-size
                        draw-board!]]
    [cljs.core.async :refer [close! put! chan <! timeout unique alts!]]))

(enable-console-print!)

(def $ js/jQuery)

;;------------------------------------------------------------
;; STATE OF THE GAME
;;------------------------------------------------------------

(def state
  "The state of the game."
  (atom nil))

(defn init-state!
  "Set the initial state of the game."
  []
  (reset! state {:next-piece nil
                 :piece nil
                 :position nil
                 :board empty-board

                 :score 0
                 :level 0
                 :level-lines 0
                 :total-lines 0

                 :soft-drop false}))

(def paused? (atom false))

; required for pausing/resuming the gravity routine
(declare go-go-gravity!)

(def stop-grav (chan))
(defn stop-gravity! []
  (put! stop-grav 0))

(defn refresh-gravity! []
  (stop-gravity!)
  (go-go-gravity!))

;;------------------------------------------------------------------------------
;; Piece Control Throttling
;;------------------------------------------------------------------------------

; These channels can received boolean signals indicating on/off status.
; Duplicate signals are ignored with the (dedupe) transducer.
(def move-left-chan (chan 1 (dedupe)))
(def move-right-chan (chan 1 (dedupe)))
(def move-down-chan (chan 1 (dedupe)))

(defn manage-soft-drop!
  "Monitor move-down-chan to update the gravity speed."
  []
  (go-loop []
    (swap! state assoc :soft-drop (<! move-down-chan))
    (refresh-gravity!)
    (recur)))

(declare try-move!)

(defn animate-piece-shift!
  "Shifts a piece in the given direction until given channel is closed."
  [stop-chan dx]
  (go-loop [speed initial-shift-speed]
    (try-move! dx 0)
    (let [[value c] (alts! [stop-chan (timeout speed)])]
      (when-not (= c stop-chan)
        (recur shift-speed)))))

(defn manage-piece-shift!
  "Monitors the given shift-chan to control piece-shifting."
  [shift-chan dx]
  (let [stop-chan (chan)]
    (go-loop []
      (if (<! shift-chan)
        (animate-piece-shift! stop-chan dx)
        (put! stop-chan 0))
      (recur))))

;;------------------------------------------------------------
;; STATE MONITOR
;;------------------------------------------------------------

(defn make-redraw-chan
  "Create a channel that receives a value everytime a redraw is requested."
  []
  (let [redraw-chan (chan)
        request-anim #(.requestAnimationFrame js/window %)]
    (letfn [(trigger-redraw []
              (put! redraw-chan 1)
              (request-anim trigger-redraw))]
      (request-anim trigger-redraw)
      redraw-chan)))

(defn drawable-board
  "Draw the current state of the board."
  []
  (let [{piece :piece
         [x y] :position
         board :board} @state]
    (create-drawable-board piece x y board)))

(defn go-go-draw!
  "Kicks off the drawing routine."
  []
  (let [redraw-chan (make-redraw-chan)]
    (go-loop [board nil]
      (<! redraw-chan)
      (let [new-board (drawable-board)
            next-piece (:next-piece @state)]
        (when (not= board new-board)
          (draw-board! "game-canvas" new-board cell-size rows-cutoff)
          (draw-board! "next-canvas" (next-piece-board next-piece) cell-size))
        (recur new-board)))))

;;------------------------------------------------------------
;; Game-driven STATE CHANGES
;;------------------------------------------------------------

(defn go-go-game-over!
  "Kicks off game over routine. (and get to the chopper)"
  []
  (go
    (doseq [y (reverse (range n-rows))]
      (<! (timeout 10))
      (swap! state assoc-in [:board y] (game-over-row)))))

(defn spawn-piece!
  "Spawns the given piece at the starting position."
  [piece]
  (swap! state assoc :piece piece
                     :position start-position)

  (go-go-gravity!))

(defn try-spawn-piece!
  "Checks if new piece can be written to starting position."
  []
  (let [piece (or (:next-piece @state) (get-rand-piece))
        next-piece (get-rand-diff-piece piece)
        [x y] start-position
        board (:board @state)]

    (swap! state assoc :next-piece next-piece)

    (if (piece-fits? piece x y board)
      (spawn-piece! piece)
      (go ;exitable
        ; Show piece that we attempted to spawn, drawn behind the other pieces.
        ; Then pause before kicking off gameover animation.
        (swap! state update-in [:board] #(write-piece-behind-board piece x y %))
        (<! (timeout (grav-speed (:level @state))))
        (go-go-game-over!)))))

(defn display-points!
  []
  (.html ($ "#score") (str "Score: " (:score @state)))
  (.html ($ "#level") (str "Level: " (:level @state)))
  (.html ($ "#lines") (str "Lines: " (:total-lines @state))))


(defn update-points!
  [rows-cleared]
  (let [n rows-cleared
        level (:level @state)
        points (get-points n (inc level))
        level-lines (+ n (:level-lines @state))]

    ; update the score before a possible level-up
    (swap! state update-in [:score] + points)

    (if (level-up? level-lines)
      (do
        (swap! state update-in [:level] inc)
        (swap! state assoc :level-lines 0))
      (swap! state assoc :level-lines level-lines))

    (swap! state update-in [:total-lines] + n))


  (display-points!))

(defn collapse-rows!
  "Collapse the given row indices."
  [rows]
  (let [n (count rows)
        board (collapse-rows rows (:board @state))]
    (swap! state assoc :board board)
    (update-points! n)))

(defn go-go-collapse!
  "Starts the collapse animation if we need to, returning nil or the animation channel."
  []
  (let [board (:board @state)
        rows (get-filled-row-indices board)
        flashed-board (highlight-rows rows board)
        cleared-board (clear-rows rows board)]

    (when-not (zero? (count rows))
      (go ; no need to exit this (just let it finish)
        ; blink n times
        (doseq [i (range 3)]
          (swap! state assoc :board flashed-board)
          (<! (timeout 170))
          (swap! state assoc :board board)
          (<! (timeout 170)))

        ; clear rows to create a gap, and pause
        (swap! state assoc :board cleared-board)
        (<! (timeout 220))

        ; finally collapse
        (collapse-rows! rows)))))

(defn lock-piece!
  "Lock the current piece into the board."
  []
  (let [[x y] (:position @state)
        piece (:piece @state)
        board (:board @state)
        new-board (write-piece-to-board piece x y board)]
    (swap! state assoc :board new-board
                       :piece nil
                       :soft-drop false) ; reset soft drop
    (stop-gravity!)

    ; If collapse routine returns a channel...
    ; then wait for it before spawning a new piece.
    (if-let [collapse-anim (go-go-collapse!)]
      (go
        (<! collapse-anim)
        (<! (timeout 100))
        (try-spawn-piece!))
      (try-spawn-piece!))))

(defn apply-gravity!
  "Move current piece down 1 if possible, else lock the piece."
  []
  (let [piece (:piece @state)
        [x y] (:position @state)
        board (:board @state)
        ny (inc y)]
    (if (piece-fits? piece x ny board)
      (swap! state assoc-in [:position 1] ny)
      (lock-piece!))))

(defn go-go-gravity!
  "Starts the gravity routine."
  []
  (go-loop []
    (let [speed (grav-speed (:level @state) (:soft-drop @state))
          [_ c] (alts! [(timeout speed) stop-grav])]
      (when-not (= c stop-grav)
        (apply-gravity!)
        (recur)))))

;;------------------------------------------------------------
;; Input-driven STATE CHANGES
;;------------------------------------------------------------

(defn resume-game!
  "Restores the state of the board pre-pausing, and resumes gravity"
  []
  (go-go-gravity!)
  (reset! paused? false))

(defn pause-game!
  "Saves the current state of the board, loads the game-over animation and pauses gravity"
  []
  (stop-gravity!)
  (reset! paused? true))

(defn toggle-pause-game!
  "Toggles pause on the game board"
  []
  (if @paused?
    (resume-game!)
    (pause-game!)))

(defn try-move!
  "Try moving the current piece to the given offset."
  [dx dy]
  (let [[x y] (:position @state)
        piece (:piece @state)
        board (:board @state)
        nx (+ dx x)
        ny (+ dy y)]
    (if (piece-fits? piece nx ny board)
      (swap! state assoc :position [nx ny]))))

(defn try-rotate!
  "Try rotating the current piece."
  []
  (let [[x y] (:position @state)
        piece (:piece @state)
        board (:board @state)
        new-piece (rotate-piece piece)]
    (if (piece-fits? new-piece x y board)
      (swap! state assoc :piece new-piece))))

(defn hard-drop!
  "Hard drop the current piece."
  []
  (let [[x y] (:position @state)
        piece (:piece @state)
        board (:board @state)
        ny (get-drop-pos piece x y board)]
    (swap! state assoc :position [x ny])
    (lock-piece!)))

(def key-names {
                37 :left
                38 :up
                39 :right
                40 :down
                32 :space
                16 :shift
                80 :p})

(defn add-key-events
  "Add all the key inputs."
  []
  (let [key-name #(-> % .-keyCode key-names)
        key-down (fn [e]
                   (case (key-name e)
                     nil)
                   (when (:piece @state)
                     (case (key-name e)
                       :down  (put! move-down-chan true)
                       :left  (put! move-left-chan true)
                       :right (put! move-right-chan true)
                       :space (hard-drop!)
                       :up    (try-rotate!)
                       nil))
                   (when (#{:down :left :right :space :up} (key-name e))
                     (.preventDefault e)))
        key-up (fn [e]
                 (case (key-name e)
                   :down  (put! move-down-chan false)
                   :left  (put! move-left-chan false)
                   :right (put! move-right-chan false)
                   :p (toggle-pause-game!)
                   nil))]


    ; Add key events
    (.addEventListener js/window "keydown" key-down)
    (.addEventListener js/window "keyup" key-up)))



;;------------------------------------------------------------
;; Entry Point
;;------------------------------------------------------------

(defn init []

  (init-state!)

  (manage-soft-drop!)
  (manage-piece-shift! move-left-chan -1)
  (manage-piece-shift! move-right-chan 1)


  (size-canvas! "game-canvas" empty-board cell-size rows-cutoff)
  (size-canvas! "next-canvas" (next-piece-board) cell-size)

  (try-spawn-piece!)
  (add-key-events)
  (go-go-draw!)

  (display-points!))


($ init)
