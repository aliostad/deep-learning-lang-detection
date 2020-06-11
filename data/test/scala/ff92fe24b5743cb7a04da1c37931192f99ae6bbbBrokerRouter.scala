package org.elihw.manager.actor

import akka.actor.{Props, Actor}
import org.elihw.manager.mail.{BrokerHeartMail, RegisterMail}
import akka.pattern.ask
import akka.actor.Status.Status
import akka.util.Timeout
import scala.concurrent.duration._

/**
 * User: biandi
 * Date: 13-11-22
 * Time: 下午5:21
 */
class BrokerRouter extends Actor{

  def receive = {
    case registerMail:RegisterMail => {
      val broker = context.actorOf(Props[Broker], registerMail.cmd.getId.toString)
      broker ! registerMail
    }
  }
}
