(ns theater.audio
  (:require [clojure.java.shell :refer [sh]])
  (:import [java.io File]
           [javax.sound.sampled AudioSystem]))

(defn- path->wav-file [path]
  (let [file (File/createTempFile "theater" ".wav")]
    (sh "ffmpeg" "-i" path (.getAbsolutePath file) "-y")
    file))

(defn- stream->audio-info [stream]
  (let [frame-rate (-> stream .getFormat .getFrameRate)]
    {:duration (/ (.getFrameLength stream) frame-rate)
     :frame-rate frame-rate}))

(defn- file->audio-info [file]
  (-> file
      AudioSystem/getAudioInputStream
      stream->audio-info
      (assoc :path (.getAbsolutePath file))))

(defn- bytes->uint [bytes]
  (loop [bytes (reverse bytes) sum 0]
    (if (seq bytes)
      (recur (rest bytes)
             (+ (* sum 256)
                (+ (first bytes) 128)))
      sum)))

(defn- bytes->float [bytes]
  (/ (bytes->uint bytes)
     (Math/pow 256 (count bytes))))

(defn- parse-frame [sample-size bytes]
  (map bytes->float
       (partition sample-size bytes)))

(defn- get-sample-size [stream]
  (/ (-> stream .getFormat .getSampleSizeInBits) 8))

(defn- read-next-audio-frame [stream]
  (let [bytes (byte-array (-> stream .getFormat .getFrameSize))]
    (.read stream bytes)
    (parse-frame (get-sample-size stream) bytes)))

(defn- read-audio-frames [stream]
  (repeatedly (.getFrameLength stream)
              #(read-next-audio-frame stream)))

(defn- path->audio-frames [path]
  (-> path
      File.
      AudioSystem/getAudioInputStream
      read-audio-frames))

(defn load-audio [path]
  (-> path
      path->wav-file
      file->audio-info))

(defn get-audio-frames [audio]
  (path->audio-frames (:path audio)))

(defn play-audio [audio]
  (.exec (Runtime/getRuntime)
         (str "aplay " (:path audio))))

(defmacro with-audio-playing [audio & body]
  `(let [process# (play-audio ~audio)]
     ~@body
     (.destroy process#)))
