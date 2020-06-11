(ns net-protocols.control.core
  (:refer-clojure :exclude [read flush read-line])
  (:use [net-protocols.streams.base :as stream]))

(def ^:dynamic *current-timeout* 3000)

(defn read-until [stream until]
  (loop [buffer ""
         chr (stream/read stream *current-timeout*)]
    (when chr
      (if (= until chr)
        (str buffer chr)
        (recur (str buffer chr)
               (stream/read stream *current-timeout*))))))

(defn read-line [stream]
  (read-until stream \newline))

(defn read-until-match [stream rx]
  (loop [buffer (str (stream/read stream *current-timeout*))]
    (if (re-find rx buffer)
      buffer
      (recur (str buffer (stream/read stream *current-timeout*))))))

(defn challenge-response [stream challenge response]
  (doto stream
    (read-until-match challenge)
    (stream/write response)
    (stream/flush)))
