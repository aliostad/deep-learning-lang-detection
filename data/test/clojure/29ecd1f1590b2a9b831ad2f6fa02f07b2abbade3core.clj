(ns org.wol.kraken.core
  (:gen-class)
  (:require [clojure.contrib.classpath    :as cp]
            [clojure.contrib.duck-streams :as ds]
            [clojure.contrib.str-utils    :as str-utils]
            [clojure.contrib.json         :as json]
            [org.wol.kraken.sequencer     :as sequencer]
            [org.wol.kraken.audio         :as audio]
            [wol-utils.core               :as wol-utils]
            [org.wol.kraken.clients       :as clients]
            [wol.websockets.server        :as server]
            [clj-etl-utils.log            :as log])
  (:use [wol.websockets.server :only [*web-socket*
                                      *web-sockets*
                                      ws-respond
                                      ws-broadcast-all
                                      ws-broadcast-others ]])  
  (:import
   [org.apache.commons.codec.binary Base64]
   [java.nio.charset  Charset]
   [io.netty.handler.codec.http.websocketx TextWebSocketFrame]
   [io.netty.channel ChannelFutureListener]))


(defonce *server* (atom nil))

(defn play-sounds-for-step [step]
  (let [step-instructions (get @sequencer/*pattern* step)]
    (dotimes [i 4]
      (if (nth step-instructions i)
        (do
          (log/infof "playing sound %d for step %d" i step)
          (audio/play-sound (nth @audio/*drums* i) ))))))

;;(.setTempoInBPM sequencer/*sequencer* bpm)
(defn tempo-change [new-tempo]
  (log/infof "chaning tempo to %s" new-tempo)
  (.setTempoInBPM @sequencer/*sequencer* new-tempo))


(defn transmit-pattern-to-client []
  #^{ :doc "Transmit the current sequence to the client so that it can update the step display" }
  (log/infof "transmitting pattern to client")
  (doseq [step         (keys @sequencer/*pattern*)]
    (let [step-events  (map #(list %1 %2)
                            (get @sequencer/*pattern* step)
                            (iterate inc 0) )]
      (doseq [[checked instrument] step-events]
        (ws-respond
         (json/json-str {:command "patternChange"
                         :payload {"step"       step
                                   "instrument" instrument
                                   "checked"    checked}}
                        ))))))

(defn transmit-tempo-to-client []
  #^{ :doc "Transmit the current tempo to the newly connected client" }
  (log/infof "transmitting tempo to client")
  (ws-respond
   (json/json-str {:command "tempo"
                   :payload { :bpm  (int (.getTempoInBPM @sequencer/*sequencer*))}})))



(defn transmit-pattern-to-all-clients-for-instrument [instrument]
  (log/infof "transmitting pattern for instrument %s to all clients" instrument)
  (doseq [step         (keys @sequencer/*pattern*)]
    (let [checked      (nth (get @sequencer/*pattern* step) instrument )]
      (ws-broadcast-all
       (json/json-str {:command "patternChange"
                       :payload {"step"       step
                                 "instrument" instrument
                                 "checked"    checked}})))))

(defn wsocket-receive [msg]
  (log/infof "Received %s from websocket" msg)
  (let [parsed-msg         (json/read-json msg)
        command (:command  parsed-msg)
        payload (:payload  parsed-msg)]
    (cond
      (= command "play")
      (do
        (log/infof "Starting Sequencer")
        (.start @sequencer/*sequencer*))

      (= command "stop")
      (do
        (log/infof "Stopping Sequencer")
        (.stop @sequencer/*sequencer*))

      (= command "tempo")
      (do
        (log/infof "Tempo Change to %s bpm" (:bpm payload))
        (tempo-change (:bpm payload))
        (ws-broadcast-others msg))
      

      (= command "patternChange")
      (do
        (sequencer/step-selected (java.lang.Integer/parseInt (:step payload))
                                 (java.lang.Integer/parseInt (:instrument payload))
                                 (:checked payload))
        (ws-broadcast-others msg))

      (= command "volume")
      (do
        (log/infof "Volume Change on instrument %s to %s"
                   (:instrument payload) (:value payload))
        (audio/volume-change payload)
        (ws-broadcast-others msg))

      ;;;NB> Need to notify other clients
      (= command "drumChange")
      (do
        (log/infof "Drum Change on instrument %s to %s"
                   (:instrument payload) (:drum payload))
        (audio/replace-sound (java.io.File. (str "drums/" (:drum payload))) (:instrument payload)))

      (= command "blue")
      (let [slider-value  (:value payload)
            instrument    (:instrument payload)
            new-pattern   (reverse (sequencer/lpad-binary-list (sequencer/int->binary-list slider-value) 16))]

        (log/infof "Generative command(blue) slider %s for instrument %s" slider-value instrument)
        (log/infof "new pattern: %s"  new-pattern)
        (doseq [[step new-value] (partition 2
                                            (interleave
                                             (range 16)
                                             new-pattern))]
          (sequencer/step-selected step instrument new-value))

        (transmit-pattern-to-all-clients-for-instrument instrument))


      :else      
      (ws-broadcast-others  msg))))


(defn transmit-drums-to-client [ch]
  #^{ :doc "Trasnmit the audio data to the client so they can play it"}
  (log/infof "Transmitting audio data to client")
  (ws-respond
   (json/json-str {:command "audioData"
                   :payload {"number"       0
                             "data"    (audio/mine-audio-data (nth @audio/*drums* 0))}})))

(defn post-ws-handshake []
  #^{ :doc "handler that is triggered when a web socket connection is established from the client"}
  (log/infof "WebSocket connection. Adding new client to web-socket-list")
  (if-not (some :clip  @audio/*drums*)
    (audio/load-default-sounds)
    (log/infof "Reconnecting to active session.  NOT reloading sounds."))

  ;;trasnmit drum file list
  (clients/transmit-drum-list)

  ;;transmit audio data
  #_(transmit-drums-to-client)

  ;;transmit audio volumes
  (audio/transmit-volumes-to-client)

  ;;set up sequencer callback
  (let [spp-callback (fn [step]
                       (play-sounds-for-step (Integer. step))
                       (log/infof "sending out spp")
                       (ws-broadcast-all    (json/json-str {:command "spp"
                                                            :payload step })))]
    
    (if (or (not @sequencer/*sequencer*)
            (not (.isOpen @sequencer/*sequencer*)))
      (do
        (log/infof "No open sequencer found. Creating new one.")
        (sequencer/init-sequencer spp-callback)
        (reset! sequencer/*midi-receive-spp-fn* spp-callback))

      (do
        (transmit-pattern-to-client)
        (transmit-tempo-to-client)))))

(defn start-server []
  (wol-utils/load-log4j-file "log4j.properties")
  (log/infof "starting server")
  (reset! *server*
          (server/start-netty-server
           {:message-received     wsocket-receive
            :post-ws-handshake    post-ws-handshake
            :port 8081})))

(defn shutdown-server []
  (.close @*server*)
  (reset! *server* nil)
  #_(close-web-sockets)
  (audio/clear-sounds)
  (if @sequencer/*sequencer*
    (.close @sequencer/*sequencer*)))

(defn restart-server []
  (shutdown-server)
  (start-server))

(defn -main []
  (start-server))


(comment

  (start-server)
  *server*
  (shutdown-server)
  
  @*web-sockets*
  
  
  (.write (first @channels) (TextWebSocketFrame. "howdy"))

  
  )
