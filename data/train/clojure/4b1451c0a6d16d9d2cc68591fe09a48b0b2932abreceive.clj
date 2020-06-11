(ns iceclient.receive
  (:require [clojure.contrib.http.agent :as http])
  (:import [javazoom.jl.player Player]
           [javazoom.spi.mpeg.sampled.file.tag IcyInputStream TagParseListener]
           [java.io File BufferedInputStream FileNotFoundException]))


(defn- buffered-input-stream
  "Translates an http-agent into a BufferedInputStream."
  [http-agent]
  (BufferedInputStream. (::http/response-stream @http-agent)))

(defn- icy-stream
  [http-agent metadata]
  "Return an IcyStream that updates the atom metadata when processing data from http-agent."
  (let [listener (reify TagParseListener
                        (tagParsed [this tpe] ; TagParseEvent
                                   (let [tag (.getTag tpe)]
                                     (swap! metadata assoc (keyword (.getName tag)) (.getValue tag)))))]
    ; first setup the header variables
    (swap! metadata into ; put into metadata
           (map #(vector (-> % key str (.substring 5) keyword) (val %)) ; kev-vals with :icy stripped off
                (filter #(-> % key str (.startsWith ":icy")) (http/headers http-agent))))   ; all the :icy headers
    ; then setup then setup and return the icy stream
    (doto (IcyInputStream. (::http/response-stream @http-agent) (:icy-metaint (http/headers http-agent)))
      (.addTagParseListener listener))))

(defn- play
  "Given a url, play the data stream.  afn translates the InputStream to another
  class (eg buffered-input-stream)."
  [url afn & [headers]]
  (let [handler #(.play (Player. (afn %)))]
    (http/http-agent url :handler handler :headers headers)))

(defn stop
  "Given a player, stop the player by stopping and closing the http connection."
  [player]
  (when-let [is (::http/response-stream @player)]
    (.close is)))

(defn play-url
  "Uses the default Java sound output to play the mp3 stream given.  It is non
  blocking, and immediatly returns the agent playing the music."
  [url]
  (play url buffered-input-stream))

(defn play-icy
  "Uses the default java sound output to play an IcyStream (icecast audio with
  inline metadata).  It is non blocking, and immediatly returns the agent
  playing the music.
  
  metadata is an (atom {}) that will be updated with the stream metadata.
  "
  [url metadata]
  (play url #(icy-stream % metadata) {"Icy-Metadata" "1"}))
