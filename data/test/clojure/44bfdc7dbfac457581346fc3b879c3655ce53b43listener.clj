(ns slack-slurper.listener
  (:require [manifold.stream :as s]
            [clojure.core.async :as a]
            [clojure.tools.logging :as log]))

(defn listen
  "Takes a stream, callback function, and a kill-switch
   atom. Starts an asynchronous loop that watches for messages
   on the stream as long as the switch is true and invokes
   the callback on them.
   Callback should be a function of 1 argument"
  [stream f switch]
  (a/go
    (while (and @switch (not (s/closed? stream)))
      (f @(s/take! stream)))
    (log/info "Stream closed. Exiting. Stream: " stream)))
