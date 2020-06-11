(ns echo-server.core
  (:import [jline.console ConsoleReader])
  (:gen-class))

(defn uint32 [data]
  (.getInt (java.nio.ByteBuffer/wrap data)))

(defn rawrecv [nr stream]
  (let [buf (byte-array nr)]
    (for [i (range nr)] (aset-byte buf i (.read stream)))
    buf))

(defn recv [stream]
  (let [len (uint32 (rawrecv 4 stream))]
    (println "recv" len "bytes")
    (rawrecv len stream)))

(defn rawsend [stream data]
  (dorun (map #(.append stream (char %)) data)))

(defn send [stream payload]
  (when-let [len (count payload)]
    (let [header (byte-array 4)]
      (println "sending" len "bytes")
      (.putInt (java.nio.ByteBuffer/wrap header) len)
      (rawsend stream header)
      (rawsend stream payload)
      (.flush stream))))

(defn -main
  "loops forever echoing stdin packets to stdout"
  [& args]
  (send *out* (recv *in*)))

  
