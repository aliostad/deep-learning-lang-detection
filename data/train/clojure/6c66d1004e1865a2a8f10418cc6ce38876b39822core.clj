(ns websockets.core
  (:require [aleph.http :as http]
            [manifold.stream :as stream]
            [clojure.core.async :as a]
            [clojure.string :as str])
  (:gen-class))

(def message-buffer (a/chan))
(def message-mult (a/mult message-buffer))

(defn random-name []
  (let [name-length (+ 3 (rand-int 10))]
    (apply str
           (repeatedly name-length #(rand-nth "abcdefghijklmnopqrstuvwxyz")))))

(defn echo-handler [req]
  (let [s @(http/websocket-connection req)
        name @(stream/take! s)
        user-in (a/chan)
        user-out (a/chan)]
    (stream/put! s (str "serv> hi! now your name is " name "\r\n"))
    (a/tap message-mult user-out false)
    (a/pipe user-in message-buffer false)
    (stream/connect (stream/->source user-out) s)
    (stream/connect s (stream/->sink user-in))))

(defn -main []
  (http/start-server echo-handler {:port 8181}))
