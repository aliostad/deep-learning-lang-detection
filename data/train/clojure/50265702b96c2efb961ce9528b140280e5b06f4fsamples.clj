(ns frankentone.samples
  (:use [clj-audio core sampled])
  (:import [javax.sound.sampled
            AudioFormat
            AudioInputStream]
           [java.util Date]
           [java.io ByteArrayOutputStream]))


(defn stream->byte-array [stream]
  (let [out-stream (ByteArrayOutputStream.)
       buf (byte-array (.getFrameSize ^AudioFormat (->format stream)))]
   (loop [cnt (long 0)]
     (when (> cnt -1)
       (when (> cnt 0)
         (.write ^ByteArrayOutputStream out-stream buf))
       (recur (.read ^AudioInputStream stream buf))))
   (.toByteArray out-stream)))


(defn load-sample
  "Load a sample.

  Currently only 16-bit 1-channel pcm samples are supported."
  [path-or-file]
  (let [stream (->stream path-or-file)
        format (->format-info stream) 
        spc (stream->byte-array stream)
        shorts (short-array (/ (count spc) 2))
        scaling-factor (/ 1.0 Short/MAX_VALUE)]
    (.get
     (.asShortBuffer 
      (.order 
       (java.nio.ByteBuffer/wrap spc)
       (if (= :little-endian (:endianness format))
         java.nio.ByteOrder/LITTLE_ENDIAN
         java.nio.ByteOrder/BIG_ENDIAN)))
     shorts)
    (double-array (map #(* % scaling-factor) shorts))))
