(ns voip.core.util
  (:require [manifold.stream :as s]
            [taoensso.nippy :as nippy]
            [gloss.core :as gloss]
            [gloss.io :as gloss.io])
  (:import (java.net ServerSocket DatagramSocket)))

(defn prompt [handle prompt-str]
  "Prompt for and invoke handle with the user input,
   if handle returns truthy, the prompt will prompt again"
  (print prompt-str)
  (flush)
  (if (handle (read-line))
    (prompt handle prompt-str)
    "Have a nice day!"))


(defn write [stream msg]
  "Accepts a valid stream and returns a function that accepts edn and writes that to the stream"
  @(s/try-put! stream msg 0))

(def protocol
  (gloss/compile-frame
    (gloss/finite-frame :uint32
                        (gloss/repeated :byte :prefix :none))
    nippy/freeze
    #(nippy/thaw (byte-array %))))

(defn wrap-duplex-stream
  [s]
  (let [out (s/stream)]
    (s/connect
      (s/map #(gloss.io/encode protocol %) out)
      s)
    (s/splice
      out
      (gloss.io/decode-stream s protocol))))


(defn wrap-voice-stream
  [raw-udp-stream peers me]
  (let [microphone-stream (s/stream)
        call-audio-stream-stream (s/stream)
        tracker (atom {})]


    ;Read the voice data off the line and write it to call audio stream
    (s/consume
      (fn [packet]
        (let [{message :message} packet
              stream-identifier (str (:sender packet))]

          (when (not (s/closed? call-audio-stream-stream))
            (when (not (contains? @tracker stream-identifier))
              ; add a new stream
              (let [stream (s/stream)]
                (swap! tracker #(assoc % stream-identifier stream))
                (s/put! call-audio-stream-stream (s/->source stream))))

            ; Send the recieved data along
            (let [packet-stream (get @tracker stream-identifier)]
              (s/put! packet-stream message)))))

      raw-udp-stream)

    ;microphone -> udp
    (s/consume
      (fn [data]
        (doseq [peer peers]
          (let [{port :port ip :ip} peer]
            (when (not (= peer me))
              (s/put! raw-udp-stream
                      {:port    port
                       :host    ip
                       :message data})))))
      microphone-stream)


    [(s/->source call-audio-stream-stream) (s/->sink microphone-stream)]))

(defn aquire-port
  [port-range]
  (loop [ports port-range]
    (let [open (atom true)
          port (first ports)]
      (try
        (doto (ServerSocket. port)
          (.setReuseAddress true)
          (.close))

        (doto (DatagramSocket. ^int port)
          (.setReuseAddress true)
          (.close))

        (catch Exception e (reset! open false)))

      (if @open
        port
        (if (empty? ports)
          nil
          (recur (pop ports)))))))
