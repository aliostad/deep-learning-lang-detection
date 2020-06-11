(import 
 '(java.net ServerSocket InetSocketAddress)
 '(java.nio.channels SocketChannel)
 '(java.io BufferedInputStream BufferedOutputStream OutputStreamWriter InputStreamReader BufferedReader))

(defn sendMessage 
  "sends a message to the server over its output stream"
  [out message]
  (.write out message)
  (.write out "\n")
  (.flush out))
 
(defn receiveMessage
  "receives a message from the server over its input stream"
  [in]
  (.readLine in))

(defn chat
      "initiate chat, start request response loop"
      [socket]
      (let [in (BufferedReader. (InputStreamReader. (BufferedInputStream. (.getInputStream socket))))
	   out (OutputStreamWriter. (BufferedOutputStream. (.getOutputStream socket)))
	   reader (BufferedReader. *in*)]
	   (println "Connected to server")
	   (loop []
	   	 (print "> ") (flush)
	   	 (let [input (.readLine reader)]
		      (sendMessage out input)
		      (println (receiveMessage in))
		      (recur)))))
	   	 

(defn client
      	"connects to the server creating a socket and
       enters chat"
      [host port]
      (let [socketAddress (InetSocketAddress. host port)
            channel (SocketChannel/open socketAddress)
	    socket (.socket channel)]
	    (chat socket)))

(client "localhost" 8765)