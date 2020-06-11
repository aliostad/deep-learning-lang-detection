/**
  * Created by arm on 5/5/16.
  */

import akka.actor.Actor
import akka.actor.ActorSystem
import akka.actor.Props

// Define Actor Message
case class GreetGuest(guestName: String)

// Define Actor
class Greeter extends Actor {
  def receive = {
    case GreetGuest(guestName) => println(s"Hello $guestName")
  }
}

object HelloAkka extends App {

  // Create ActorSystem (ensemble of actors which manage shared resources such as configuration, logging etc
  val system = ActorSystem("Hello-Akka")

  // Create Greeter Actor, if name isn't provided Akka will generate one for us
  val greeter = system.actorOf(Props[Greeter], "Greeter")

  // Use tell to send message to Actor
  greeter ! GreetGuest("Our Akka guest")

}