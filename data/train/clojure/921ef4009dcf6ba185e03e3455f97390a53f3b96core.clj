(ns org.wol.kraken-client.core
  (:gen-class)
  (:require [clojure.contrib.classpath         :as cp]
            [wol-utils.core                    :as wol-utils]
            [clojure.contrib.logging           :as log]
            [clojure.contrib.json              :as json]
            [org.wol.kraken-client.sequencer   :as sequencer]
            [org.wol.kraken-client.audio       :as audio])
  (:use [clojure.contrib.command-line]
        [clj-etl-utils.lang-utils :only [raise]])
  (:import [net.tootallnate.websocket WebSocketClient]
           [org.apache.log4j PropertyConfigurator Logger]))

(def *ws* (atom nil))

(defn swank []
  (do (require 'swank.swank)
      (@(ns-resolve 'swank.swank 'start-repl)
       (Integer. 4006)
       :host "127.0.0.1"))
  (wol-utils/wol-info "Kraken Clients's Swank should be listening on 4006"))

(defn play-sounds-for-step [step]
  (let [step-instructions (get @sequencer/*pattern* step)
        instrument-dispatch {0 audio/*Drum1* 1 audio/*Drum2*
                             2 audio/*Drum3* 3 audio/*Drum4*}]
    (dotimes [i 4]
      (if (nth step-instructions i)
        (do
          (log/info (format "playing sound %d for step %d" i step))
          (audio/play-sound-from-atom (get instrument-dispatch i)))))))

(defn on-message [this msg]
  (let [command (:command (json/read-json msg))
        payload (:payload  (json/read-json msg))]
    (wol-utils/wol-info "OnMessage: %s" command)
    (cond
      (= command "patternChange")
      (sequencer/step-selected
       (Integer. (:step payload))
       (Integer. (:instrument payload))
       (:checked payload))

      (= command "spp")
      (do
        (wol-utils/wol-info "SPP: %s" payload)
        (play-sounds-for-step (Integer. payload)))

      (= command "volume")
      (do
        (wol-utils/wol-info "Volume Change on instrument %s to %s"
                            (:instrument payload) (:value payload))
        (audio/volume-change payload)))))


(comment
  (play-sounds-for-step 0)


  )

(defn on-close [this]
  (wol-utils/wol-info "OnClose"))

(defn on-open [this]
  (wol-utils/wol-info "OnOpen"))

(defn -main [& args]
  (with-command-line args
    "Usage..."
    [[server s "Address of Cyclops Server to connect to"]]
    (if (or (nil? server) (empty? server))
      (raise "Error:  You must specify a server" ))
    (swank)
    (wol-utils/load-log4j-file "log4j.properties")
    (wol-utils/wol-info "Server: %s" server)
    (audio/load-default-sounds)
    (let [ws-address (format "ws://%s:8080/async" server)]
      (reset!  *ws*
               (proxy [WebSocketClient] [(java.net.URI. ws-address)]
                 (onMessage [this msg]
                            (on-message this msg))
                 (onClose [this]
                          (on-close this))
                 (onOpen [this]
                         (on-open this))))
      (.connect @*ws*))))



(comment
  (cp/classpath)
  (wol-utils/wol-info "chicken")
  (def *chicken* (proxy [WebSocketClient] [(java.net.URI. "ws://localhost:8080/async")]
                   (onMessage [this msg]
                              (on-message this msg))
                   (onClose [this]
                            (wol-utils/wol-info "onClose"))
                   (onOpen [this]
                           (wol-utils/wol-info "onOpen" ))))


  (.connect *chicken*)
  (.close *chicken*)

  (-main "--server=localhost")
  )


