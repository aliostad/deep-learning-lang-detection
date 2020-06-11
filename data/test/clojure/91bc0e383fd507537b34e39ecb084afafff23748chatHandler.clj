(ns csci3055final.server.chatHandler
  (:require [compojure.core :refer :all]
            [org.httpkit.server :as http]
            [clojure.data.json :as json]
            [csci3055final.server.views :as views]))

(defonce websockets (atom #{}))

(defn parseJSON
  "basic JSON parsing for websocket data"
  [inputJSON]
  (first (json/read-str inputJSON)))

(defn websocketMatch
  "returns the websocket that matches the given key value pair"
  [key value]
  (first (filter #(= (get % key) value) @websockets)))

(defn sendMessageToRoom
  "sends the given message to all users in given room"
  [room message]
  ;; search through all web sockets to find the ones that are in the given room
  (doseq [client @websockets]
    (let [clientChannel (get client :channel)
          clientRoom    (get client :room)]
      (if (= room clientRoom)
          (http/send! clientChannel message)))))

(defn websocketUsername
  "with the initial connect the user sends there username"
  [websockets dataContent currChannel currRoom]
  ;; add client to list of the clients
  (swap! websockets conj {:channel currChannel
                          :room currRoom
                          :username dataContent})
  ;; let the entire room know, that the client has joined
  (sendMessageToRoom currRoom (str dataContent " has entered the chat")))

(defn websocketMessage
  "manage incomming messages"
  [websockets dataContent currChannel currRoom]
  ;; pass the message onto all necessary clients
  (let [username (get (websocketMatch :channel currChannel) :username)
        messageToSend (str username ": " dataContent)]
    (sendMessageToRoom currRoom messageToSend)))

(defn chat-handler
  "handling the chat websocket"
  [req]
  (http/with-channel req currChannel
    (let [currRoom (get (:params req) :room)]
      ;; websocket on connect
      (println (str "client connected to " currRoom))

        ;; websocket on close
      (http/on-close currChannel
        (fn [status]
          (println (str "client disconnected from " currRoom))

          ;; tell the room the user left
          (let [username (get (websocketMatch :channel currChannel) :username)]
            (sendMessageToRoom currRoom (str username " has left the chat"))

          ;; remove the channel from the list
          (swap! websockets disj (websocketMatch :channel currChannel)))))

      ;; websocket on receive
      (http/on-receive currChannel
        (fn [data]
          (let [parsedData (parseJSON data)]
            (cond
              ;; if client sends username
              (= (first parsedData) "username")
                (websocketUsername websockets (second parsedData) currChannel currRoom)
              ;; if client sends message
              (= (first parsedData) "message")
                (websocketMessage  websockets (second parsedData) currChannel currRoom))))))))
