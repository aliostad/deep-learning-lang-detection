(ns io.import
  "Decodes audio stream and reads it in bytes and shorts."
  (:import (java.io ByteArrayInputStream DataInputStream File))
  (:import (javax.sound.sampled AudioInputStream AudioSystem AudioFormat AudioFormat$Encoding))
  (:require [hiphip.array :as hiphip]))

(set! *warn-on-reflection* true)
(set! *unchecked-math* :warn-on-boxed)

(defn read-bytes [^AudioInputStream decoded-audio-stream byte-arr stream-size]
  (. decoded-audio-stream read byte-arr 0 stream-size))

(defn get-decoded-format [^AudioFormat base-format]
  (AudioFormat.
    (AudioFormat$Encoding/PCM_SIGNED)
    (. base-format getSampleRate)
    16
    (. base-format getChannels)
    (* 2 (. base-format getChannels))
    (. base-format getSampleRate)
    false))

(defn get-bytes [^File file]
      (let [in-audio-stream (AudioSystem/getAudioInputStream file)
            base-format (. in-audio-stream getFormat)
            ^AudioFormat decoded-format (get-decoded-format base-format)
            ^AudioInputStream decoded-audio-stream (. AudioSystem getAudioInputStream decoded-format in-audio-stream)
            stream-size (. decoded-audio-stream available)
            byte-arr (byte-array stream-size)]
        (read-bytes decoded-audio-stream byte-arr stream-size)
        byte-arr))

(defn get-shorts [^bytes bytes]
  (let [length (/ (alength bytes) 2)
        data-stream (DataInputStream. (ByteArrayInputStream. bytes))]
    (hiphip/amake Short/TYPE [x length]
                  (. data-stream readShort))))
