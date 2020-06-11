(ns http-clj.spec-helper.mock
  (:require [http-clj.connection :as connection]
            [http-clj.server :as server]
            [com.stuartsierra.component :as component]
            [http-clj.spec-helper.request-generator :refer [GET]])
  (:import java.io.ByteArrayInputStream
           java.io.ByteArrayOutputStream))

(defn socket
  ([input] (socket input nil))
  ([input output]
  (let [connected? (atom true)
        input-stream (ByteArrayInputStream. (.getBytes input))]
    (proxy [java.net.Socket] []
      (close []
        (reset! connected? false))

      (isClosed []
        (not @connected?))

      (getOutputStream []
        output)

      (getInputStream []
        input-stream)))))

(defn socket-server [& args]
  (let [closed? (atom false)]
    (proxy [java.net.ServerSocket] []
      (accept []
        (socket "" (ByteArrayOutputStream.)))

      (close []
        (reset! closed? true))

      (isClosed []
        @closed?))))

(defn connection
  ([] (connection ""))
  ([input] (connection input (ByteArrayOutputStream.)))
  ([input output]
   (connection/create (socket input output))))

(defrecord MockServer [started stopped]
  component/Lifecycle
  (start [server]
    (assoc server :started true))

  (stop [server]
    (-> server
        (assoc :stopped true)))

  server/Server
  (accept [server]
    (connection (GET "/" {"Host" "www.example.com"}))))

(defn server []
  (MockServer. false false))
