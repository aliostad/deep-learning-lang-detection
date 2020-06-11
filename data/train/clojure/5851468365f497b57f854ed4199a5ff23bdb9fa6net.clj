(ns boids.net
	(:import (java.net DatagramPacket DatagramSocket InetAddress URL)
			 (java.io BufferedReader InputStreamReader)))
	
(def udp-socket (new DatagramSocket))

(defn udp-send [port obj]
	(let [message (pr-str obj)
		  inet-address (InetAddress/getByName "0.0.0.0")
		  packet (DatagramPacket. (.getBytes message) (.length message) inet-address port)]
	(.send udp-socket packet)))

(defn http-get [address]
	(with-open [stream (.openStream (URL. address))]
	    (let  [buf (BufferedReader. (InputStreamReader. stream))]
	      (apply str (line-seq buf)))))
