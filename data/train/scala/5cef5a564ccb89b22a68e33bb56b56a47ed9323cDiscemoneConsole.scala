package org.bustos.discemone

import akka.actor.{ Actor, ActorRef, Props, ActorSystem }
import akka.actor.Stash
import akka.actor.ActorLogging

/** Console input controller for Discemone
 *
 * This actor helps manage the console input and send it up
 * to the Discemone controller. 
 */

object DiscemoneConsole { 
  case class ConsoleInput(inputString: String)
}

class DiscemoneConsole extends Actor with ActorLogging with Stash  {

  import DiscemoneConsole._

  for (ln <- io.Source.stdin.getLines) context.parent ! ConsoleInput(ln)
    
  def receive = {    
  	case other => 
  }
}