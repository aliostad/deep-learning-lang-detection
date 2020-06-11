package example

import com.typesafe.config.ConfigFactory
import akka.actor._
import akka.io.IO
import spray.can.Http
import akka.pattern.ask
import akka.util.Timeout
import scala.concurrent.duration._

object Boot extends App {	
	private implicit val system = ActorSystem("example-api")
		
	/** ActorSystem to manage HttpRoutingActor and it's children */
	private val httpRoutingActor = system.actorOf(Props(new HttpRoutingActor), "http-service")

	val conf = ConfigFactory.load()
	val onOrOff = conf.getString("spray.can.server.transparent-head-requests")
	println(onOrOff)
	
	implicit val timeout = Timeout(5.seconds)	
	IO(Http) ? Http.Bind(httpRoutingActor, interface = "localhost", port = 9002)
}