package plumbing.messagebroker

import akka.actor.{Actor, ActorLogging, Props}
import com.eigenroute.plumbing.MessageBrokerMessage

class MessageBrokerMessageDispatcher extends Actor with ActorLogging {

  override def receive = {

    case message: MessageBrokerMessage =>
      println("MessageBrokerMessage received:", message)
    case message =>
      println("Some other message received", message)

  }

}

object MessageBrokerMessageDispatcher {

  def props = Props(new MessageBrokerMessageDispatcher())

}
