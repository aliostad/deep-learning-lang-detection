import java.io._
import java.net.Socket

import resource._

import scala.concurrent.{Channel, Future}
import scala.concurrent.ExecutionContext.Implicits.global


trait Message

object WorkerClient {
	
	val writeChannel = new Channel[String]()
	
	def connect (host: String, port: Int)(listener: (Message, String => Unit) => Unit): Unit = {
		for (connection <- managed (new Socket (host, port));
			 outStream <- managed (connection.getOutputStream);
			 inStream <- managed (new InputStreamReader (connection.getInputStream))
		) {
			val out = new PrintWriter (new BufferedWriter (new OutputStreamWriter (outStream)))
			val in = new BufferedReader (inStream)
			
			def read (): Unit = in.readLine match {
				case null
					 | _ if connection isClosed => ()
				case line =>
					parse (line, listener)
					read ()
			}
			
			def write (): Unit = writeChannel.read match {
				case "rekt" => ()
				case line if connection isClosed =>
					writeChannel write line
				case line =>
					out println line
					write ()
			}
			
			Future (write ())
			read ()
			writeChannel.write ("rekt")
		}
	}
	
	private def parse (line: String, listener: (Message, String => Unit) => Unit): Unit = {
		
	}
	
	def write (line: String): Unit = writeChannel write line
	
}