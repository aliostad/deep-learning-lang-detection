(ns cathode.streams
  (:require [clojure.string :refer [includes?]]))

(defn type [stream]
  (aget stream "codec_type"))

(defn codec [stream]
  (aget stream "codec_name"))

(defn channels [stream]
  (aget stream "channels"))

(defn default [maybe-nil v]
  (if (nil? maybe-nil) v maybe-nil))

(defn language [stream]
  (if-let [lang (-> stream
                    (aget "tags")
                    (default #js {})
                    (aget "language"))]
    (if (= lang "und") "--" lang)
    "--"))

(defmulti apple-tv-compat (comp keyword type))
(defmethod apple-tv-compat :video [stream]
  (= (codec stream) "h264"))
(defmethod apple-tv-compat :audio [stream]
  (let [channels (channels stream)
        codec (codec stream)]
    (or
      (and (<= channels 2) (or (= codec "ac3") (= codec "aac")))
      (and (> channels 2) (= codec "ac3")))))
(defmethod apple-tv-compat :subtitle [stream]
  (= (codec stream) "mov_text"))
(defmethod apple-tv-compat :container [stream]
  (includes? (codec stream) "mp4"))
