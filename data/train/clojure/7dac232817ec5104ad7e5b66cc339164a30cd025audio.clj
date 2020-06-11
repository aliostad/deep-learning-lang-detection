(ns voip.core.audio
  (:require [manifold.stream :as s]
            [byte-streams :as bs])
  (:import (javax.sound.sampled AudioFormat DataLine$Info TargetDataLine AudioSystem AudioInputStream SourceDataLine Port Port$Info)))


(def audio-format
  (let [sample-rate (float 8000.0)
        sample-size 16
        channels 1
        signed true
        big-endian false]
    (AudioFormat. sample-rate sample-size channels signed big-endian)))


(defn capture
  "Create a voice capture stream. Optionally allows you to specify the buffer size."
  ([] (capture 2 10))

  ([frame-size buffer-size]
   (let [stream (s/stream buffer-size)
         continue (atom true)]

     (future
       (let [line-info (DataLine$Info. TargetDataLine audio-format)
             line (AudioSystem/getLine line-info)]

         (doto line
           (.open)
           (.start))

         (try
           (while @continue
             (let [buffer (byte-array frame-size)
                   read-count (.read line buffer 0 (alength buffer))]
               (when (> read-count 0)
                 (s/put! stream buffer))))

           (catch Exception e (println e))

           (finally
             (s/close! stream)))))

     {:stop   #(reset! continue false)
      :stream stream})))

(defn play-streams
  "Takes a stream of streams and mixes them"
  ([streams] (play-streams streams 100000))

  ([streams frame-size]
   (let [continue (atom true)]
     (future

       (let [line-info (DataLine$Info.  SourceDataLine audio-format)
             line (AudioSystem/getLine line-info)]

         (doto line
           (.open)
           (.start))

         (s/consume
           (fn [stream]
             (let [buffer (byte-array frame-size)
                   input-stream (bs/to-input-stream stream)
                   audio-stream (AudioInputStream. input-stream audio-format AudioSystem/NOT_SPECIFIED)]

               (try
                 (while @continue
                   ;read from the audio stream into our buffer
                   (let [read-count (.read audio-stream buffer 0 (alength buffer))]
                     ;check if we have reached the end of stream
                     (if (= read-count -1)
                       (reset! continue false)
                       (when (> read-count 1)
                         ;we actually read something, so play on speakers
                         (.write line buffer 0 read-count)))))

                 (catch Exception e (println e)))))

           streams)

         (doto line
           (.drain)
           (.close))))


     ;return a function to stop playing
     #(reset! continue false))))


(defn play-stream
  "Play a manifold stream of bytes (allows you to specify a frame size)
    this should be no smaller then the the frame-size specified in capture"

  ([stream]
   (play-stream stream 100000))

  ([stream frame-size]
   (let [continue (atom true)]

     (future
       (let [buffer (byte-array frame-size)
             input-stream (bs/to-input-stream stream)
             audio-stream (AudioInputStream. input-stream audio-format AudioSystem/NOT_SPECIFIED)
             line-info (DataLine$Info. SourceDataLine audio-format)
             line (AudioSystem/getLine line-info)]

         (doto line
           (.open)
           (.start))

         (try
           (while @continue
             ;read from the audio stream into our buffer
             (let [read-count (.read audio-stream buffer 0 (alength buffer))]
               ;check if we have reached the end of stream
               (if (= read-count -1)
                 (reset! continue false)
                 (when (> read-count 1)
                   ;we actually read something, so play on speakers
                   (.write line buffer 0 read-count)))))

           (catch Exception e (println e))

           (finally
             (doto line
               (.drain)
               (.close))))))


     ;return a function to stop playing
     #(reset! continue false))))


(defn play-streams2
  [streams]
  (let [stoppers (atom '())
        continue (atom true)]
    (s/consume
      (fn [stream]
        (when @continue
          (let [stop (play-stream stream 1000)]
            (swap! stoppers #(conj % stop)))))
      streams)
    #(do
      (swap! continue (constantly false))
      (doseq [stop @stoppers]
        (stop)))))

(defn capture-test []
  (let [frame-size 2
        {stream :stream stop :stop} (capture frame-size 0)]
    (play-stream stream frame-size)
    (Thread/sleep 20000)
    (stop)))

(defn bad-test [dropped]
  (let [frame-size 2
        {stream :stream stop :stop} (capture frame-size 0)
        derived (s/filter (fn [_] (> (rand-int 100) dropped)) stream)]
    (play-stream derived frame-size)
    (Thread/sleep 10000)
    (stop)))

(defn record-test []
  (let [{stream :stream stop :stop} (capture 2 10000)
        cached (s/stream->seq stream)
        second (s/->source cached)
        third (s/->source cached)]
    (Thread/sleep 3000)
    (stop)

    (play-stream second)
    (Thread/sleep 3000)
    (play-stream third)))

