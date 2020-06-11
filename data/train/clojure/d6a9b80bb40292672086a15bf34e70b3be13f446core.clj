(ns tcp-server.core
  (:import
   (java.io BufferedReader InputStreamReader DataOutputStream)
   (java.net ServerSocket))
  )


(defn debug
  "write a debugging message"
  [msg]
  (println msg))

(defn text-stream-to-file
  "writes a text input stream line by line to a file"
  [in file-name]
  (with-open [w (clojure.java.io/writer file-name)]
    (loop [line (.readLine in)]
      (if (nil? line)
	true
	(do
	  (.write w (str line "\n"))
	  (recur (.readLine in)))))))

(defn handle-tcp-client
  "handles one client connection
  'Protocol' is: file name comes in the first line, file contents in the rest 
  "
  [sock]
  (with-open [in (BufferedReader. (InputStreamReader. (.getInputStream sock)))
	      out (DataOutputStream. (.getOutputStream sock))]
    (let [file-name (.readLine in)]
      (text-stream-to-file in file-name)
      )))

(defn tcp-server
  "basic tcp server"
  [port]
  (with-open [server-socket (ServerSocket. port)]
    (loop [sock (.accept server-socket)]
      (future (handle-tcp-client sock))
      (recur (.accept server-socket)))))
  
(defn -main [& args]
  (tcp-server 8080))
