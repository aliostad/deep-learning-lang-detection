(ns triboard.game-loop
  (:require-macros
    [cljs.core.async.macros :refer [go go-loop alt!]])
  (:require
    [cljs.core.async :as async :refer [put! chan <! >!]]
    [triboard.ai.ai :as ai]
    [triboard.logic.game :as game]
    [triboard.store :as store]))


(def animation-delay 500)
(def ai-move-delay 1000)

(defn- ai-computation
  "Run the computation of the AI asynchronously:
   * Wait 500ms to start (animation might be frozen otherwise)
   * Wait 1s to play the move (avoid moves being played too fast)"
  [game]
  (go
    (<! (async/timeout animation-delay))
    (let [ai-chan (go (ai/find-best-move game))]
      (<! (async/timeout ai-move-delay))
      (<! ai-chan))))

(defn- handle-game-event!
  [msg]
  (store/swap-game!
    (case msg
      :new-game (fn [_] (game/new-game))
      :restart game/restart-game
      :undo game/undo-player-move)))

(defn- start-game-loop
  "Manage transitions between player moves, ai moves, and generic game events"
  []
  (let [play-events (chan 1 (filter #(not @store/ai-player?)))
        game-events (chan 1)]
    (go
      (while true
        (let [play-chan (if @store/ai-player?
                          (ai-computation @store/game)
                          play-events)]
          (alt!
            game-events ([msg] (handle-game-event! msg))
            play-chan ([coord] (store/swap-game! game/play-at coord))
            ))))
    {:play-events play-events
     :game-events game-events}))


;; -----------------------------------------
;; Public API
;; -----------------------------------------

(defonce game-loop (start-game-loop))
(defn send-play-event! [e] (put! (game-loop :play-events) e))
(defn send-game-event! [e] (put! (game-loop :game-events) e))
