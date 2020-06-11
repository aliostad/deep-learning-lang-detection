(ns deidara.net
  (import [java.net Socket]
	  [java.io BufferedInputStream BufferedOutputStream]
	  [java.util Scanner]))


(defn socket [ip-address port]
  "Creates a tcp client socket for the address and port"
  (Socket. ip-address port))

(defn input-stream [socket]
  "Creates a BufferedInputStream for a socket"
  (do
    (.println *err* "Opening input stream")
    (.getInputStream socket)))

(defn output-stream [socket]
  "Creates a BufferedOutputStream for a socket"
  (.getOutputStream socket))

(defn write-to [stream string]
  "Converts the string into bytes and writes to the stream"
  (.write stream (.getBytes string "ascii")))

(defn read-from [stream buff]
  "Read specified no of bytes from the stream"
  (.read stream buff))

(defn in-a-thread [func]
  "Runs the given function in a seperate thread and returns immediately"
  (.start (Thread. func)))

(defn last-index-in [string substring]
  (.lastIndexOf string substring))