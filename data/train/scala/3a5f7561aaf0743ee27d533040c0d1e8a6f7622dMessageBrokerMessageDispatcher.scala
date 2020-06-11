package com.somepackage.plumbing.messagebroker

import akka.actor.{Actor, ActorLogging, Props}
import com.eigenroute.plumbing.MessageBrokerMessage

class MessageBrokerMessageDispatcher extends Actor with ActorLogging {

  override def receive = {

    case message: MessageBrokerMessage =>
      log.info("MessageBrokerMessage received:", message)
    case message =>
      log.info("Some other message received", message)

  }

}

object MessageBrokerMessageDispatcher {

  def props = Props(new MessageBrokerMessageDispatcher())

}
