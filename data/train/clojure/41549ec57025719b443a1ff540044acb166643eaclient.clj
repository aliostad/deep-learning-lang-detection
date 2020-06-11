(ns chat.client
  (:import (java.io BufferedReader InputStreamReader OutputStreamWriter))
  (:import (java.net Socket SocketException))
  (:import (clojure.lang LineNumberingPushbackReader)))

(defn connect
  "Create a socket bound to HOST and PORT, and return said socket plus a closure
  to send bytes through it and get the response back."
  [host port]
  (let [socket (Socket. host port)
        ;; what exactly is a pushback reader?
        read-stream (LineNumberingPushbackReader.
                     (InputStreamReader. (.getInputStream socket)))
        write-stream (OutputStreamWriter. (.getOutputStream socket))]
    [socket (fn [bytes]
              (binding [*in* read-stream
                        *out* write-stream]
                (println bytes)
                (flush)
                (read-line)))]))
