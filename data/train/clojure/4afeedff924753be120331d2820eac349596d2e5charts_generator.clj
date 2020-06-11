(ns org.gamer.log.business.charts-generator
  (:use [incanter core stats charts])
  (:require [org.gamer.log.business.statistics-engine :as stats])
  (:import (java.io ByteArrayOutputStream
                    ByteArrayInputStream)))

; Chart of normal distribution 
(defn gen-hist-png
  [avg-str sd-str]
    (let [size 1000 
          m (if (nil? avg-str)
              0
              (Double/parseDouble avg-str))
          s (if (nil? sd-str)
              1
              (Double/parseDouble sd-str))
          samp (sample-normal size
                    :mean m
                    :sd s)
          chart (histogram
                  samp
                  :title "Normal distribution of rounds"
                  :x-label (str "Rounds count = " size
                      ", AVG = " m
                      ", SD = " s))
          out-stream (ByteArrayOutputStream.)
          in-stream (do
                      (save chart out-stream)
                      (ByteArrayInputStream.
                        (.toByteArray out-stream)))]
      in-stream))


; Chart of a game over players stats
(defn gen-game-players-bar-chart [game]  
  (let [game-results (stats/scores-game-over-players game)
        players (mapv (fn [player] (player 0)) game-results)
        scores  (mapv (fn [player] (player 1)) game-results)
        chart (bar-chart players scores
                          :title (str "Top twenty players for: " game)
                          :y-label "Scores"
                          :x-label "Players"
                          :vertical false)
        out-stream (ByteArrayOutputStream.)
        in-stream (do
                    (save chart out-stream)
                    (ByteArrayInputStream.
                      (.toByteArray out-stream)))]
    in-stream))

; Chart of a player over games stats
(defn gen-player-games-bar-chart [player]  
  (let [player-results (stats/scores-player-over-games player)
        games (mapv (fn [game] (game 0)) player-results)
        scores  (mapv (fn [game] (game 1)) player-results)
        chart (bar-chart games scores
                         :title (str "All scores for player: " player)
                         :y-label "Scores"
                         :x-label "Games")
        out-stream (ByteArrayOutputStream.)
        in-stream (do
                    (save chart out-stream)
                    (ByteArrayInputStream.
                      (.toByteArray out-stream)))]
    in-stream))

; Chart of a server over games stats
(defn gen-server-games-bar-chart [server]  
  (let [server-results (stats/scores-server-over-games server)
        games (mapv (fn [game] (game 0)) server-results)
        scores  (mapv (fn [game] (game 1)) server-results)
        chart (bar-chart games scores
                         :title (str "Average scores in the server: " server)
                         :y-label "Scores"
                         :x-label "Games")
        out-stream (ByteArrayOutputStream.)
        in-stream (do
                    (save chart out-stream)
                    (ByteArrayInputStream.
                      (.toByteArray out-stream)))]
    in-stream))


; Chart of a server over games stats
(defn gen-game-servers-bar-chart [game]  
  (let [game-results (stats/scores-game-over-servers game)
        servers (mapv (fn [server] (server 0)) game-results)
        scores  (mapv (fn [server] (server 1)) game-results)
        chart (bar-chart servers scores
                         :title (str "Average scores in all servers for: " game)
                         :y-label "Scores"
                         :x-label "Servers")
        out-stream (ByteArrayOutputStream.)
        in-stream (do
                    (save chart out-stream)
                    (ByteArrayInputStream.
                      (.toByteArray out-stream)))]
    in-stream))
