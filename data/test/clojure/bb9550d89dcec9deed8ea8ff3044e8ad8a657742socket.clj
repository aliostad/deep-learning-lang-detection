(ns socklet.socket
  (:refer-clojure :exclude [read])
  (:import [java.net ServerSocket Socket]
           [java.io InputStream OutputStream])
  (:require [socklet.event :as event]
            [socklet.utils :as utils]))

(defn create-server
  [port]
  (ServerSocket. port))

(defn close-socket
  [^Socket socket]
  (.close socket))

(defn accept
  [^Socket server]
  (.accept server))

(defn create-socket
  [host port]
  (Socket. host port))

(defn get-streams
  "Returns a [input output] stream pair."
  [^Socket socket]
  [(.getInputStream socket) (.getOutputStream socket)])

(defn read-available
  [^InputStream input-stream]
  (.available input-stream))

(defn write
  "Writes a string or a byte array to an output stream."
  [^OutputStream stream data]
  (.write stream (if (string? data) (.getBytes data) data)))

(defn read
  "Reads a byte from an input stream."
  [^InputStream stream]
  (.read stream))

(defn read-byte-stream
  "Reads a stream of bytes into a byte array until no more
  bytes are available to be read."
  [input]
  (loop [bytes []]
    (if (not= 0 (read-available input))
      (let [b (read input)]
        (recur (conj bytes b)))
      (if (empty? bytes)
        (recur bytes)
        bytes))))

(defn read-and-handle-byte-stream
  [input f]
  (f (read-byte-stream input)))

(def listen
  (partial event/listen-for read-and-handle-byte-stream))

(defn server-listen
  [server handler]
  (future
    (utils/repeatedly-call #(handler (accept server)))))

(defprotocol CReadable
  (read-from [ch]))

(defprotocol CWritable
  (write-to [ch]))

(defprotocol CClosable
  (channel-close [ch]))

(defrecord Channel [^Socket socket
                    ^InputStream in-stream
                    ^OutputStream out-stream
                    futures]
  CReadable
  (read-from [ch] (.read in-stream))

  CWritable
  (write-to [ch] (.write out-stream))

  CClosable
  (channel-close [ch]
    (map future-cancel @futures)
    (close-socket socket)))

(defn make-channel
  [socket]
  (let [[in out] (get-streams socket)]
    (->Channel socket in out (atom []))))

(defn start-server
  [handler {:keys [port] :as opts}]
  (let [server (create-server port)
        conns {:server server :channels (atom [])}
        handle-inc-conn (fn [socket]
                          (let [ch (make-channel socket)]
                            (swap! (:channels conns) conj ch)
                            (handler ch)))]
    (assoc conns :listener (server-listen server handle-inc-conn))))

(defn respond-on
  [ch handler]
  (let [f (listen (:in-stream ch) handler)]
    (swap! (:futures ch) conj f)))

(defn close-all [{:keys [server listener channels] :as s}]
  (future-cancel listener)
  (close-socket server)
  (map channel-close @channels)
  true)
