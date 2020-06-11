(ns ironlambda.performance
  "Convenience functions for playing music."
  (:use [overtone.live])
  (:require [ironlambda.score :refer [play]]
            [overtone.inst.sampled-piano :refer [sampled-piano]]))

(defn perform
  "Play a playable structure on an instrument with a number of beats per minute (default is 120)."
  ([instrument playable bpm]
     (let [m (metronome bpm)]
       (play instrument m (m) playable)))
  ([instrument playable]
     (perform instrument playable 120)))

(def piano (partial perform sampled-piano))
