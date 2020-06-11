(ns animation-playground.streams
  (:require [cljs.core.async :as async :refer [chan timeout <! >!]])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(defn make-stream
  [handler-fn initial-state]
  (let [ch (chan 1)]
    (go
      (loop [state initial-state]
        (>! ch state)
        (recur (handler-fn state))))
    ch))

(defn compose-stream
  [handler-fn input-stream]
  (let [ch (chan 1)]
    (go
      (while true
        (>! ch (handler-fn (<! input-stream)))))
    ch))

(defn consume-stream-async
  [stream len handler-fn]
  (dotimes [_ len]
    (go
      (handler-fn (<! stream))))
  :done)

