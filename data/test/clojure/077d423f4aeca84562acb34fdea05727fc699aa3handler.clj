(ns crowd-scribe.handler
  (:require [org.httpkit.server :refer :all]
            [cognitect.transit :as transit])
  (:import [java.io ByteArrayOutputStream ByteArrayInputStream]))

(defn parse
  "Parses transit input from websocket into Clojure object"
  [data]
  (let [in-stream (ByteArrayInputStream. (.getBytes data))]
    (transit/read (transit/reader in-stream :json))))

(defn serialize [obj]
  (let [out-stream (ByteArrayOutputStream.)]
    (transit/write (transit/writer out-stream :json) obj)
    (.toString out-stream)))


(defmulti dispatch (fn [_ msg] (:type msg)))
(defmethod dispatch :default
  [channel msg]
  (println "Missing or unknown message type")
  (send! channel (serialize [:add-error "Missing or unknown message type"])))

(defn ws-handler [request]
  (with-channel request channel
    (on-close channel (fn [status] (println "channel closed: " status)))
    (on-receive channel (fn [data] (dispatch channel (parse data))))))

