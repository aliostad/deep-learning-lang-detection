(ns mini-mud.client.core
  (:require [aleph.tcp]
            [manifold.stream :as mstream]
            [byte-streams :as bs])
  (:import [java.net ServerSocket Socket SocketException]
           [java.io InputStreamReader OutputStreamWriter BufferedReader]))

(defn- handle-messages
  [stream]
  (try
    (loop []
      (if-let [bytes @(mstream/take! stream)]
        (let [msg (bs/to-string bytes)]
          (do (println msg)
            (recur)))
        (do (println "Disconnected")
          (mstream/close! stream))))
    (catch Exception e
      (println (.getMessage e)))))

(defn- send-messages
  [stream]
  (loop [msg (read-line)]
    (if (= msg "quit")
      (println "quit")
      (do @(mstream/put! stream msg)
        (Thread/sleep 50)
        (recur (read-line)))))
  (mstream/close! stream))

(def instructions
  (str
   "Available commands:\r\n"
   "say [message]\r\n"
   "sayto [username] [message]\r\n"
   "north\r\n"
   "south\r\n"
   "west\r\n"
   "east\r\n"
   "exit\r\n"))

(defn run
  [host port]
  (println instructions)
  (try (let [stream @(aleph.tcp/client {:host host, :port port})]
         (future (handle-messages stream))
         (future (send-messages stream)))
    (catch Exception e
      (println (.getMessage e)))))
