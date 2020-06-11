package org.cucina.engine.actors

import akka.actor.Actor
import org.cucina.engine.ProcessContext
import org.slf4j.LoggerFactory

/**
 * Created by levinev on 11/08/2015.
 */
sealed trait ProcessEvent

case class EnterEvent(processContext: ProcessContext) extends ProcessEvent

case class LeaveEvent(processContext: ProcessContext) extends ProcessEvent

trait ListenerActor
  extends Actor {
  def receive = {
    case EnterEvent(pc) => processEnter(pc)
    case LeaveEvent(pc) => processLeave(pc)
  }

  def processEnter(pc: ProcessContext):Unit

  def processLeave(pc: ProcessContext):Unit
}

class LoggingListenerActor extends ListenerActor {
  private[this] val LOG = LoggerFactory.getLogger(getClass)

  def processEnter(pc: ProcessContext) = {
    LOG.debug("Entered:" + pc)
  }

  def processLeave(pc: ProcessContext) = {
    LOG.debug("Left:" + pc)
  }
}
