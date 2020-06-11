(ns node.stream
  (:require [cljs.core.async :as async]))

(defn pipe-events->channel
  "Pipes all the stream errors events into given
  channel"
  [event-emitter event-type channel]
  (.on event-emitter event-type #(async/put! channel %)))

(defn pipe-channel->stream
  "Pipes data from the given channel to a given
  writable node stream"
  [channel stream]
  (letfn [(forward [chunk]
                   (if (nil? chunk)
                     (.end stream)
                     (.write stream chunk resume)))
          (resume [] (async/take! channel forward))]
    (.once stream "close" #(async/close! channel))
    (resume)))

(defn pipe-stream->channel
  "Pies data from the given readable node stream to
  a given channel"
  [stream channel]
  (.on stream "readable" #(async/put! channel (.read stream)))
  (.once stream "end" #(async/close! channel)))
