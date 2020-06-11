import java.io._
import java.net.Socket

import resource.managed

import scala.concurrent.Channel

object DataClient {
	
	val writeChannel = new Channel[String]()
	val readChannel = new Channel[Array[Byte]]()
	
	def connect (host: String, port: Int): Unit = {
		for (connection <- managed (new Socket (host, port));
			 outStream <- managed (connection.getOutputStream);
			 inStream <- managed (new InputStreamReader (connection.getInputStream))
		) {
			val out = new PrintWriter (new BufferedWriter (new OutputStreamWriter (outStream)))
			val in = new BufferedReader (inStream)
			
			def readWrite (): Unit = {
				val send = writeChannel read
				
				if (connection isClosed) {
					writeChannel write send
					return ()
				}
				
				out println send
				in readLine match {
					case null =>
						writeChannel write send
					case line =>
						readChannel write line.getBytes
						readWrite ()
				}
				
			}
			
			readWrite ()
		}
	}
	
	def send (s: String): Array[Byte] = {
		writeChannel write s
		readChannel read
	}
	
}
