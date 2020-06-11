package info.ethanjoachimeldridge

import com.typesafe.config.ConfigFactory
import akka.actor._
import akka.io.IO
import spray.can.Http
import akka.pattern.ask
import akka.util.Timeout
import scala.concurrent.duration._
import info.ethanjoachimeldridge.config._


/** Responsible in Starting the Spray HTTP Service 
 *
 * Will setup the processing Services sand Actor to serve requests
 */
object Boot extends App {
	private implicit val system = ActorSystem("h2-tests-api-example")
	
	/** ActorSystem to manage ApiActor and it's children */
	private val apiActor = system.actorOf(Props[ApiActor], "api-actor")

	implicit val timeout = Timeout(5.seconds)
	IO(Http) ? Http.Bind(apiActor, interface = Configuration.httpInterface, port = Configuration.httpPort)
}