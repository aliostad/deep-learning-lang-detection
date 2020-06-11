(ns kata.socket-writer-spec
  (:use speclj.core)
  (:require [kata.socket-writer :as writer])
  (import java.io.ByteArrayOutputStream))

(defn mock-response []
  (hash-map :status "HTTP/1.1 200 OK\r\n"
            :connection "Connection: close\r\n"
            :server "Server: BoomTown\r\n"
            :content-length "Content-Length: 3\r\n"
            :content-type "Content-Type: text/plain\r\n"
            :body "\r\nACK\r\n"))

(defn mock-output-stream []
  (ByteArrayOutputStream. ))

(describe "write-socket"
  (it "writes the response to the socket"
      (let [output-stream (mock-output-stream)]
      (writer/write-socket output-stream (mock-response))
      (should= "HTTP/1.1 200 OK\r\nConnection: close\r\nServer: BoomTown\r\nContent-Type: text/plain\r\n\r\nACK\r\n\r\n" (.toString output-stream)))))
