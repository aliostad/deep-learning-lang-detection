(ns spawn.core
  (:require [clojure.core.async :as a :refer [chan go go-loop <! >! <!! >!!]]))

(defn make-stream
  [handler-fn initial-state & [buffer-size]]
  (let [ch (chan (or buffer-size 1))]
    (go-loop [state initial-state]
      (>! ch state)
      (recur (handler-fn state)))
    ch))

(defn compose-stream
  [handler-fn input-stream]
  (let [handler-fn (if (symbol? handler-fn)
                     (ns-resolve *ns* handler-fn)
                     handler-fn)
        ch         (chan 1)]
    (go
      (while true
        (>! ch (handler-fn (<! input-stream)))))
    ch))

(defmacro defstream
  "Returns a channel that is infinitely populated."
  [stream-name handler-fn initial-state & [buffer-size]]
  (let [stream (if buffer-size
                 (make-stream (eval handler-fn) initial-state buffer-size)
                 (make-stream (eval handler-fn) initial-state))]
    `(def ~stream-name ~stream)))

(defn consume-stream-sync
  ([stream]
   (for [_ (range)]
     (<!! stream)))
  ([stream len]
   (for [_ (range len)]
     (<!! stream))))

(defn consume-stream-async
  [stream len handler-fn]
  (dotimes [_ len]
    (go
      (handler-fn (<! stream))))
  :done)
