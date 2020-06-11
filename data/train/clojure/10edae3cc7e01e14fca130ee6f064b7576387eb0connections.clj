(ns nsq-clojure.connections
  (:require [clojure.core.async :as async]
            [nsq-clojure.protocol :as protocol]
            [taoensso.nippy :as nippy])
  (:import [java.net Socket]
           [java.io DataInputStream BufferedInputStream PrintWriter]))

(defprotocol IConnection
  (conn-alive? [this])
  (close-conn [this])
  (write-to-conn [this message]))

(defrecord Connection [^Socket socket spec in-stream out-stream out-channel]
  IConnection
  (conn-alive? [this]
    ;; TODO: make this do something
    true)
  (close-conn [_] (.close socket))
  (write-to-conn [this message]
    (println (str "OUT: " message))
    (doto (:out-stream this)
      (.print message)
      (.flush))))

(defn log-from-listener [conn]
  (async/go
   (loop []
     (let [msg (async/<! (:out-channel conn))]
       (println (str "IN: " msg))
       (recur)))))

(defn start-new-listener! [{:keys [in-stream out-channel] :as conn}]
  (future (loop [msg ""]
            (let [in-char (char (.read in-stream))
                  curr-msg (str msg in-char)]
              (if (<= (count curr-msg) 8)
                (recur curr-msg)
                (if (= (count curr-msg) (+ 4 (protocol/message-body-length curr-msg)))
                  (if (= (apply str (drop 8 curr-msg)) "_heartbeat_")
                    (do (write-to-conn conn "NOP\n")
                        (recur ""))
                    (do (protocol/dispatch-response out-channel curr-msg)
                        (recur "")))
                  (recur curr-msg)))))))

(defn make-new-connection [{:keys [host port timeout-ms] :as spec}]
  (let [socket (doto (Socket. ^String host ^Integer port)
                 (.setTcpNoDelay true)
                 (.setKeepAlive true)
                 (.setSoTimeout ^Integer (or timeout-ms 0)))
        in-stream (-> (.getInputStream socket)
                      (BufferedInputStream.)
                      (DataInputStream.))
        out-stream (-> (.getOutputStream socket)
                       (PrintWriter.))
        out-channel (async/chan)
        conn (->Connection spec socket in-stream out-stream out-channel)]
    (start-new-listener! conn)
    (log-from-listener conn)
    conn))
