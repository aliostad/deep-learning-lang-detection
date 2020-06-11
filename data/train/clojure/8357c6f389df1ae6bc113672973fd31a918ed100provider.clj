(ns tv.zapps.purkinje.provider
  (:use [tv.zapps.purkinje.constants])
  (:import java.io.DataInputStream))

(defn- get-sample [datainputstream]
  "gets an audio sample from the stream. Note that this modifies the stream"
  (.readFloat datainputstream))
      
(defn- lazy-sequence-from-stream [stream]
  (lazy-seq
    (when-let [sample (get-sample stream)]
      (cons sample (lazy-sequence-from-stream stream)))))

(defn sequence-from-device [device freqency-mhz]
  "Takes a v4l2 device and freqency, and returns a lazy PCM stream sequence from this"
  (->>
   (TUNING_COMMAND device freqency-mhz)
   (into-array String)
   (.exec (Runtime/getRuntime))
   (.waitFor))
  (let [process (->>
                 device
                 FFMPEG_COMMAND ;already makes the stream mono 16 bit at the right sample-rate
                 (into-array String)
                 (.exec (Runtime/getRuntime)))
        errorstream (.getErrorStream process)]
    (.start (Thread. #(loop [] (.read errorstream) (recur)))) ; dump errorstream to /dev/null -- perhaps an idea to save last 200 bytes in case of error?
    (->
     process
     .getInputStream
     (DataInputStream.)
     lazy-sequence-from-stream)))
