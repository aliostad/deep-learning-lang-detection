;;;
;;; Wordwhiz -- A letter tile game
;;;
;;; Copyright (c) R. Lonstein
;;; Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
;;;

(ns wordwhiz.clj.audio
  (:import (java.io File)
           (javax.sound.sampled AudioFormat
                                AudioFormat$Encoding
                                AudioInputStream
                                AudioSystem
                                Clip
                                DataLine
                                DataLine$Info
                                LineEvent
                                LineEvent$Type
                                LineListener
                                LineUnavailableException)
           (org.kc7bfi.jflac FLACDecoder)))


(defn is-pcm? [audio-stream]
  (= (.. audio-stream (getFormat) (getEncoding)) AudioFormat$Encoding/PCM_SIGNED))

(defn stream-to-pcm [audio-stream]
  "convert audio input stream to a pcm stream"
  (let [ audio-format (. audio-stream getFormat)
         new-format (AudioFormat. AudioFormat$Encoding/PCM_SIGNED
                                  (. audio-format getSampleRate)
                                  16
                                  (. audio-format getChannels)
                                  (* 2 (. audio-format getChannels))
                                  (. audio-format getSampleRate)
                                  false) ]
    (AudioSystem/getAudioInputStream new-format audio-stream)))

(defn coerce-stream-to-pcm [audio-stream]
  (if-not (is-pcm? audio-stream) (stream-to-pcm audio-stream) audio-stream))

(defn get-audio-input-stream [url]
  (coerce-stream-to-pcm (AudioSystem/getAudioInputStream url)))

;; (defn get-audio-input-stream [filename]
;;   (coerce-stream-to-pcm (AudioSystem/getAudioInputStream (File. filename))))

(defn listener-event-types []
  "Return mapping of event names to underlying implementation types"
  {
   :start (LineEvent$Type/START)
   :stop  (LineEvent$Type/STOP)
   :open  (LineEvent$Type/OPEN)
   :close (LineEvent$Type/CLOSE)
   }
  )

(defn play-sound [url & [listener-fn event-type]]
  (let [
        stream (get-audio-input-stream url)
        format (. stream getFormat)
        info (DataLine$Info. Clip format)
        #^Clip clip (AudioSystem/getLine info)
        ]
    (if-not (nil? listener-fn)
      (. clip addLineListener (proxy [LineListener] []
                                (update [event]
                                  (if (= (. event getType) event-type)
                                    (listener-fn event))))))
    (.open clip stream)
    (.start clip)))
